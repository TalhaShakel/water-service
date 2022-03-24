import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/ContainerModel.dart';
import 'package:water_drinking_reminder/screen/home/AddContainerScreen.dart';
import 'package:water_drinking_reminder/screen/home/HomeScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/ContainerTile.dart';

class ContainerListScreen extends StatefulWidget {
  @override
  ContainerListScreenState createState() => ContainerListScreenState();

  List<ContainerModel> lstContainer;
  final Function callback;

  ContainerListScreen({Key key, this.callback, this.lstContainer}) : super(key: key);
}

class ContainerListScreenState extends State<ContainerListScreen> {
  List<ContainerModel> lstContainer = [];

  @override
  void initState() {
    super.initState();
    //getContainerList();
    lstContainer = widget.lstContainer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: InkWell(
        onTap: (){
          NavigatorHelper.remove();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 400,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 370,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(
                          children: [
                            Text(
                              buildTranslate(context,"customize"),
                              style: Fonts.orangeTextStyle,
                            ),
                            Expanded(
                              child: GridView.builder(
                                  itemCount: lstContainer.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(10),
                                  physics: ClampingScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    // childAspectRatio: 1/1.08,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          for (int i = 0; i < lstContainer.length; i++) {
                                            lstContainer[i].isSelected = (i == index);
                                          }

                                          HomeScreen home = new HomeScreen();
                                          home.setContainer(lstContainer);

                                          if(widget.callback!=null){
                                            widget.callback(lstContainer[index], index);
                                          }

                                          NavigatorHelper.remove();
                                        });
                                      },
                                      child: ContainerTile(
                                        container: lstContainer[index],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: FloatingActionButton(
                        onPressed: () {
                          NavigatorHelper.openDialog(AddContainerScreen());
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: AppColor.appOrange,
                      ),
                    ),
                  ],
                ),
                //   ],
                // ),
              ),
            ),
          ),
      ),
    );
  }
}