import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drinking_reminder/inputfilter/HeightFeetRangeTextInputFormatter.dart';
import 'package:water_drinking_reminder/inputfilter/WeightKGRangeTextInputFormatter.dart';
import 'package:water_drinking_reminder/inputfilter/WeightLBRangeTextInputFormatter.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/HeightWeightHelper.dart';
import 'package:water_drinking_reminder/helper/Regex.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/helper/StringHelper.dart';
import 'package:water_drinking_reminder/model/OnBoardingModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/AppTheme.dart';
import 'package:water_drinking_reminder/style/CustomInputDecoration.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

import 'OnBoardingStep2Screen.dart';


class OnBoardingStep3Screen extends StatefulWidget {
  @override
  OnBoardingStep3ScreenState createState() => OnBoardingStep3ScreenState();
}

class OnBoardingStep3ScreenState extends State<OnBoardingStep3Screen> {

  bool showLoader = false;

  bool isCM = true;
  bool isLB = true;

  OnBoardingStep2Screen onBoardingStep2Screen = new OnBoardingStep2Screen();
  OnBoardingModel onBoardingModel;

  TextEditingController heightInputController = new TextEditingController(text: "5.0");
  TextEditingController weightInputController = new TextEditingController(text: "80.0");

  final FocusNode _heightFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  List<String> lstHeightInFeet = [];
  List<String> lstHeightInCm = [];
  List<String> lstWeightInKg = [];
  List<String> lstWeightInLb = [];

  PageController _heightFeetController;
  PageController _heightCmController;
  PageController _weightKgController;
  PageController _weightLbController;

  int _focusedHeightFeet = 36;
  int _focusedHeightCm = 1;
  int _focusedWeightKg = 100;
  int _focusedWeightLb = 1;

