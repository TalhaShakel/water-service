import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/model/FAQModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';

class FAQTile extends StatelessWidget {
  final FAQModel faq;

  FAQTile({Key key, this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(faq.title, style: new TextStyle(
                        fontSize: 16,
                        color: AppColor.appColor,
                        fontFamily: "CalibriBold",
                      )
                    )
                ),
                SizedBox(width: 10,),
                Icon(
                  faq.isExpanded?Icons.remove:Icons.add,
                  color: AppColor.appColor,
                )
              ],
            ),
          ),
          Visibility(
            visible: faq.isExpanded,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8,0,8,8),
                child: Text(faq.desc, style: new TextStyle(
                    fontSize: 12,
                    color: AppColor.appColor,
                    fontFamily: "CalibriRegular",
                  )
                ),
              )
          ),
          Container(
            color: Colors.grey,
            height: 0.3,
          ),
        ],
      ),
    );
  }
}