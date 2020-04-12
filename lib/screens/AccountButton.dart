import 'package:flutter/cupertino.dart';
import 'package:prizepots/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prizepots/screens/LoginView.dart';

class AccountButton extends StatefulWidget {
  AccountButton(
      {Key key,
      this.text,
      this.color,
      this.width,
      this.height,
      this.number,
      this.icon,
      this.text1})
      : super(key: key);
  String text;
  String text1;
  Color color;
  double width;
  double height;
  int number;
  Icon icon;

  @override
  _AccountButtonState createState() => _AccountButtonState();
}

class _AccountButtonState extends State<AccountButton> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Center(
        child: Container(
          child: RaisedButton(
            padding: EdgeInsets.all(0),
            color: Colors.transparent,
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40))),
            elevation: 5,
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                border: Border.all(color: color3.withOpacity(1.0)),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40)),
              ),
              height: widget.height - 20,
              width: widget.width - 20,
              child: Row(children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        child: Container(
                            decoration: new BoxDecoration(
                              color: color3,
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.0)),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(40),
                                  bottomLeft: Radius.circular(40)),
                            ),
                            height: 95,
                            width: 27,
                            child: Container(
                              height: 20,
                              width: 20,
                              child: widget.icon,
                            ))),
                    Expanded(child: SizedBox()),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                                height: 40,
                                width: widget.width / 2 - 40,
                                child: Text(
                                  widget.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'ColaborateThin',
                                    color: textColordark,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                )))),
                    Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 10),
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: widget.width / 2 - 40,
                              child: Text(
                                widget.text1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'ColaborateThin',
                                  color: color3,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ))),
                    widget.number == 4
                        ? Container(
                            decoration: new BoxDecoration(
                              color: color2.withOpacity(0.3),
                            ),
                            height: 30,
                            width: 80,
                            child: RaisedButton(
                              onPressed: () {
                                sharedPreferences.setBool("loggedIn", false);
                                Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginView()));
                                Navigator.pop(context);
                              },
                              textColor: textColor,
                              elevation: 5,
                              child: Text(
                                'logout',
                                style: new TextStyle(color: textColor),
                              ),
                            ))
                        : SizedBox()
                  ],
                )
//
//
//
//                  )
//                ],
              ]),
            ),
          ),
        ),
      )
    ]);

//      Container(child: Image.asset("assets/earth.jpg")),
  }
}
