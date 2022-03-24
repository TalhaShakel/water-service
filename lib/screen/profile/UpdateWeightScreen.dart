import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/helper/AlertHelper.dart';
import 'package:water_drinking_reminder/helper/HeightWeightHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/Regex.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/helper/StringHelper.dart';
import 'package:water_drinking_reminder/inputfilter/WeightKGRangeTextInputFormatter.dart';
import 'package:water_drinking_reminder/inputfilter/WeightLBRangeTextInputFormatter.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/AppTheme.dart';
import 'package:water_drinking_reminder/style/CustomInputDecoration.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class UpdateWeightScreen extends StatefulWidget {
  final Function callback;

  const UpdateWeightScreen({Key key, this.callback}) : super(key: key);

  @override
  UpdateWeightScreenState createState() => UpdateWeightScreenState();
}

class UpdateWeightScreenState extends State<UpdateWeightScreen> {
  TextEditingController weightInputController = new TextEditingController();
  final FocusNode _weightFocus = FocusNode();

  bool isLB=false;
  String weight="";

  List<String> lstWeightInKg = [];
  List<String> lstWeightInLb = [];

  @override
  void initState() {
    super.initState();
    //_weightFocus.requestFocus();

    getWeightList();

    loadData();
  }

  loadData() async{
    weight = (await SharedPref.readPreferenceValue(PERSON_WEIGHT, PrefEnum.STRING)??"80.0");
    isLB = await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL);

    weightInputController.text = weight;

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
                        LengthLimitingTextInputFormatter(isLB?3:5),
                        FilteringTextInputFormatter.allow(isLB?Regex.onlyDigits:Regex.onlyDigitsWithDecimal),
                        isLB?WeightLBRangeTextInputFormatter(min: 66, max: 287):WeightKGRangeTextInputFormatter(min: 30, max: 130),
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return buildTranslate(context,"weight_validation");
                        } else {
                          return null;
                        }
                      },
                      controller: weightInputController,
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
                      decoration: CustomInputDecoration.getInputDecorationBlue(text: buildTranslate(context,"")),
                      focusNode: _weightFocus,
                      onFieldSubmitted: (term) {
                        _weightFocus.unfocus();
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

                            if(isLB)
                              return;

                            setState(() {
                              isLB = true;
                            });

                            Future.delayed(Duration.zero, (){
                              try{
                                if(weightInputController.text.toString().toString().isNotEmpty){

                                  double weightInKG = double.parse(weightInputController.text.toString().toString());

                                  double weightInLB = 0;

                                  if(weightInKG>0)
                                    weightInLB = HeightWeightHelper.kgToLbConverter(weightInKG);

                                  int tmp = weightInLB.round();

                                  for(int k=0;k<lstWeightInLb.length;k++){
                                    if(double.parse(lstWeightInLb[k])==double.parse(tmp.toString())){
                                      weightInputController.text = StringHelper.getData(lstWeightInLb[k]);
                                      weightInputController.selection = TextSelection.fromPosition(TextPosition(offset: weightInputController.text.length));

                                      print("PAGE : "+k.toString());

                                    }
                                  }
                                }
                              }catch(e){
                                print(e);
                              }
                            });


                          },
                          child: Container(
                            width: 50.0,
                            height: 30.0,
                            padding: EdgeInsets.all(2.0),
                            decoration: new BoxDecoration(
                              color: isLB
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
                                buildTranslate(context,"lb"),
                                style: Fonts.metreLabelTextStyle,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {

                            if(!isLB)
                              return;

                            setState(() {
                              isLB = false;
                            });

                            Future.delayed(Duration.zero, (){
                              try{
                                if(weightInputController.text.toString().toString().isNotEmpty){

                                  double weightInLB = double.parse(weightInputController.text.toString().toString());

                                  double weightInKG = 0;

                                  if(weightInLB>0)
                                    weightInKG = HeightWeightHelper.lbToKgConverter(weightInLB);

                                  int tmp = weightInKG.round();

                                  for(int k=0;k<lstWeightInKg.length;k++){
                                    if(double.parse(lstWeightInKg[k])==double.parse(tmp.toString())){
                                      weightInputController.text = StringHelper.getData(lstWeightInKg[k]);
                                      weightInputController.selection = TextSelection.fromPosition(TextPosition(offset: weightInputController.text.length));
                                    }
                                  }
                                }
                              }catch(e){}
                            });





                          },
                          child: Container(
                            width: 50.0,
                            height: 30.0,
                            padding: EdgeInsets.all(5.0),
                            decoration: new BoxDecoration(
                              color: !isLB
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
                                buildTranslate(context,"kg"),
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

                        if(weightInputController.text.toString().trim().isEmpty){
                          AlertHelper.showToast(buildTranslate(context, "weight_validation"));
                        }
                        else {
                          saveWeightData();
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

  saveWeightData(){
    SharedPref.savePreferenceValue(PERSON_WEIGHT, weightInputController.text.toString().trim());
    SharedPref.savePreferenceValue(PERSON_WEIGHT_UNIT, isLB);
    SharedPref.savePreferenceValue(WATER_UNIT, isLB?"fl oz":"ml");

    print("SAVE WEIGHT DATA");

    if(widget.callback!=null){
      widget.callback(isLB, weightInputController.text.toString().trim());
    }

    NavigatorHelper.remove(value: true);
  }

  void getWeightList() {
    lstWeightInKg.clear();
    double f = 30.0;
    lstWeightInKg.add(f.toString());
    for (int k = 0; k < 200; k++) {
      f += 0.5;
      lstWeightInKg.add(f.toString());
    }

    lstWeightInLb.clear();
    for (int k = 66; k < 288; k++) {
      lstWeightInLb.add(k.toString());
    }
  }
}