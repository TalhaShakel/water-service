import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/Regex.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/OnBoardingModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/AppTheme.dart';
import 'package:water_drinking_reminder/style/CustomInputDecoration.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

OnBoardingModel onBoardingModel = new OnBoardingModel();

class OnBoardingStep2Screen extends StatefulWidget {
  @override
  OnBoardingStep2ScreenState createState() => OnBoardingStep2ScreenState();

  OnBoardingModel getDetails() {
    return onBoardingModel;
  }
}

class OnBoardingStep2ScreenState extends State<OnBoardingStep2Screen> {
  bool showLoader = false;
  bool isFemale = false;

  TextEditingController firstNameInputController = new TextEditingController();
  FocusNode _firstNameFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    readData();
  }

  readData() async {

    onBoardingModel.name = await SharedPref.readPreferenceValue(USER_NAME, PrefEnum.STRING);
    onBoardingModel.gender = await SharedPref.readPreferenceValue(USER_GENDER, PrefEnum.BOOL);

    isFemale = onBoardingModel.gender;
    firstNameInputController.text = onBoardingModel.name;

    onBoardingModel.height = await SharedPref.readPreferenceValue(PERSON_HEIGHT, PrefEnum.STRING)??"5.0";
    onBoardingModel.heightUnit = await SharedPref.readPreferenceValue(PERSON_HEIGHT_UNIT, PrefEnum.BOOL);
    onBoardingModel.weight = await SharedPref.readPreferenceValue(PERSON_WEIGHT, PrefEnum.STRING)??"80.0";
    onBoardingModel.weightUnit = await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL);

    onBoardingModel.breastfeeding = await SharedPref.readPreferenceValue(IS_BREATFEEDING, PrefEnum.BOOL);
    onBoardingModel.pregnant = await SharedPref.readPreferenceValue(IS_PREGNANT, PrefEnum.BOOL);
    onBoardingModel.active = await SharedPref.readPreferenceValue(IS_ACTIVE, PrefEnum.BOOL);

    onBoardingModel.weatherCondition = await SharedPref.readPreferenceValue(WEATHER_CONSITIONS, PrefEnum.INT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: new Builder(builder: (BuildContext context) {
        return LoaderView(
          showLoader: showLoader,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: AppColor.appBgColor,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      buildTranslate(context,"your_name"),
                      style: Fonts.headerTitleStyle,
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                height: 65,
                                padding: EdgeInsets.all(10.0),
                                decoration: new BoxDecoration(
                                  color: AppColor.appDeActiveDotColor,
                                  borderRadius: BorderRadius.all(new Radius.circular(5.0)),
                                ),
                                child: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(20),
                                    WhitelistingTextInputFormatter(Regex.onlyCharacter)
                                  ],
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return buildTranslate(context,"your_name_validation");
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: firstNameInputController,
                                  style: Fonts.authLabelStyle,
                                  keyboardType: TextInputType.text,
                                  autocorrect: true,
                                  textCapitalization: TextCapitalization.words,
                                  cursorColor: AppTheme.lightTheme.cursorColor,
                                  enableSuggestions: true,
                                  maxLines: 1,
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.done,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: CustomInputDecoration.getInputDecorationBox(text: buildTranslate(context,""),
                                  ),
                                  focusNode: _firstNameFocus,
                                  onFieldSubmitted: (term) {
                                    _firstNameFocus.unfocus();
                                  },
                                  onChanged: (value) {
                                    onBoardingModel.name = value.trim().toString();
                                    SharedPref.savePreferenceValue(USER_NAME, value.trim().toString());
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                buildTranslate(context,"gender"),
                                style: Fonts.headerTitleStyle,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isFemale = false;
                                    onBoardingModel.gender = isFemale;
                                    SharedPref.savePreferenceValue(USER_GENDER, isFemale);
                                  });
                                },
                                child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: new BoxDecoration(
                                    color: isFemale
                                        ? Colors.transparent
                                        : AppColor.appDarkSkyBlue,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(50.0)
                                    ),
                                    border: new Border.all(
                                      color: AppColor.appDarkSkyBlue,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Image(
                                    image: isFemale
                                        ? AssetsHelper.getAssetIcon("ic_male_normal.png")
                                        : AssetsHelper.getAssetIcon("ic_male_selected.png"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                buildTranslate(context,"male"),
                                style: Fonts.onBoardingTextStyle,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isFemale = true;
                                    onBoardingModel.gender = isFemale;
                                    SharedPref.savePreferenceValue(USER_GENDER, isFemale);
                                  });
                                },
                                child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: new BoxDecoration(
                                    color: isFemale
                                        ? AppColor.appDarkSkyBlue
                                        : Colors.transparent,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(50.0)),
                                    border: new Border.all(
                                      color: AppColor.appDarkSkyBlue,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Image(
                                    image: isFemale
                                        ? AssetsHelper.getAssetIcon("ic_female_selected.png")
                                        : AssetsHelper.getAssetIcon("ic_female_normal.png"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                buildTranslate(context,"female"),
                                style: Fonts.onBoardingTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      }),
    );
  }
}
