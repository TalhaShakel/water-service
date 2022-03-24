import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/model/ContainerModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

class ContainerTile extends StatelessWidget {
  final ContainerModel container;
  final int index;

  ContainerTile({Key key, this.container, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
              image: getImage(double.parse(container.containerValue)),
              height: 60,
              width: 60),
          SizedBox(
            height: 3,
          ),
          Text(container.containerValue + " ml",
              style: Fonts.containerTextStyle),
          SizedBox(
            height: container.isSelected ? 3 : 0,
          ),
          Visibility(
            visible: container.isSelected,
            child: Image(
              color: AppColor.appOrange,
              image: AssetsHelper.getAssetIcon("checkmark_icon.png"),
              height: 15,
              width: 15,
            ),
          ),
        ],
      ),
    );
  }

  getImage(containerValue) {
    switch (containerValue) {
      case 50:
        return AssetsHelper.getAssetIcon("ic_50_ml.png");

      case 100:
        return AssetsHelper.getAssetIcon("ic_100_ml.png");

      case 150:
        return AssetsHelper.getAssetIcon("ic_150_ml.png");

      case 200:
        return AssetsHelper.getAssetIcon("ic_200_ml.png");

      case 250:
        return AssetsHelper.getAssetIcon("ic_250_ml.png");

      case 300:
        return AssetsHelper.getAssetIcon("ic_300_ml.png");

      case 500:
        return AssetsHelper.getAssetIcon("ic_500_ml.png");

      case 600:
        return AssetsHelper.getAssetIcon("ic_600_ml.png");

      case 700:
        return AssetsHelper.getAssetIcon("ic_700_ml.png");

      case 800:
        return AssetsHelper.getAssetIcon("ic_800_ml.png");

      case 900:
        return AssetsHelper.getAssetIcon("ic_900_ml.png");

      case 1000:
        return AssetsHelper.getAssetIcon("ic_1000_ml.png");

      default:
        return AssetsHelper.getAssetIcon("ic_custom_ml.png");
    }
  }

  getImageOz(containerValueOz) {
    switch (containerValueOz) {
      case 2:
        return AssetsHelper.getAssetIcon("ic_50_ml.png");

      case 3:
        return AssetsHelper.getAssetIcon("ic_100_ml.png");

      case 5:
        return AssetsHelper.getAssetIcon("ic_150_ml.png");

      case 7:
        return AssetsHelper.getAssetIcon("ic_200_ml.png");

      case 8:
        return AssetsHelper.getAssetIcon("ic_250_ml.png");

      case 10:
        return AssetsHelper.getAssetIcon("ic_300_ml.png");

      case 17:
        return AssetsHelper.getAssetIcon("ic_500_ml.png");

      case 20:
        return AssetsHelper.getAssetIcon("ic_600_ml.png");

      case 24:
        return AssetsHelper.getAssetIcon("ic_700_ml.png");

      case 27:
        return AssetsHelper.getAssetIcon("ic_800_ml.png");

      case 30:
        return AssetsHelper.getAssetIcon("ic_900_ml.png");

      case 34:
        return AssetsHelper.getAssetIcon("ic_1000_ml.png");

      default:
        return AssetsHelper.getAssetIcon("ic_custom_ml.png");
    }
  }
}
