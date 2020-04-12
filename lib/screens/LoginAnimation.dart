import 'package:prizepots/main.dart';
import 'package:prizepots/screens/AccountScreen.dart';
import 'package:prizepots/screens/Home.dart';
import 'package:prizepots/screens/LoginView.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LoginAnimation extends StatelessWidget {

  LoginAnimation(
      {Key key, this.buttonController, this.buttonStatus, this.buttonText, this.isCloseableInt})

      : width = new Tween(
    begin: 200.0,
    end: 70.0,
  )
      .animate(
    new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.2,
      ),
    ),
  ),
        bool = true,
        color = Colors.black,
        size = new Tween(
          begin: 70.0,
          end: 1000.0,
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.9,
              1.0,
              curve: Curves.easeOutCirc,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 10.0),
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),

        super(key: key);

  final AnimationController buttonController;
  final int buttonStatus;
  final String buttonText;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation size;
  final Animation width;
  final color;
  final bool;
  final int isCloseableInt;

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
      return new Padding(
        padding: bool ? containerCircleAnimation.value : 100.0,
        child: Column(children: <Widget>[
        new InkWell(
            onTap: () {
              _playAnimation();
            },
            child: new Hero(
              tag: "animation",
              child: size.value <= 200
                  ? new Container(
                  width: size.value == 70
                      ? width.value
                      : size.value,
                  height:
                  size.value == 70 ? 40.0 : size.value,
                  alignment: FractionalOffset.center,
                  decoration: new BoxDecoration(
                    color: width.value <= 70 ? Colors.black : color3,
                    borderRadius: size.value < 400
                        ? new BorderRadius.all(const Radius.circular(25.0))
                        : new BorderRadius.all(const Radius.circular(0.0)),
                  ),
                  child: width.value > 75.0
                      ? new Text(buttonText,
                    style: new TextStyle(
                      color: textColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  )
                      : bool ? new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 1.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        color3),
                  )
                      : null)
                  : new Container(
                width: size.value,
                height: size.value,
                decoration: new BoxDecoration(
                  shape: size.value < 500
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  color: Colors.black,
                ),
              ),
            )),
        ],)
      );
    }

    @override
    Widget build(BuildContext context) {
      buttonController.addListener(() {
        if (buttonController.isCompleted && buttonStatus == 1) {


        if (isCloseableInt == 1) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => new Home()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => new AccountScreen(isCloseable: false)));
        }
        } else if (buttonController.isCompleted && buttonStatus == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginView(isCloseable: false,)));
        }
      });
      return new AnimatedBuilder(
        builder: _buildAnimation,
        animation: buttonController,
      );
    }
  }