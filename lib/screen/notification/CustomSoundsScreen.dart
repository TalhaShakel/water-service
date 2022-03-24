import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/SoundModel.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/CustomSoundTile.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class CustomSoundsScreen extends StatefulWidget {
  final Function callback;
  int sound;

  CustomSoundsScreen({Key key, this.callback, this.sound}) : super(key: key);

  @override
  CustomSoundsScreenState createState() => CustomSoundsScreenState();
}

class CustomSoundsScreenState extends State<CustomSoundsScreen> {
  List<SoundModel> lstSounds = [];

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadSounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: InkWell(
          onTap: () {
            NavigatorHelper.remove();
          },
          child: Container(
            // color: Colors.black45,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                height: 490,
                // padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: lstSounds.length,
                          padding: EdgeInsets.all(20.0),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  widget.sound = lstSounds[index].id;
                                  for (int i = 0;i < lstSounds.length;i++) {
                                    lstSounds[i].isSelected = (i == index);
                                  }

                                });

                                if(lstSounds[index].soundPath.isNotEmpty) {
                                  player.stop();
                                  player.setAsset(lstSounds[index].soundPath).then((value) {
                                    print(value);
                                    player.play();
                                  }).catchError((onError){
                                    print("==========");
                                    print(onError.toString());
                                  });
                                }
                                else{
                                  player.stop();
                                  FlutterRingtonePlayer.playNotification(asAlarm: true);
                                }
                              },
                              child: CustomSoundTile(sound: lstSounds[index]),
                            );
                          }),
                    ),
                    ButtonView(
                      buttonTextName: buildTranslate(context, "save"),
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        SharedPref.savePreferenceValue(REMINDER_SOUND, widget.sound);
                        if (widget.callback != null) widget.callback(widget.sound);
                        NavigatorHelper.remove();
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigatorHelper.remove();
                      },
                      child: Container(
                        height: 60,
                        child: Text(
                          buildTranslate(context, "cancel"),
                          style: Fonts.dialogCancelTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loadSounds() {
    lstSounds.clear();

    lstSounds.add(getSoundModel(0, "Default", ""));
    lstSounds.add(getSoundModel(1, "Bell", "assets/audio/bell.mp3"));
    lstSounds.add(getSoundModel(2, "Blop", "assets/audio/blop.mp3"));
    lstSounds.add(getSoundModel(3, "Bong", "assets/audio/bong.mp3"));
    lstSounds.add(getSoundModel(4, "Click", "assets/audio/click.mp3"));
    lstSounds.add(getSoundModel(5, "Echo droplet", "assets/audio/echo_droplet.mp3"));
    lstSounds.add(getSoundModel(6, "Mario droplet", "assets/audio/mario_droplet.mp3"));
    lstSounds.add(getSoundModel(7, "Ship bell", "assets/audio/ship_bell.mp3"));
    lstSounds.add(getSoundModel(8, "Simple droplet", "assets/audio/simple_droplet.mp3"));
    lstSounds.add(getSoundModel(9, "Tiny droplet", "assets/audio/tiny_droplet.mp3"));

    if(lstSounds[widget.sound].soundPath.isNotEmpty)
      player.setAsset(lstSounds[widget.sound].soundPath);
  }

  SoundModel getSoundModel(int index, String name, String path) {
    return SoundModel(
      id: index,
      soundName: name,
      soundPath: path,
      isSelected: index == widget.sound,
    );

  }
}
