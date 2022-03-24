import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/events/events.dart';
import 'package:water_drinking_reminder/helper/AlertHelper.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/HeightWeightHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/Regex.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/AppTheme.dart';
import 'package:water_drinking_reminder/style/CustomInputDecoration.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class AddContainerScreen extends StatefulWidget {
  final Function callback;

  const AddContainerScreen({Key key, this.callback}) : super(key: key);

  @override
  AddContainerScreenState createState() => AddContainerScreenState();
}

class AddContainerScreenState extends State<AddContainerScreen> {
  TextEditingController addContainerInputController = new TextEditingController();
  final FocusNode _addContainerFocus = FocusNode();
  String unit="ml";

  @override
  void initState() {
    super.initState();
    _addContainerFocus.requestFocus();

    //loadData();
  }

  loadData() async{
    unit = await SharedPref.readPreferenceValue(WATER_UNIT, PrefEnum.STRING);
    setState(() { });
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
                      buildTranslate(context,"customize_your_drink"),
                      style: Fonts.addContainerTextStyle,
                    ),
                    Image(
                      image: AssetsHelper.getAssetIcon("ic_custom_ml.png"),
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      buildTranslate(context,"capacity").replaceAll("\$1", AppGlobal.WATER_UNIT_VALUE),
                      style: Fonts.notiPopTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                        WhitelistingTextInputFormatter(Regex.onlyDigits)
                      ],
                      textAlign: TextAlign.center,
                      controller: addContainerInputController,
                      style: Fonts.addContainerTextStyle,
                      keyboardType: TextInputType.number,
                      autocorrect: true,
                      cursorColor: AppTheme.lightTheme.cursorColor,
                      enableSuggestions: true,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: CustomInputDecoration.getInputDecorationBlue(
                        text: buildTranslate(context,""),
                      ),
                      focusNode: _addContainerFocus,
                      onFieldSubmitted: (term) {
                        _addContainerFocus.unfocus();
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ButtonView(
                      buttonTextName: buildTranslate(context,"save"),
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        //NavigatorHelper.remove();
                        //if (widget.callback != null) widget.callback(false);

                        addCustom();
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

  addCustom() async {

    if(addContainerInputController.text.toString().trim().isEmpty){
      AlertHelper.showToast(buildTranslate(context, "enter_value_validation"));
    }
    else if(int.parse(addContainerInputController.text.toString().trim())==0){
      AlertHelper.showToast(buildTranslate(context, "enter_value_validation"));
    }
    else{
      double tml=0,tfloz=0;

      if(AppGlobal.WATER_UNIT_VALUE=="ml")
      {
        tml=double.parse(addContainerInputController.text.toString().trim());
        tfloz=HeightWeightHelper.mlToOzConverter(tml);
        //where_check_val=txt_value.getText().toString().trim();
      }
      else
      {
        tfloz=double.parse(addContainerInputController.text.toString().trim());
        tml=HeightWeightHelper.ozToMlConverter(tfloz);
      }

      int nextContainerID=0;

      try {
        nextContainerID = await AppGlobal.dbHelper.getLastContainerId();
      }
      catch (e){}

      Map<String, dynamic> params =
      {
        'ContainerID': nextContainerID,
        'ContainerValue': tml.round(),
        'ContainerValueOZ': tfloz.round(),
        'IsOpen': 1,
        'IsCustom': 1,
      };

      print(params);

      await AppGlobal.dbHelper.insert(DatabaseHelper.tableContainer, params);

      //if (widget.callback != null) widget.callback(false);

      SharedPref.savePreferenceValue(SELECTED_CONTAINER, nextContainerID);

      AppGlobal.eventBus.fire(RefreshContainerList());

      NavigatorHelper.remove();
      NavigatorHelper.remove();
    }

  }
}