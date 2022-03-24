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

class UserNameScreen extends StatefulWidget {
  final Function callback;
  final String name;

  const UserNameScreen({Key key, this.callback, this.name}) : super(key: key);

  @override
  UserNameScreenState createState() => UserNameScreenState();
}

class UserNameScreenState extends State<UserNameScreen> {
  TextEditingController nameInputController = new TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    nameInputController.text = widget.name;
    _nameFocus.requestFocus();
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
                      buildTranslate(context,"your_name"),
                      style: Fonts.addContainerTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                        WhitelistingTextInputFormatter(Regex.onlyCharacter)
                      ],
                      textAlign: TextAlign.center,
                      controller: nameInputController,
                      style: Fonts.addContainerTextStyle,
                      keyboardType: TextInputType.text,
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
                      focusNode: _nameFocus,
                      onFieldSubmitted: (term) {
                        _nameFocus.unfocus();
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

    if(nameInputController.text.toString().trim().isEmpty){
      AlertHelper.showToast(buildTranslate(context, "your_name_validation"));
    }
    else if(nameInputController.text.toString().trim().length<=2){
      AlertHelper.showToast(buildTranslate(context, "valid_name_validation"));
    }
    else{
      await SharedPref.savePreferenceValue(USER_NAME, nameInputController.text.toString().trim());
      NavigatorHelper.remove(value: true);
    }

  }
}