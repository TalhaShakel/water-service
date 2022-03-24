import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/FAQModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/FAQTile.dart';

class FAQScreen extends StatefulWidget {
  @override
  FAQScreenState createState() => FAQScreenState();
}

class FAQScreenState extends State<FAQScreen> {
  bool showLoader = false;

  List<FAQModel> lstFAQ = [];

  int perPage=20;
  int page=0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, (){
      loadFAQData();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        leading: IconButton(
          color: AppColor.appDarkSkyBlue,
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            NavigatorHelper.remove();
          },
        ),
        title: Text(
          buildTranslate(context, "faqs"),
          style: Fonts.headerLightTextStyle,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColor.appBgColor, AppColor.appBgColor]
            ),
          ),
        ),
      ),
      body: new Builder(builder: (BuildContext context) {
        return LoaderView(
          showLoader: showLoader,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: lstFAQ.length,
                        padding: EdgeInsets.all(20),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {

                                if(lstFAQ[index].isExpanded) {
                                  for (int k = 0; k < lstFAQ.length; k++) {
                                    lstFAQ[k].isExpanded = false;
                                  }
                                }
                                else {
                                  for (int k = 0; k < lstFAQ.length; k++) {
                                    lstFAQ[k].isExpanded = index==k;
                                  }
                                }
                              });
                            },
                            child: FAQTile(
                              faq: lstFAQ[index],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  loadFAQData(){
    setState(() {
      lstFAQ.clear();
      for(int k=1;k<13;k++){

        if(k==8 || k==9)
          continue;

        lstFAQ.add(new FAQModel(
          title: buildTranslate(context, "faq_question_"+k.toString()),
          desc: buildTranslate(context, "faq_answer_"+k.toString()),
          isExpanded: false,
        ));
      }
    });
  }
}