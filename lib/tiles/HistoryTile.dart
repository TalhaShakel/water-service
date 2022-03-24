import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/DialogHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/History.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';

class HistoryTile extends StatelessWidget {
  final History history;
  final bool isHeaderShow;
  Function onRemoveClick;

  HistoryTile({Key key, this.history, this.isHeaderShow, this.onRemoveClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(
        child: Column(
          children: [
            Visibility(
              visible: isHeaderShow,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: new BoxDecoration(
                  color: AppColor.appNavigationColor,
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Text(history.drinkDate, style: Fonts.historyWhiteBoldTextStyle)
                    ),
                    Text(history.total_ml, style: Fonts.historyWhiteBoldTextStyle),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(5, 10, 15, 10),
              child: Row(
                children: [
                  Image(
                    image: getImage(double.parse(history.containerValue)),
                    height: 40,
                    width: 40,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text((AppGlobal.WATER_UNIT_VALUE=="ml"?history.containerValue:history.containerValueOZ)+" "+AppGlobal.WATER_UNIT_VALUE, style: Fonts.containerTextStyle),
                            ),
                            Text(history.drinkTime, style: Fonts.historyRobotoRegularTextStyle),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: (){
                                  DialogHelper.showConfirmDialog(context, "", buildTranslate(context,"history_remove_confirm_message"),
                                    (value){
                                        if(onRemoveClick!=null && value) {
                                          onRemoveClick();
                                        }
                                    },
                                  );
                                },
                                child: Image(
                                  image: AssetsHelper.getAssetIcon("trash.png"),
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 1,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
