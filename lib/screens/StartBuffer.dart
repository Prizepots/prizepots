import 'package:prizepots/screens/Home.dart';
import 'package:prizepots/screens/QuickLoginView.dart';
import 'package:prizepots/main.dart';
import 'package:prizepots/screens/TutorialScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class StartBuffer extends StatefulWidget {
  StartBuffer({Key key}) : super(key: key);
  @override
  StartBufferState createState() => StartBufferState();
}

class StartBufferState extends State<StartBuffer> {

  SharedPreferences sharedPreferences;
  bool _firstLogin = true;
  String username = "";
  bool load = false;
  bool loggedIn = false;

  void persist(bool value) {
    setState(() {
      _firstLogin = value;
    });
    sharedPreferences?.setBool("firstLogin", value);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _firstLogin = sharedPreferences.getBool("firstLogin");
      if (_firstLogin == null) {
        _firstLogin = true;
      }
      if (sharedPreferences.getString("color") != null) {
        color3 = HexColor(sharedPreferences.getString("color"));
      }

      if (_firstLogin) {
        _openTutorialScreen();
      } else {
        _openHomeScreen();
    }
      setState(() {});
    });
  }

  void _openHomeScreen() async {
    await new Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void _openTutorialScreen() async {
    await new Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      body: Scaffold(backgroundColor: Colors.black,
          body: Stack(
              children: <Widget>[
      Padding(padding: EdgeInsets.all(105), child: Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Colors.black, child: Image.asset("assets/logowhitewithoutspace.png"))),

])));

  }
}