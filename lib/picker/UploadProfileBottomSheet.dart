import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

import 'TakePictureScreen.dart';

class UploadProfileBottomSheet extends StatefulWidget {
  const UploadProfileBottomSheet({Key key, this.callBack, this.name})
      : super(key: key);

  @override
  _UploadProfileBottomSheetState createState() => _UploadProfileBottomSheetState();
  final Function callBack;
  final String name;
}

class _UploadProfileBottomSheetState extends State<UploadProfileBottomSheet> {
  TextStyle titleStyle = TextStyle( fontFamily: 'AppBold', fontSize: 16.0, color: Colors.black);

  List<Asset> images = [];

  @override
  void initState() {
    super.initState();
  }

  cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColor.appColor,
            toolbarWidgetColor: Colors.white,
            statusBarColor: AppColor.appColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      Navigator.pop(context);
      widget.callBack(croppedFile);
    }
  }

  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: new Container(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0))),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          buildTranslate(context, "uploadImage"),
                          style: titleStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          elevation: 0,
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          splashColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10),
                            side: BorderSide(color: AppColor.appColor),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColor.appColor,
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      buildTranslate(context, "takeAPhoto"),
                                      style: TextStyle(
                                        fontFamily: "AppRegular",
                                        fontSize: 16,
                                        color: AppColor.appColor,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            // pickImage(1);
                            _showCamera();
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          elevation: 0,
                          color: AppColor.appWhite,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          splashColor: AppColor.appWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10),
                            side: BorderSide(color: AppColor.appColor),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.image,
                                  color: AppColor.appColor,
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      buildTranslate(context, "selectAnImage"),
                                      style: TextStyle(
                                        fontFamily: "AppRegular",
                                        fontSize: 16,
                                        color: AppColor.appColor,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            loadAssets();
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          elevation: 0,
                          color: AppColor.appColor,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          splashColor: AppColor.appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30),
                            side: BorderSide(color: AppColor.appColor),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.cancel,
                                  color: AppColor.appColor,
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(buildTranslate(context, "cancel"),
                                      style: Fonts.buttonStyle),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            //widget.callback(widget.indexMy,tmp.length>0?true:false);
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));

    if (result != null) {
      cropImage(File(result));
    }
  }

  Future<void> loadAssets() async {

    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print("ERROR : "+e.toString());
    }

    if (!mounted) return;

    print ("File size "  + images.length.toString());

    print(images);

    if(images.length==0) return;

    var path = await FlutterAbsolutePath.getAbsolutePath(images[0].identifier);
    var file = await getImageFileFromAsset(path);

    print ("File "  + path);
    print ("File "  + file.path);

    if (file != null) {
      cropImage(file);
    }
  }

  Future<File> getImageFileFromAsset(path) async {
    final file = File(path);
    return file;
  }

}
