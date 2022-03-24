import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';

import 'KeyboardHideView.dart';

class LoaderView extends StatelessWidget {
  final Widget child;
  final bool showLoader;

  LoaderView({@required this.child, @required this.showLoader}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return KeyboardHideView(
      child: ModalProgressHUD(
        child:this.child,
        inAsyncCall: showLoader,
        progressIndicator: SpinKitDoubleBounce(
          color: AppColor.appOrange,
          size: 50.0,
        ),
      ),
    );
  }
}