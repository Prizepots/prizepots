import 'package:prizepots/main.dart';
import 'package:prizepots/screens/Home.dart';
import 'package:prizepots/screens/LoginAnimation.dart';
import 'package:flutter/material.dart';
import 'package:prizepots/screens/InputField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key, this.isCloseable}) : super(key: key);
  final bool isCloseable;

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  int animationStatus = 0;
  String username;
  String password;
  String referredBy = "XXX";
  String userID;
  int zero = 0;
  var hashDigest;
  String hash;
  bool processing;
  SharedPreferences sharedPreferences;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referredByController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      userID = sharedPreferences.getString("userID");
      username = sharedPreferences.getString("username");
    });
  }

  Future<http.Response> _makePost() async {
    String url =
        "https://hmr19uex26.execute-api.eu-central-1.amazonaws.com/PostUserBeta/user";

    referredBy == "" ? referredBy = "XXX" : referredBy = referredBy;

    String json = '{"UserID": "' +
        userID +
        '", "Username": "' +
        username +
        '", "ReferredBy": "' +
        referredBy +
        '", "Balance": "' +
        '0' +
        '", "EarnedBalanceSingle": "' +
        '0' +
        '", "EarnedBalanceNetwork": "' +
        '0' +
        '", "PendingWithdraw": "' +
        '0' +
        '", "BalancePaid": "' +
        '0' + '"}';

    http.Response response = await http.post(url, body: json);

    if(response.statusCode == 201) {

    Fluttertoast.showToast(
        msg:
        "You successfully created an account",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: textColor,
        fontSize: 15.0);

    sharedPreferences.setString("userID", userID);
    sharedPreferences.setString("username", username);
    sharedPreferences.setBool("firstLogin", false);

  } else if (response.statusCode == 403) {

      Fluttertoast.showToast(
          msg:
          "Something went wrong :/",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: textColor,
          fontSize: 15.0);
    }
  }

  void _calculateHash() {
    var bytes = utf8.encode(username + password);
    hashDigest = sha1.convert(bytes);
    hash = hashDigest.toString();
  }

  void _persist(bool value) {
    sharedPreferences?.setBool("firstLogin", value);
    sharedPreferences?.setBool("firstLoginProject", value);
    sharedPreferences?.setBool("firstLoginPrizepot", value);
    sharedPreferences?.setBool("firstLoginAd", value);
    sharedPreferences?.setBool("firstLoginAccount", value);
    sharedPreferences.setBool("loggedIn", true);
  }

  void _checkSignIn() async {
    _calculateHash();

    String url =
        "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/auth/" + username;

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      if (response.contentLength != 0) {
        User user = User.fromJson(json.decode(response.body));
        if (user.hash == hash) {
          Fluttertoast.showToast(
              msg:
              "login succeeded",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: textColor,
              fontSize: 15.0);

          sharedPreferences.setString("userID", user.userID);
          sharedPreferences.setString("username", user.username);
          sharedPreferences.setBool("loggedIn", true);

          setState(() {
            animationStatus = 1;
            _playAnimation();
          });
        } else {
          Fluttertoast.showToast(
              msg:
              "wrong combination of username and password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: textColor,
              fontSize: 15.0);

          notProcessingAnymore();
        }

  } else {
      Fluttertoast.showToast(
          msg:
          "this is not a valid username",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: textColor,
          fontSize: 15.0);

      notProcessingAnymore();
  }}}

  @override
  void dispose() {
    _loginButtonController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _referredByController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }


  void _createUser() async{
    _calculateHash();
    userID = randomAlphaNumeric(10);

    String url =
        "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/auth";
    String json = '{"UserID": "' +
        userID +
        '", "Username": "' +
        username +
        '", "Hash": "' +
        hash +
        '"}';

    http.Response response = await http.post(url, body: json);

    if (response.statusCode == 403) {
      Fluttertoast.showToast(
          msg:
          "This Username is already taken. Please choose a different name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: textColor,
          fontSize: 15.0);

      notProcessingAnymore();
    }

    else if (response.statusCode == 201){

      sharedPreferences.setString("userID", userID);
      sharedPreferences.setString("username", username);
      _makePost();
      setState(() {
        animationStatus = 1;
        _playAnimation();
      });
  }}

  Future<bool> _onWillPop() {
    return !widget.isCloseable
        ? showDialog(
            context: context,
            child: new LeaveAppDialog())
        : Future.value(true);
  }

  void notProcessingAnymore () {
    setState(() {
      processing = null;
    });
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

            Container(

                  child: ListView(

                children: <Widget>[
                  Center(
                      child:
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Container(width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.black.withOpacity(0.2),
                                Colors.transparent,
                              ],
                              begin: const FractionalOffset(0.5, 1),
                              end: const FractionalOffset(0.5, 0.2),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(height: 30),
                            Container(height: 50, child: Image.asset("assets/logowhitetext.png", fit: BoxFit.contain)),
                            SizedBox(height: 8),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Form(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      InputField(
                                        controller: _usernameController,
                                        hint: "Username",
                                        obscure: false,
                                        icon: Icons.person_outline,
                                      ),
                                      InputField(
                                        controller: _passwordController,
                                        hint: "Password",
                                        obscure: true,
                                        icon: Icons.lock_outline,
                                      ),
                                      InputField(
                                        controller: _referredByController,
                                        hint: "Referred by (username)",
                                        obscure: false,
                                        icon: Icons.group,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100, bottom: 0),
                              ),


//               Padding(padding: EdgeInsets.only(top: 70.0),)
                                ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                      animationStatus == 0
                          ? Column(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                    onTap: () {
                                      username = _usernameController.text.toLowerCase();
                                      password = _passwordController.text;
                                      referredBy = _referredByController.text.toLowerCase();

                                      if (username.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "The field 'Username' can't be empty",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.red,
                                            textColor: textColor,
                                            fontSize: 15.0);
                                      } else if (password.length < 6) {
                                        Fluttertoast.showToast(
                                            msg:
                                            "The 'Password' has a minimum length of 6",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.red,
                                            textColor: textColor,
                                            fontSize: 15.0);
                                      } else if (referredBy == username) {
                                        Fluttertoast.showToast(
                                            msg:
                                            "You can't refer yourself",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.red,
                                            textColor: textColor,
                                            fontSize: 15.0);
                                      } else {

                                      setState(() {
                                        processing = true;
                                      });
                                      _checkSignIn();
                                      _persist(false);
//

                                    }},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      height: 40.0,
                                      alignment: FractionalOffset.center,
                                      decoration: BoxDecoration(
                                        color: color3,
                                        border: Border.all(
                                            color:
                                            Colors.black.withOpacity(1.0)),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(40)),
                                      ),
                                      child: processing != null ?  CupertinoActivityIndicator() : Text(
                                        "Login",
                                        style: TextStyle(
                                          fontFamily: 'ColaborateThin',
                                          color: textColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.3,
                                        ),
                                      )
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                    onTap: () {
                                      username = _usernameController.text.toLowerCase();
                                      password = _passwordController.text;
                                      referredBy = _referredByController.text.toLowerCase();

                                      if (username.isEmpty) {

                                      Fluttertoast.showToast(
                                      msg:
                                      "The field 'Username' can't be empty",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1,
                                      backgroundColor: Colors.red,
                                      textColor: textColor,
                                      fontSize: 15.0);

                                      }
                                      else if (password.length < 6) {
                                      Fluttertoast.showToast(
                                          msg:
                                          "The 'Password' has a minimum length of 6 ",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIos: 1,
                                          backgroundColor: Colors.red,
                                          textColor: textColor,
                                          fontSize: 15.0);
                                      } else {

                                        setState(() {
                                          processing = true;
                                        });
                                      _createUser();
                                      _persist(true);

                                    }},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      height: 40.0,
                                      alignment: FractionalOffset.center,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(1.0)),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(40)),
                                      ),
                                      child: processing != null ?  CupertinoActivityIndicator() : Text(
                                        "Create Account",
                                        style: TextStyle(
                                          fontFamily: 'ColaborateThin',
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    )),
                              )
                            ])
                          : LoginAnimation(
                              isCloseableInt: widget.isCloseable ? 1 : 0,
                              buttonController: _loginButtonController.view,
                              buttonStatus: 1,
                              buttonText: "",
                            ),
                    ],
                  ),)])
            )],
              )));
  }
}

class User {
  final String username;
  final String userID;
  final String hash;

  User({this.username, this.userID, this.hash});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['Username'],
      userID: json['UserID'],
      hash: json['Hash'],
    );
  }


}