  @override
  void initState() {
    super.initState();

    onBoardingModel = onBoardingStep2Screen.getDetails();

    heightInputController.text = StringHelper.getData(onBoardingModel.height);
    weightInputController.text = StringHelper.getData(onBoardingModel.weight);


    print(onBoardingModel.height);

    isCM = onBoardingModel.heightUnit;
    isLB = onBoardingModel.weightUnit;

    getHeightList();
    getWeightList();

    for(int k=0;k<(isCM?lstHeightInCm.length:lstHeightInFeet.length);k++){
      if(isCM){
        if(double.parse(lstHeightInCm[k])==double.parse(heightInputController.text)){
          _focusedHeightCm=k;
          break;
        }
      }
      else{
        if(double.parse(lstHeightInFeet[k])==double.parse(heightInputController.text)){
          _focusedHeightFeet=k;
          break;
        }
      }
    }

    for(int k=0;k<(isLB?lstWeightInLb.length:lstWeightInKg.length);k++){
      if(isLB){
        if(double.parse(lstWeightInLb[k])==double.parse(weightInputController.text)){
          _focusedWeightLb=k;
          break;
        }
      }
      else{
        if(double.parse(lstWeightInKg[k])==double.parse(weightInputController.text)){
          _focusedWeightKg=k;
          break;
        }
      }
    }


    _heightFeetController = new PageController(
      initialPage: _focusedHeightFeet,
      viewportFraction: 0.3,
    );

    _heightCmController = new PageController(
      initialPage: _focusedHeightCm,
      viewportFraction: 0.3,
    );

    _weightKgController = new PageController(
      initialPage: _focusedWeightKg,
      viewportFraction: 0.3,
    );

    _weightLbController = new PageController(
      initialPage: _focusedWeightLb,
      viewportFraction: 0.3,
    );


    saveHeightData();
    saveWeightData();

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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [


                              Text(
                                buildTranslate(context,"height"),
                                style: Fonts.headerTitleStyle,
                              ),
                              SizedBox(height: 15),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 70,
                                      //color: Colors.black12,
                                      child: TextFormField(
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
                                        decoration: CustomInputDecoration.getInputDecorationBox(text: buildTranslate(context,""),
                                        ),
                                        focusNode: _heightFocus,
                                        onFieldSubmitted: (term) {
                                          AppGlobal.fieldFocusChange(context,_heightFocus, _weightFocus);
                                        },
                                        onChanged: (value) {

                                          if(value.isEmpty) {
                                            if(isCM)
                                              _heightCmController.jumpToPage(0);
                                            else
                                              _heightFeetController.jumpToPage(0);
                                            return;
                                          }

                                          if(double.parse(value)>8 && !isCM){
                                            _heightFeetController.jumpToPage(lstHeightInFeet.length-1);
                                            return;
                                          }

                                          if(double.parse(value)>240 && isCM){
                                            _heightCmController.jumpToPage(lstHeightInCm.length-1);
                                            return;
                                          }

                                          for(int k=0;k<(isCM?lstHeightInCm.length:lstHeightInFeet.length);k++){
                                            if(isCM){
                                              if(double.parse(lstHeightInCm[k])==double.parse(value)){
                                                _heightCmController.jumpToPage(k);
                                                onBoardingModel.height = value;
                                              }
                                            }
                                            else{
                                              if(double.parse(lstHeightInFeet[k])==double.parse(value)){
                                                _heightFeetController.jumpToPage(k);
                                                onBoardingModel.height = value;
                                              }
                                            }
                                          }

                                          saveHeightData();
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
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

                                                    setState(() {
                                                      _focusedHeightCm = k;
                                                      if(_heightCmController.hasClients) {
                                                        _heightCmController.jumpToPage(k);
                                                      }
                                                      else{
                                                        Future.delayed(const Duration(milliseconds: 500), () {
                                                          setState(() {
                                                            _heightCmController.jumpToPage(k);
                                                          });
                                                        });
                                                      }
                                                    });

                                                    break;
                                                  }
                                                }

                                                saveHeightData();
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

                                                    setState(() {
                                                      _focusedHeightFeet = k;
                                                      //_heightFeetController.jumpToPage(k);

                                                      if(_heightFeetController.hasClients) {
                                                        _heightFeetController.jumpToPage(k);
                                                      }
                                                      else{
                                                        Future.delayed(const Duration(milliseconds: 500), () {
                                                          setState(() {
                                                            _heightFeetController.jumpToPage(k);
                                                          });
                                                        });
                                                      }
                                                    });

                                                    break;
                                                  }
                                                }

