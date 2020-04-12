
import 'package:prizepots/screens/Home.dart';
import 'package:prizepots/screens/ProjectButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prizepots/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectScreen extends StatefulWidget {
  ProjectScreen({Key key, this.animationController, this.notifyParent})
      : super(key: key);
  int buttonCounter;
  int buttonCounter2;
  int buttonCounter3;
  final Function() notifyParent;

  final AnimationController animationController;
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  SharedPreferences sharedPreferences;
  int pressedButton;
  String supportedProject = "(choose with long click)";

  List<Widget> listViews = <Widget>[];
  double topBarOpacity = 0.0;

  void countButton(int buttonCount) {
    widget.buttonCounter = buttonCount;
    setState(() {});
  }

  void countButton2(int buttonCount) {
    widget.buttonCounter2 = buttonCount;
    setState(() {});
  }

  void countButton3(int buttonCount) {
    widget.buttonCounter3 = buttonCount;
    setState(() {});
  }

  void _setColor(String hexColor) {
    color3 = HexColor(hexColor);
    sharedPreferences?.setString("color", hexColor);
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      if (sharedPreferences.getString("supportedProjectText") != null) {
        supportedProject = sharedPreferences.getString("supportedProjectText");
      }
      if (sharedPreferences.getInt("supportedProject") != null) {
        pressedButton = sharedPreferences.getInt("supportedProject");
      }
      if (sharedPreferences.getBool("firstLoginProject")) {
        _showIntroDialog();
      }
      setState(() {

      });
    });
  }

  void _showIntroDialog() {
    showDialog(
        context: context,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(1)),
                borderRadius: BorderRadius.all(Radius.circular(40))), child: new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: Colors.black.withOpacity(1),
          title: new Text("Choose your favorite organisation", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          content: new Text ("1. With a click on the buttons you'll be redirected to the organisations website to be able to gather information. \n\n 2. You can choose your supported organisation with a long click on its button area. \n\n 3. You can always change your supported organisation at any given time.",
          style: TextStyle(color: Colors.white, fontSize: 18),),
          actions: <Widget>[
            new RaisedButton(
              child: Text("Ok"),
              color: Colors.green,
              colorBrightness: Brightness.dark,
              onPressed: () {
                sharedPreferences.setBool("firstLoginProject", false);
                Navigator.of(context, rootNavigator: true).pop();
          },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ],
        )));
  }

  onPressedLoad() {
    Navigator.of(context).pop(true);
    new ProjectScreen();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: LeaveAppDialog()
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: Center(
                child: Container(height: 130,child: Image.asset("assets/logowhitelong.png", fit: BoxFit.contain))
              )),
          body: Stack(children: <Widget>[
            Positioned(top: 50.0, right: 50.0, child: Container(height:50, width:50, color: color3, child: RaisedButton(color: Colors.white, onPressed: () { _showIntroDialog();}))),
//            )IconButton(color: Colors.white, icon: Icon(Icons.info), onPressed: () { _showIntroDialog();})),
            Container(color: Colors.black),
            Opacity(
                opacity: 0.0, child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/logowhitetext.png"), fit: BoxFit.cover),
                  border: Border.all(color: Colors.black.withOpacity(1)),
//                        image: DecorationImage(
//                            fit: BoxFit.cover,
//                            image: AssetImage("assets/background.jpg"))
                ))),
            ListView(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                scrollDirection: Axis.vertical,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                      Container(
                        child: Text(
                          "Supported Project:",
                          style: TextStyle(
                            fontFamily: 'ColaborateThin',
                            color: textColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                      Container(
                        child: Text(
                          supportedProject,
                          style: TextStyle(
                            fontFamily: 'ColaborateThin',
                            color: color3,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                      FlatButton(
                          child: ProjectButton(
                              width: MediaQuery.of(context).size.width - 24,
                              height: 120,
                              pressed: pressedButton == 0,
                              number: 0,
                              url: "https://www.gatesfoundation.org/",
                              path: "Gates Foundation"),
                          onLongPress: () {
                            widget.notifyParent();
                            _setColor("#186955");
//                            _setColor("#AC2641");
                            pressedButton = 0;
                            supportedProject = "Gates Foundation";
                            sharedPreferences.setString(
                                "supportedProjectText", supportedProject);
                            sharedPreferences.setInt(
                                "supportedProject", pressedButton);
                            setState(() {});
                          }),
                      Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                      FlatButton(
                          child: ProjectButton(
                              width: MediaQuery.of(context).size.width - 24,
                              height: 120,
                              pressed: pressedButton == 1,
                              number: 1,
                              url: "https://www.msf.org/",
                              path: "Medecins Sans Frontieres"),
                          onLongPress: () {
                            widget.notifyParent();
                            _setColor("#186955");
//                            _setColor("#EE0000");
                            pressedButton = 1;
                            supportedProject = "Medecins Sans Frontiers";
                            sharedPreferences.setString(
                                "supportedProjectText", supportedProject);
                            sharedPreferences.setInt(
                                "supportedProject", pressedButton);
                            setState(() {});
                          }),
                      FlatButton(
                          child: ProjectButton(
                              width: MediaQuery.of(context).size.width - 24,
                              height: 120,
                              pressed: pressedButton == 2,
                              number: 2,
                              url: "https://www.peta.org/",
                              path: "PETA"),
                          onLongPress: () {
                            widget.notifyParent();
                            _setColor("#186955");
//                            _setColor("#009900");
                            pressedButton = 2;
                            supportedProject = "People for the Ethical Treatment of Animals";
                            sharedPreferences.setString(
                                "supportedProjectText", supportedProject);
                            sharedPreferences.setInt(
                                "supportedProject", pressedButton);
                            setState(() {});
                          }),
                      Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                      FlatButton(
                          child: ProjectButton(
                              width: MediaQuery.of(context).size.width - 24,
                              height: 120,
                              pressed: pressedButton == 3,
                              number: 3,
                              url: "https://theoceancleanup.com/",
                              path: "The Ocean Cleanup"),
                          onLongPress: () {
                            widget.notifyParent();
                            _setColor("#186955");
//                            _setColor("#01CBE1");
                            pressedButton = 3;
                            supportedProject = "The Ocean Cleanup";
                            sharedPreferences.setString(
                                "supportedProjectText", supportedProject);
                            sharedPreferences.setInt(
                                "supportedProject", pressedButton);
                            setState(() {});
                          }),

                      Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                      FlatButton(
                          child: ProjectButton(
                              width: MediaQuery.of(context).size.width - 24,
                              height: 120,
                              pressed: pressedButton == 4,
                              number: 4,
                              url: "https://www.unicef.org/",
                              path: "Unicef"),
                          onLongPress: () {
                            widget.notifyParent();
                            _setColor("#186955");
//                            _setColor("#009AFE");
                            pressedButton = 4;
                            supportedProject = "Unicef";
                            sharedPreferences.setString(
                                "supportedProjectText", supportedProject);
                            sharedPreferences.setInt(
                                "supportedProject", pressedButton);
                            setState(() {});
                          }),
                      Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                      FlatButton(
                          child: ProjectButton(
                              width: MediaQuery.of(context).size.width - 24,
                              height: 120,
                              pressed: pressedButton == 5,
                              number: 5,
                              url: "https://www.worldwildlife.org/",
                              path: "WWF"),
                          onLongPress: () {
                            widget.notifyParent();
                            _setColor("#186955");
//                            _setColor("#808080");
                            pressedButton = 5;
                            supportedProject = "World Wildlife Fund";
                            sharedPreferences.setString(
                                "supportedProjectText", supportedProject);
                            sharedPreferences.setInt(
                                "supportedProject", pressedButton);
                            setState(() {});
                          }),
                      Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),

//                      FlatButton(
//                          child: ProjectButton(
//                              width: MediaQuery.of(context).size.width - 24,
//                              height: 120,
//                              pressed: pressedButton == 6,
//                              number: 6,
//                              url: null,
//                              path: null),
//                          onLongPress: () {
//                            widget.notifyParent();
//                            _setColor("#A87FFF");
//                            pressedButton = 6;
//                            supportedProject = "All";
//                            sharedPreferences.setString(
//                                "supportedProjectText", supportedProject);
//                            sharedPreferences.setInt(
//                                "supportedProject", pressedButton);
//                            setState(() {});
//                          }),
                    ],
                  ),
                ]),
            Positioned(top: -10.0, right: 0.0, child: IconButton(color: Colors.white, icon: Icon(CupertinoIcons.info), onPressed: () { _showIntroDialog();})),
          ]),
        ));
//          );
//        }
//      },
//    ),
//
//          ],
//        ),
//    ) ;
  }
}
