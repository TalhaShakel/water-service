import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/model/SoundModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

class CustomSoundTile extends StatelessWidget {
  final SoundModel sound;

  CustomSoundTile({Key key, this.sound}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: sound.isSelected ? AppColor.appBgColor : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: sound.isSelected,
              child: Image(
                color: AppColor.appDarkSkyBlue,
                image: AssetsHelper.getAssetIcon("checkmark_icon.png"),
                height: 25,
                width: 25,
              ),
            ),
            SizedBox(
              width: sound.isSelected ? 10 : 35,
            ),
            Text(sound.soundName, style: Fonts.languageTextStyle),
          ],
        ),
      ),
    );
  }
}