                                                saveHeightData();
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
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: !isCM,
                                child: Container(
                                  height: 100,
                                  child: PageView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: lstHeightInFeet.length,
                                    pageSnapping: true,
                                    controller: _heightFeetController,
                                    onPageChanged: (int page) {
                                      //getChangedPageAndMoveBarHeight(page);

                                      setState(() {
                                        _focusedHeightFeet=page;
                                      });

                                      if(!isCM) {
                                        heightInputController.text = lstHeightInFeet[page];
                                        heightInputController.selection = TextSelection.fromPosition(TextPosition(offset: heightInputController.text.length));
                                      }

                                      saveHeightData();
                                    },
                                    itemBuilder: (_, i) {
                                      return Center(
                                        child: i == _focusedHeightFeet
                                            ? Text(
                                          lstHeightInFeet[i],
                                          style:
                                          Fonts.scrollTextStyle,
                                        )
                                            : Opacity(
                                          opacity: 0.3,
                                          child: Text(
                                            lstHeightInFeet[i],
                                            style:
                                            Fonts.scrollTextStyle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isCM,
                                child: Container(
                                  height: 100,
                                  child: PageView.builder(
                                    itemCount: lstHeightInCm.length,
                                    pageSnapping: true,
                                    controller: _heightCmController,
                                    onPageChanged: (int page) {
                                      //getChangedPageAndMoveBarHeight(page);

                                      setState(() {
                                        _focusedHeightCm=page;
                                      });

                                      if(isCM) {
                                        heightInputController.text = lstHeightInCm[page];
                                        heightInputController.selection = TextSelection.fromPosition(TextPosition(offset: heightInputController.text.length));
                                      }

                                      saveHeightData();
                                    },
                                    itemBuilder: (_, i) {
                                      return Center(
                                        child: i == _focusedHeightCm
                                            ? Text(
                                          lstHeightInCm[i],
                                          style:
                                          Fonts.scrollTextStyle,
                                        )
                                            : Opacity(
                                          opacity: 0.3,
                                          child: Text(
                                            lstHeightInCm[i],
                                            style:
                                            Fonts.scrollTextStyle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),


                              Text(
                                buildTranslate(context,"weight"),
                                style: Fonts.headerTitleStyle,
                              ),
                              SizedBox(height: 15),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 80,
                                      //color: Colors.black12,
                                      child: TextFormField(
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(isLB?3:5),
                                          //WhitelistingTextInputFormatter(Regex.onlyDigitsWithDecimal),
                                          FilteringTextInputFormatter.allow(isLB?Regex.onlyDigits:Regex.onlyDigitsWithDecimal),
                                          //MaskTextInputFormatter(mask: isKg?'###.#':'###', filter: { "#": Regex.onlyDigits}),
                                          isLB?WeightLBRangeTextInputFormatter(min: 66, max: 287):WeightKGRangeTextInputFormatter(min: 30, max: 130),
                                        ],
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return buildTranslate(context, "weight_validation");
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
                                        decoration: CustomInputDecoration.getInputDecorationBox(text: buildTranslate(context,""),
                                        ),
                                        focusNode: _weightFocus,
                                        onFieldSubmitted: (term) {
                                          _weightFocus.unfocus();
                                        },
                                        onChanged: (value) {

                                          if(value.isEmpty) {
                                            if(isLB)
                                              _weightLbController.jumpToPage(0);
                                            else
                                              _weightKgController.jumpToPage(0);
                                            return;
                                          }

                                          if(isLB){
                                            for(int k=0;k<lstWeightInLb.length;k++){
                                              if(double.parse(lstWeightInLb[k])==double.parse(value)){
                                                _weightLbController.jumpToPage(k);
                                                onBoardingModel.weight = value;
                                              }
                                            }
                                          }
                                          else{
                                            for(int k=0;k<lstWeightInKg.length;k++){
                                              if(double.parse(lstWeightInKg[k])==double.parse(value)){
                                                _weightKgController.jumpToPage(k);
                                                onBoardingModel.weight = value;
                                              }
                                            }
                                          }

                                          saveWeightData();
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
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

                                                      setState(() {
                                                        _focusedWeightLb = k;
                                                        //_weightLbController.jumpToPage(k);

                                                        if(_weightLbController.hasClients) {
                                                          _weightLbController.jumpToPage(k);
                                                        }
                                                        else{
                                                          Future.delayed(const Duration(milliseconds: 500), () {
                                                            setState(() {
                                                              _weightLbController.jumpToPage(k);
                                                            });
                                                          });
                                                        }
                                                      });

                                                    }
                                                  }

                                                  saveWeightData();
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

                                                      setState(() {
                                                        _focusedWeightKg = k;
                                                        //_weightKgController.jumpToPage(k);

                                                        if(_weightKgController.hasClients) {
                                                          _weightKgController.jumpToPage(k);
                                                        }
                                                        else{
                                                          Future.delayed(const Duration(milliseconds: 500), () {
                                                            setState(() {
                                                              _weightKgController.jumpToPage(k);
                                                            });
                                                          });
                                                        }
                                                      });

                                                    }
                                                  }

                                                  saveWeightData();

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
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Visibility(
                                visible: !isLB,
                                child: Container(
                                  height: 100,
                                  child: PageView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: lstWeightInKg.length,
                                    pageSnapping: true,
                                    controller: _weightKgController,
                                    onPageChanged: (int page) {
                                      //getChangedPageAndMoveBarWeight(page);
                                      setState(() {
                                        _focusedWeightKg=page;
                                      });

                                      if(!isLB) {
                                        weightInputController.text = lstWeightInKg[page];
                                        weightInputController.selection = TextSelection.fromPosition(TextPosition(offset: weightInputController.text.length));
                                      }

                                      saveWeightData();
                                    },
                                    itemBuilder: (_, i) {

                                      //print(i.toString()+" @@@ "+_focusedWeightKg.toString()+" @@@ "+(i == _focusedWeightKg).toString());

                                      return Center(
                                        child: i == _focusedWeightKg ?
                                        Text(
                                          lstWeightInKg[i],
                                          style:
                                          Fonts.scrollTextStyle,
                                        ) :
                                        Opacity(
                                          opacity: 0.3,
                                          child: Text(
                                            lstWeightInKg[i],
                                            style: Fonts.scrollTextStyle.copyWith(fontSize: 35),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isLB,
                                child: Container(
                                  height: 100,
                                  child: PageView.builder(
                                    itemCount: lstWeightInLb.length,
                                    pageSnapping: true,
                                    controller: _weightLbController,
                                    onPageChanged: (int page) {
                                      //getChangedPageAndMoveBarWeight(page);
                                      setState(() {
                                        _focusedWeightLb=page;
                                      });

                                      if(isLB) {
                                        weightInputController.text = lstWeightInLb[page];
                                        weightInputController.selection = TextSelection.fromPosition(TextPosition(offset: weightInputController.text.length));
                                      }

                                      saveWeightData();
                                    },
                                    itemBuilder: (_, i) {

                                      //print(i.toString()+" @@@ "+_focusedWeightLb.toString()+" @@@ "+(i == _focusedWeightLb).toString());

                                      return Center(
                                        child: i == _focusedWeightLb
                                            ? Text(
                                          lstWeightInLb[i],
                                          style:
                                          Fonts.scrollTextStyle,
                                        )
                                            : Opacity(
                                          opacity: 0.3,
                                          child: Text(
                                            lstWeightInLb[i],
                                            style:
                                            Fonts.scrollTextStyle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),


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

  saveHeightData(){
    setState(() {
      onBoardingModel.heightUnit=isCM;
      onBoardingModel.height=heightInputController.text.toString().trim();

      SharedPref.savePreferenceValue(PERSON_HEIGHT, heightInputController.text.toString().trim());
      SharedPref.savePreferenceValue(PERSON_HEIGHT_UNIT, isCM);
    });

    print("SAVE HEIGHT DATA");
  }

  saveWeightData(){
    setState(() {
      onBoardingModel.weightUnit=isLB;
      onBoardingModel.height=weightInputController.text.toString().trim();
      onBoardingModel.waterUnit=isLB?"fl oz":"ml";

      SharedPref.savePreferenceValue(PERSON_WEIGHT, weightInputController.text.toString().trim());
      SharedPref.savePreferenceValue(PERSON_WEIGHT_UNIT, isLB);
      SharedPref.savePreferenceValue(WATER_UNIT, isLB?"fl oz":"ml");
    });

    print("SAVE WEIGHT DATA");
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

    setState(() {
      for (int i = 0; i < lstHeightInFeet.length; i++) {
        if (onBoardingModel.height == lstHeightInFeet[i]) {
          _focusedHeightFeet = i;
          break;
        }
      }

      print(_focusedHeightFeet);

      //_heightFeetController.jumpToPage(_focusedHeightFeet);
    });
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

    setState(() {
      for (int i = 0; i < lstWeightInKg.length; i++) {
        if (onBoardingModel.weight == lstWeightInKg[i]) {
          _focusedWeightKg = i;
          break;
        }
      }
      //_weightKgController.jumpToPage(_focusedWeightKg);
    });

    // setState(() {
    //   for(int i=0; i<lstWeightInLb.length; i++){
    //     if(onBoardingModel.weight == lstWeightInLb[i]){
    //       _focusedWeightLb = i;
    //       break;
    //     }
    //   }
    //   _weightLbController.jumpToPage(_focusedWeightLb);
    // });
  }
}
