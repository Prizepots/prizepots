
import 'package:prizepots/screens/LoginAnimation.dart';
import 'package:flutter/material.dart';
import 'package:prizepots/screens/Home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:prizepots/screens/LoginView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prizepots/main.dart';

class QuickLoginView extends StatefulWidget {
  const QuickLoginView({Key key}) : super(key: key);
  @override
  QuickLoginViewState createState() => QuickLoginViewState();
}

class QuickLoginViewState extends State<QuickLoginView>
    with TickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  AnimationController _loginButtonController;
  int animationStatus = 0;
  int buttonStatus = 0;
  String userID;
  bool _firstLogin;

  void _persist(bool value) {
    sharedPreferences?.setBool("firstLogin", value);
    sharedPreferences?.setBool("loggedIn", !value);
    sharedPreferences?.setBool("firstLoginProject", value);
    sharedPreferences?.setBool("firstLoginPrizepot", value);
    sharedPreferences?.setBool("firstLoginAd", value);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      _firstLogin = sharedPreferences.getBool("firstLogin");
      if (_firstLogin == null) {
        _firstLogin = true;
        _persist(_firstLogin); // set an initial value
      } else {
      setState(() {});

    }});

    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<http.Response> _makePost() async {
    String url =
        "https://hmr19uex26.execute-api.eu-central-1.amazonaws.com/PostUserBeta/user";
    String json = '{"UserID": "' + userID + '"}';
    return http.post(url, body: json);
  }

  void _createUserID() {
    userID = randomAlphaNumeric(10);
    sharedPreferences.setString("userID", userID);
    sharedPreferences.setBool("firstLogin", false);
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        child: new LeaveAppDialog());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
          body: Stack(children: <Widget>[

            Opacity(opacity: 0.4, child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/climbing.jpg"),
                      fit: BoxFit.cover),
                ))),
          Opacity(opacity: 1, child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.0),
                ],
                begin: const FractionalOffset(0.5, 1),
                end: const FractionalOffset(0.5, 0.5),
              ),
          ))),


      Center(
      child: ListView(
      padding: const EdgeInsets.all(0.0),
      children: <Widget>[
        Center( child:
      Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
      animationStatus == 0
      ? Center(child: Padding(
      padding: EdgeInsets.only(
      bottom: 50, top: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height - 150)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    child: Container(height: 100, child: Image.asset("assets/logowhitewithoutspace.png", fit: BoxFit.contain))),
                                    Container(
                                        height: 350,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                Colors.white.withOpacity(0),
                                                Colors.white.withOpacity(0),
                                              ],
                                              begin: const FractionalOffset(0.5, 1),
                                              end: const FractionalOffset(0.5, 0.2),
                                            )),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 200),
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        buttonStatus = 2;
                                                      });
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (c, a1, a2) => LoginView(isCloseable: true),
                                                          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                          transitionDuration: Duration(milliseconds: 500),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      height: 45.0,
                                                      alignment:
                                                          FractionalOffset
                                                              .center,
                                                      decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                        color:
                                            color3.withOpacity(1),

                                                        border: Border.all(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    1.0)),

                                                      ),
                                                      child: Text(
                                                        "Login",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24.0,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: InkWell(
                                                    onTap: () {
                                                      _createUserID();
                                                      _makePost();
                                                      setState(() {
                                                        animationStatus = 1;
                                                        buttonStatus = 1;
                                                        _persist(true);
                                                      });
                                                      _playAnimation();
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              200,
                                                      height: 45.0,
                                                      alignment:
                                                          FractionalOffset
                                                              .center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(40)),
                                                        color:
                                                            Colors.transparent.withOpacity(1),
                                                        border: Border.all(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                1.0)),
                                                      ),
                                                      child: Text(
                                                        "Continue without Login",
                                                        style: TextStyle(
                                                          color: Colors.white.withOpacity(1),
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.3,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(),
                                              SizedBox()
                                            ]))
                              ],
                            )))
                        :
//      SizedBox(height:MediaQuery.of(context).size.height / 2 ),
                    LoginAnimation(
                            isCloseableInt: 1,
                            buttonText: "",
                            buttonStatus: buttonStatus,
                            buttonController: _loginButtonController.view),
                    SizedBox(height:MediaQuery.of(context).size.height / 1.1),
                    ],

                ),
              )])),
    ],)));
  }
}


