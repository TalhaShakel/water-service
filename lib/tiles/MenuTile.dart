import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/model/Menu.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

class MenuTile extends StatelessWidget {
  final Menu menu;

  MenuTile({Key key, this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: getImage(menu.index),
              height: 25,
              width: 25,
              color: AppColor.appDarkSkyBlue,
            ),
            SizedBox(
              width: 20,
            ),
            Text(menu.menuName, style: Fonts.languageTextStyle),
          ],
        ),
      ),
    );
  }

  getImage(index) {
    switch (index) {
      case 0:
        return AssetsHelper.getAssetIcon("ic_menu_drink_water.png");

      case 1:
        return AssetsHelper.getAssetIcon("ic_menu_history.png");

      case 2:
        return AssetsHelper.getAssetIcon("ic_menu_report.png");

      case 4:
        return AssetsHelper.getAssetIcon("ic_menu_settings.png");

      case 5:
        return AssetsHelper.getAssetIcon("ic_menu_faq.png");

      case 6:
        return AssetsHelper.getAssetIcon("ic_privacypolicy.png");

      case 7:
        return AssetsHelper.getAssetIcon("ic_menu_share.png");

      case 8:
        return AssetsHelper.getAssetIcon("ic_menu_go_premium.png");

      default:
        return AssetsHelper.getAssetIcon("ic_menu_drink_water.png");
    }
  }
}
