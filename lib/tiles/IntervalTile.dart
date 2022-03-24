import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/model/IntervalModel.dart';
import 'package:water_drinking_reminder/model/SoundModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

class IntervalTile extends StatelessWidget {
  final IntervalModel interval;

  IntervalTile({Key key, this.interval}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: interval.isSelected ? AppColor.appBgColor : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: interval.isSelected,
              child: Image(
                color: AppColor.appDarkSkyBlue,
                image: AssetsHelper.getAssetIcon("checkmark_icon.png"),
                height: 25,
                width: 25,
              ),
            ),
            SizedBox(
              width: interval.isSelected ? 10 : 35,
            ),
            Text(interval.name, style: Fonts.languageTextStyle),
          ],
        ),
      ),
    );
  }
}
