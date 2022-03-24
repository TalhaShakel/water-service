import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;

  TakePicturePage({@required this.camera});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

  bool isCapture = false;

  @override
  void initState() {
    super.initState();

    _cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                isCapture = true;
              });
              _takePicture(context);
            },
            child: Icon(
              Icons.camera,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      )
    ]);
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;

      final path = join((await getTemporaryDirectory()).path,
          'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await _cameraController.takePicture(path);

      Navigator.pop(context, path);

    } catch (e) {
      print(e);
    }
  }
}
