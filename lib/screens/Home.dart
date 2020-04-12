

import 'package:prizepots/screens/AccountScreen.dart';
import 'package:prizepots/screens/LoginView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prizepots/screens/ProjectScreen.dart';
import 'package:prizepots/screens/AdScreen.dart';
import 'package:flutter/services.dart';
import 'package:prizepots/main.dart';
import 'package:prizepots/screens/PrizepotScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ads/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController animationController;
  SharedPreferences sharedPreferences;
  bool loggedIn = false;
  Ads appAds;

  final String appId = Platform.isAndroid
      ? 'ca-app-pub-8934304456369736~5937724095'
      : 'ca-app-pub-8934304456369736~5030910493';


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if (sharedPreferences.getBool("loggedIn") != null) {
        loggedIn = sharedPreferences.getBool("loggedIn");
      }
    });
    var eventListener = (MobileAdEvent event) {};
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    appAds = Ads(
      appId,
      listener: eventListener,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        child: new LeaveAppDialog());
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent swipe popping of this page. Use explicit exit buttons only.
        onWillPop: _onWillPop,
        child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
    child: CupertinoTabScaffold(
    tabBar:
        CupertinoTabBar(border: Border(top: BorderSide(color: color3.withOpacity(0.5))), activeColor: color3, backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/logo.png"),
              ),
              title: Text('Prizepots'),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/piggibank.png"),
              ),
              title: Text('Points'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart),
              title: Text('Projects'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              title: Text('Profile'),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          assert(index >= 0 && index <= 3);
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return PrizepotScreen();
                },

              );
              break;
            case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return AdScreen(appAds: appAds, generatedPoints: 0, coindivider: 2.35);
              },
            );
            break;
            case 2:
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return ProjectScreen(notifyParent: refresh );
                },

              );
              break;
            case 3:
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return loggedIn ? AccountScreen() : LoginView(isCloseable: false);
                },
              );
              break;
          }
        })));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}

class LeaveAppDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                  Radius.circular(50))
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Flexible(
                      child: Align(alignment: Alignment.center, child: Text(
                          "Do you really want to close the app?", style: TextStyle(color: Colors.white, fontSize: 20,))),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("No"),
                          color: Colors.red,
                          colorBrightness: Brightness.dark,
                          onPressed: (){Navigator.of(context).pop(false);},
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Yes"),
                          color: Colors.green,
                          colorBrightness: Brightness.dark,
                          onPressed: (){SystemNavigator.pop();},
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ],),
                    SizedBox(height: 10.0)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
