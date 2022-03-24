import 'package:flutter/cupertino.dart';

class AssetsHelper{

  static getAssetIcon(String icon) {

    String assetIcon = "";

    if(icon.isNotEmpty)
      {
        assetIcon = "assets/icons/" + icon;
      }

    return AssetImage(assetIcon);

  }

 static getAssetLogo(String logo){

    String assetLogo = "";

    if(logo.isNotEmpty)
    {
      assetLogo = "assets/logo/" + logo;
    }

    return AssetImage(assetLogo);

  }

  static getAssetImage(String image){

    String assetImage = "";

    if(image.isNotEmpty)
    {
      assetImage = "assets/images/" + image;
    }

    return AssetImage(assetImage);

  }

}