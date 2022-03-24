import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/helper/AlertHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/helper/StringHelper.dart';
import 'package:water_drinking_reminder/inputfilter/HeightFeetRangeTextInputFormatter.dart';
import 'package:water_drinking_reminder/inputfilter/WeightLBRangeTextInputFormatter.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/AppTheme.dart';
import 'package:water_drinking_reminder/style/CustomInputDecoration.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class UpdateHeightScreen extends StatefulWidget {
  final Function callback;

  const UpdateHeightScreen({Key key, this.callback}) : super(key: key);

  @override
  UpdateHeightScreenState createState() => UpdateHeightScreenState();
}

class UpdateHeightScreenState extends State<UpdateHeightScreen> {
  TextEditingController heightInputController = new TextEditingController();
  final FocusNode _heightFocus = FocusNode();

  bool isCM=false;
  String height="";

  List<String> lstHeightInFeet = [];
  List<String> lstHeightInCm = [];

  @override
  void initState() {
    super.initState();
    //_heightFocus.requestFocus();

    getHeightList();

    loadData();
  }

  loadData() async{
    height = (await SharedPref.readPreferenceValue(PERSON_HEIGHT, PrefEnum.STRING)??"5.0");
    isCM = await SharedPref.readPreferenceValue(PERSON_HEIGHT_UNIT, PrefEnum.BOOL);

    heightInputController.text = height;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: InkWell(
          onTap: () {
            NavigatorHelper.remove();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20),
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          NavigatorHelper.remove();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColor.appBgColor,
                        ),
                      ),
                    ),
                    Text(
                      buildTranslate(context,"height"),
                      style: Fonts.addContainerTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(isCM?3:4),
                        isCM?WeightLBRangeTextInputFormatter(min: 60, max: 240):HeightFeetRangeTextInputFormatter(min: 2),
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return buildTranslate(context,"height_validation");
                        } else {
                          return null;
                        }
                      },
                      controller: heightInputController,
                      style: Fonts.authLabelStyle,
                      keyboardType: TextInputType.number,
                      autocorrect: true,
                      cursorColor: AppTheme.lightTheme.cursorColor,
                      enableSuggestions: true,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      decoration: CustomInputDecoration.getInputDecorationBlue(text: buildTranslate(context,""),
                      ),
                      focusNode: _heightFocus,
                      onFieldSubmitted: (term) {
                        _heightFocus.unfocus();
                      },
                      onChanged: (value) {
                        //saveHeightData();
                      },
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {

                            if(isCM)
                              return;

                            setState(() {
                              isCM = true;
                            });

                            Future.delayed(Duration.zero, (){

                              if(heightInputController.text.toString().trim().isNotEmpty) {
                                int final_height_cm=61;


                                try {

                                  String tmp_height=StringHelper.getData(heightInputController.text.toString().trim());

                                  int d= (double.parse(heightInputController.text.toString().trim())).toInt();

                                  print(tmp_height);
                                  print(d);
                                  print(tmp_height.indexOf("."));

                                  if(tmp_height.indexOf(".")>0){
                                    String after_decimal = tmp_height.substring(tmp_height.indexOf(".") + 1);

                                    if(after_decimal.isNotEmpty){
                                      int after_decimal_int = int.parse(after_decimal);

                                      double final_height = ((d * 12) + after_decimal_int).toDouble();

                                      final_height_cm = (final_height * 2.54).round();
                                    }
                                    else{
                                      final_height_cm = (d * 12 * 2.54).round();
                                    }
                                  }
                                  else{
                                    final_height_cm = (d * 12 * 2.54).round();
                                  }
                                }
                                catch(e){}

                                print(final_height_cm);

                                for(int k=0;k<lstHeightInCm.length;k++)
                                {
                                  if(int.parse(lstHeightInCm[k])==final_height_cm) {

                                    heightInputController.text = StringHelper.getData(lstHeightInCm[k]);
                                    heightInputController.selection = TextSelection.fromPosition(TextPosition(offset: heightInputController.text.length));

                                    print("PAGE : "+k.toString());

                                    break;
                                  }
                                }

                                //saveHeightData();
                              }

                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 30.0,
                            padding: EdgeInsets.all(2.0),
                            decoration: new BoxDecoration(
                              color: isCM
                                  ? AppColor.appDarkSkyBlue
                                  : AppColor.appSwitchOffColor,
                              borderRadius: new BorderRadius.only(
                                  topLeft:
                                  new Radius.circular(15.0),
                                  bottomLeft:
                                  new Radius.circular(15.0)),
                            ),
                            child: Center(
                              child: Text(
                                buildTranslate(context,"cm"),
                                style: Fonts.metreLabelTextStyle,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {

                            if(!isCM)
                              return;

                            setState(() {
                              isCM = false;
                            });

                            Future.delayed(Duration.zero, (){
                              if(heightInputController.text.toString().trim().isNotEmpty) {
                                String final_height_feet = "5.0";


                                try {
                                  int d = double.parse(heightInputController.text.toString().trim()).toInt();

                                  int tmp_height_inch = (d / 2.54).round();

                                  int first = tmp_height_inch ~/12;
                                  int second = tmp_height_inch %12;

                                  final_height_feet = first.toString() + "." + second.toString();
                                }
                                catch(e){}

                                for(int k=0;k<lstHeightInFeet.length;k++)
                                {
                                  if(StringHelper.getData(final_height_feet)==lstHeightInFeet[k]) {

                                    heightInputController.text = StringHelper.getData(lstHeightInFeet[k]);
                                    heightInputController.selection = TextSelection.fromPosition(TextPosition(offset: heightInputController.text.length));

                                    print("PAGE : "+k.toString());


                                    break;
                                  }
                                }

                                //saveHeightData();
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 30.0,
                            padding: EdgeInsets.all(5.0),
                            decoration: new BoxDecoration(
                              color: !isCM
                                  ? AppColor.appDarkSkyBlue
                                  : AppColor.appSwitchOffColor,
                              borderRadius: new BorderRadius.only(
                                  topRight:
                                  new Radius.circular(15.0),
                                  bottomRight:
                                  new Radius.circular(15.0)),
                            ),
                            child: Center(
                              child: Text(
                                buildTranslate(context,"feet"),
                                style: Fonts.metreLabelTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                    SizedBox(
                      height: 20.0,
                    ),
                    ButtonView(
                      buttonTextName: buildTranslate(context,"save"),
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {

                        if(heightInputController.text.toString().trim().isEmpty){
                          AlertHelper.showToast(buildTranslate(context, "height_validation"));
                        }
                        else {
                          saveHeightData();
                        }

                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  saveHeightData(){
    SharedPref.savePreferenceValue(PERSON_HEIGHT, heightInputController.text.toString().trim());
    SharedPref.savePreferenceValue(PERSON_HEIGHT_UNIT, isCM);

    print("SAVE HEIGHT DATA");
    if(widget.callback!=null){
      widget.callback(isCM, heightInputController.text.toString().trim());
    }

    NavigatorHelper.remove(value: true);
  }

  void getHeightList() {
    lstHeightInFeet.clear();
    lstHeightInFeet.add("2.0");
    lstHeightInFeet.add("2.1");
    lstHeightInFeet.add("2.2");
    lstHeightInFeet.add("2.3");
    lstHeightInFeet.add("2.4");
    lstHeightInFeet.add("2.5");
    lstHeightInFeet.add("2.6");
    lstHeightInFeet.add("2.7");
    lstHeightInFeet.add("2.8");
    lstHeightInFeet.add("2.9");
    lstHeightInFeet.add("2.10");
    lstHeightInFeet.add("2.11");
    lstHeightInFeet.add("3.0");
    lstHeightInFeet.add("3.1");
    lstHeightInFeet.add("3.2");
    lstHeightInFeet.add("3.3");
    lstHeightInFeet.add("3.4");
    lstHeightInFeet.add("3.5");
    lstHeightInFeet.add("3.6");
    lstHeightInFeet.add("3.7");
    lstHeightInFeet.add("3.8");
    lstHeightInFeet.add("3.9");
    lstHeightInFeet.add("3.10");
    lstHeightInFeet.add("3.11");
    lstHeightInFeet.add("4.0");
    lstHeightInFeet.add("4.1");
    lstHeightInFeet.add("4.2");
    lstHeightInFeet.add("4.3");
    lstHeightInFeet.add("4.4");
    lstHeightInFeet.add("4.5");
    lstHeightInFeet.add("4.6");
    lstHeightInFeet.add("4.7");
    lstHeightInFeet.add("4.8");
    lstHeightInFeet.add("4.9");
    lstHeightInFeet.add("4.10");
    lstHeightInFeet.add("4.11");
    lstHeightInFeet.add("5.0");
    lstHeightInFeet.add("5.1");
    lstHeightInFeet.add("5.2");
    lstHeightInFeet.add("5.3");
    lstHeightInFeet.add("5.4");
    lstHeightInFeet.add("5.5");
    lstHeightInFeet.add("5.6");
    lstHeightInFeet.add("5.7");
    lstHeightInFeet.add("5.8");
    lstHeightInFeet.add("5.9");
    lstHeightInFeet.add("5.10");
    lstHeightInFeet.add("5.11");
    lstHeightInFeet.add("6.0");
    lstHeightInFeet.add("6.1");
    lstHeightInFeet.add("6.2");
    lstHeightInFeet.add("6.3");
    lstHeightInFeet.add("6.4");
    lstHeightInFeet.add("6.5");
    lstHeightInFeet.add("6.6");
    lstHeightInFeet.add("6.7");
    lstHeightInFeet.add("6.8");
    lstHeightInFeet.add("6.9");
    lstHeightInFeet.add("6.10");
    lstHeightInFeet.add("6.11");
    lstHeightInFeet.add("7.0");
    lstHeightInFeet.add("7.1");
    lstHeightInFeet.add("7.2");
    lstHeightInFeet.add("7.3");
    lstHeightInFeet.add("7.4");
    lstHeightInFeet.add("7.5");
    lstHeightInFeet.add("7.6");
    lstHeightInFeet.add("7.7");
    lstHeightInFeet.add("7.8");
    lstHeightInFeet.add("7.9");
    lstHeightInFeet.add("7.10");
    lstHeightInFeet.add("7.11");
    lstHeightInFeet.add("8.0");

    lstHeightInCm.clear();
    for (int k = 60; k < 241; k++) {
      lstHeightInCm.add("" + k.toString());
    }
  }
}