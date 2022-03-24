import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();

  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(color: Colors.black),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.file(File(widget.imagePath)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
                  InkWell(
                    onTap: () {
                      // apiCallPunchImage(context);
                      Navigator.pop(context, widget.imagePath);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}