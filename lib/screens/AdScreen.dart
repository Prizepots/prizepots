import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ads/ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:animator/animator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io';
import 'package:prizepots/screens/DraggablePigibank.dart';
import 'dart:convert';
import 'package:prizepots/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdScreen extends StatefulWidget {
  AdScreen({Key key, this.animate, this.appAds, this.randomInt, this.generatedPoints, this.coindivider}) : super(key: key);
  bool animate;
  Ads appAds;
  int randomInt;
  double generatedPoints;
  double coindivider;

  @override
  _AdScreenState createState() => new _AdScreenState();
}

class _AdScreenState extends State<AdScreen>
    with TickerProviderStateMixin {

  int points = 0;
  double generatedPoints = 0;
  int sizeDivider = 13;
  final int max = 1000;
  double screen;
  double factor;
  SharedPreferences sharedPreferences;
  AnimationController rotationController;
  AnimationController animationController;
  Random rnd = Random();
  String userID;
  double multiplier = 1.10;
  bool disabled;
  DateTime timestamp;
  double coindivider = 2.2;
  bool processing = false;
  static final int qualifyForWeekly = 5;
  static final int qualifyForMonthly = 3;
  static final int qualifyForYearly = 10;

  final String videoUnitId = Platform.isAndroid
      ? 'ca-app-pub-8934304456369736/6236628060'
      : 'ca-app-pub-8934304456369736/4042984656';

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(duration: const Duration(milliseconds: 5000), vsync: this);
    animationController = AnimationController(duration: const Duration(milliseconds: 5000), vsync: this);
    rotationController.repeat();

    SharedPreferences.getInstance().then(
      (SharedPreferences sp) {
        sharedPreferences = sp;

        points = sharedPreferences.getInt("Points");
        userID = sharedPreferences.getString("userID");

        if (sharedPreferences.getBool("firstLoginAd")) {
          _showIntroDialog();
        }

        setState(() {});

        widget.appAds.setVideoAd(
            adUnitId: videoUnitId,
            listener: (RewardedVideoAdEvent event,
                {String rewardType, int rewardAmount}) {
              print(event);
              Random rnd;
              int min = 1;
              int max = 10;
              rnd = new Random();
              int random = min + rnd.nextInt(max - min);

//              if (event == RewardedVideoAdEvent.started) {
//                generatedPoints = 200;
//                points = points + generatedPoints.toInt();
//              }
              if (event == RewardedVideoAdEvent.rewarded) {
                generatedPoints = random.toDouble() * 10;
                points = points + generatedPoints.toInt();
              }
              if (event == RewardedVideoAdEvent.leftApplication) {
                generatedPoints = random.toDouble() * 5;
                points = points + generatedPoints.toInt();
              }
              sharedPreferences.setInt("Points", points);

              if (points > 0) {
                if (points <= 1000) {
                  coindivider = 2.35;
                } else if (points <= 2000) {
                  coindivider = 1.675;
                } else if (points <= 3000) {
                  coindivider = 3.75;
                } else if (points <= 4000) {
                  coindivider = 1.325;
                } else {
                  coindivider = 9.5;
                }
              }
              if (event == RewardedVideoAdEvent.closed) {

                widget.appAds.dispose();
                animationController.dispose();
                rotationController.dispose();
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => new AdScreen(animate: true, appAds: widget.appAds, generatedPoints: generatedPoints, coindivider: coindivider),
                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 500),
                    ));
              }
            });
      },
    );
  }

  void _showIntroDialog() {
    showDialog(
        context: context,
        child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(1.0)),
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child: new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              backgroundColor: Colors.black.withOpacity(1),
              title: new Text("Earn Points",
                  style: TextStyle(color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              content: new Text (
                "1. Once you hit the Button 'Earn Points' an ad will pop up. \n\n2. After finishing, you'll receive a varying amount of points. \n\n3. Once you reached enough points, you can participate in the distribution. \n\n4. Participation is allowed only once per day, but you can earn as much points as you want. Your points stay valid and can be used for any following days.",
                style: TextStyle(color: Colors.white, fontSize: 18),),
              actions: <Widget>[
                new RaisedButton(
                  child: Text("Ok"),
                  color: Colors.green,
                  colorBrightness: Brightness.dark,
                  onPressed: () {
                    sharedPreferences.setBool("firstLoginAd", false);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ],
            )));
  }

  void _qualifyUserForPrizepots() async {
    String qualifyWeeklyUrl = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/weekly/qualify";
    String qualifyWeeklyJson = '{"UserID": "' +
        userID +
        '", "Timestamp": "' +
        timestamp.toString() +
        '"}';

    await http.post(qualifyWeeklyUrl, body: qualifyWeeklyJson);

    String urlUserWeekly = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/weekly/" + userID;
    http.Response responseWeekly = await http.get(urlUserWeekly);
    final decodedWeekly = jsonDecode(responseWeekly.body) as Map;
    int qualifyCountWeekly = decodedWeekly['Count'];

    if (qualifyCountWeekly == qualifyForWeekly) {

      String urlWeekly = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/weekly";
      String jsonWeekly = '{"UserID": "' +
          userID +
          '"}';
      await http.post(urlWeekly, body: jsonWeekly);

      String qualifyMonthlyUrl = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/monthly/qualify";
      String qualifyMonthlyJson = '{"UserID": "' +
          userID +
          '", "Timestamp": "' +
          timestamp.toString() +
          '"}';
      await http.post(qualifyMonthlyUrl, body: qualifyMonthlyJson);

      String urlUserMonthly = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/monthly/" + userID;
      http.Response responseMonthly = await http.get(urlUserMonthly);
      final decodedMonthly = jsonDecode(responseMonthly.body) as Map;
      int qualifyCountMonthly = decodedMonthly['Count'];

      if (qualifyCountMonthly == qualifyForMonthly) {

        String urlMonthly = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/monthly";
        String jsonMonthly = '{"UserID": "' +
            userID +
            '"}';
        await http.post(urlMonthly, body: jsonMonthly);

        String qualifyMonthlyUrl = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/yearly/qualify";
        String qualifyMonthlyJson = '{"UserID": "' +
            userID +
            '", "Timestamp": "' +
            timestamp.toString() +
            '"}';
        await http.post(qualifyMonthlyUrl, body: qualifyMonthlyJson);

        String urlUserMonthly = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/yearly/" + userID;
        http.Response responseMonthly = await http.get(urlUserMonthly);
        final decodedMonthly = jsonDecode(responseMonthly.body) as Map;
        int qualifyCountYearly = decodedMonthly['Count'];

        if (qualifyCountYearly == qualifyForYearly) {
          String urlYearly =
              "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/yearly";
          String jsonYearly = '{"UserID": "' +
              userID +
              '"}';
          await http.post(urlYearly, body: jsonYearly);
        }
      }
    }

  }
  void _addUserToPrizepot() async {
    processing = true;

    setState(() {

    });

    String urlUser = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/daily/qualify/" + userID;
    http.Response responseParticipate = await http.get(urlUser);
    final decodedParticipate = jsonDecode(responseParticipate.body) as Map;
    int participate = decodedParticipate['Count'];
    timestamp = DateTime.now().toUtc();
    String supportedProject = sharedPreferences.getString("supportedProjectText");

    if (participate == null || participate == 0) {
      String url =
          "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/daily";

      String json = '{"UserID": "' +
          userID +
          '", "SupportedProject": "' +
          supportedProject +
          '"}';

      _qualifyUserForPrizepots();

      http.Response response = await http.post(url, body: json);

      if (response.statusCode == 201) {
        points = points - max;
        sharedPreferences.setInt("Points", points);
        Fluttertoast.showToast(
            msg:
            "You successfully claimed your Prizepots",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: textColor,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg:
          "You are already participating today",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: textColor,
          fontSize: 15.0);
    }

    setState(() {
      processing = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.height - 120;
    factor = max / screen;
    if (points == null) {
      points = 0;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
              child: Container(height: 130,child: Image.asset("assets/logowhitelong.png", fit: BoxFit.contain))
      )),
      body: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 1.7), child: DraggablePigibank(child: AnimatedContainer(
              width: 125,
              height: 125,
              duration: const Duration(milliseconds: 750),
              curve: Curves.bounceIn,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/piggibank.png"),
                    fit: BoxFit.cover),
                color: Colors.black,
                border: Border.all(
                    color: Colors.black),),
              child: Padding(padding: EdgeInsets.only(top: 25, right: 5), child: Center(child: Text(points.toString() + "p", style: TextStyle(fontSize: 26),
              )))))),


          RotationTransition(
            turns: Tween(begin: 0.5, end: 1.0).animate(rotationController),
            child: Padding (padding: EdgeInsets.only(right: 0), child: Align(alignment: Alignment.center, child: Container(
              height: widget.generatedPoints != null ? 0 : 0,
//              widget.generatedPoints != null ? 0 : 0,
              color: Colors.transparent,
                child: Image.asset('assets/coin.png',
                    fit: BoxFit.cover),
            ),),),),

          Opacity (opacity: points <= 4000 ? 0.0 : points > 4100 ? 1.0 : ((points - 4000) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: 10000,)),
          Opacity (opacity: points <= 4100 ? 0.0 : points > 4200 ? 1.0 : ((points - 4100) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier,)),
          Opacity (opacity: points <= 4200 ? 0.0 : points > 4300 ? 1.0 : ((points - 4200) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 2,)),
          Opacity (opacity: points <= 4300 ? 0.0 : points > 4400 ? 1.0 : ((points - 4300) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 3,)),
          Opacity (opacity: points <= 4400 ? 0.0 : points > 4500 ? 1.0 : ((points - 4400) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 4,)),
          Opacity (opacity: points <= 4500 ? 0.0 : points > 4600 ? 1.0 : ((points - 4500) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 5,)),
          Opacity (opacity: points <= 4600 ? 0.0 : points > 4700 ? 1.0 : ((points - 4600) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 6,)),
          Opacity (opacity: points <= 4700 ? 0.0 : points > 4800 ? 1.0 : ((points - 4700) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 7,)),
          Opacity (opacity: points <= 4800 ? 0.0 : points > 4900 ? 1.0 : ((points - 4800) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 8,)),
          Opacity (opacity: points <= 4900 ? 0.0 : points > 5000 ? 1.0 : ((points - 4900) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 9,)),
          
          Opacity (opacity: points <= 3000 ? 0.0 : points > 3100 ? 1.0 : ((points - 3000) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: 10000,)),
          Opacity (opacity: points <= 3100 ? 0.0 : points > 3200 ? 1.0 : ((points - 3100) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier,)),
          Opacity (opacity: points <= 3200 ? 0.0 : points > 3300 ? 1.0 : ((points - 3200) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 2,)),
          Opacity (opacity: points <= 3300 ? 0.0 : points > 3400 ? 1.0 : ((points - 3300) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 3,)),
          Opacity (opacity: points <= 3400 ? 0.0 : points > 3500 ? 1.0 : ((points - 3400) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 4,)),
          Opacity (opacity: points <= 3500 ? 0.0 : points > 3600 ? 1.0 : ((points - 3500) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 5,)),
          Opacity (opacity: points <= 3600 ? 0.0 : points > 3700 ? 1.0 : ((points - 3600) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 6,)),
          Opacity (opacity: points <= 3700 ? 0.0 : points > 3800 ? 1.0 : ((points - 3700) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 7,)),
          Opacity (opacity: points <= 3800 ? 0.0 : points > 3900 ? 1.0 : ((points - 3800) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 8,)),
          Opacity (opacity: points <= 3900 ? 0.0 : points > 4000 ? 1.0 : ((points - 3900) * 0.01), child:
          CoinStack(left: 0, right: MediaQuery.of(context).size.width / 10, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 9,)),

          Opacity (opacity: points <= 2000 ? 0.0 : points > 2100 ? 1.0 : ((points - 2000) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: 10000,)),
          Opacity (opacity: points <= 2100 ? 0.0 : points > 2200 ? 1.0 : ((points - 2100) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier,)),
          Opacity (opacity: points <= 2200 ? 0.0 : points > 2300 ? 1.0 : ((points - 2200) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 2,)),
          Opacity (opacity: points <= 2300 ? 0.0 : points > 2400 ? 1.0 : ((points - 2300) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 3,)),
          Opacity (opacity: points <= 2400 ? 0.0 : points > 2500 ? 1.0 : ((points - 2400) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 4,)),
          Opacity (opacity: points <= 2500 ? 0.0 : points > 2600 ? 1.0 : ((points - 2500) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 5,)),
          Opacity (opacity: points <= 2600 ? 0.0 : points > 2700 ? 1.0 : ((points - 2600) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 6,)),
          Opacity (opacity: points <= 2700 ? 0.0 : points > 2800 ? 1.0 : ((points - 2700) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 7,)),
          Opacity (opacity: points <= 2800 ? 0.0 : points > 2900 ? 1.0 : ((points - 2800) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 8,)),
          Opacity (opacity: points <= 2900 ? 0.0 : points > 3000 ? 1.0 : ((points - 2900) * 0.01), child:
          CoinStack(right: 0, left: MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomLeft, multiplier: multiplier / 9,)),

          Opacity (opacity: points <= 1000 ? 0.0 : points > 1100 ? 1.0 : ((points - 1000) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: 10000,)),
          Opacity (opacity: points <= 1100 ? 0.0 : points > 1200 ? 1.0 : ((points - 1100) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier,)),
          Opacity (opacity: points <= 1200 ? 0.0 : points > 1300 ? 1.0 : ((points - 1200) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 2,)),
          Opacity (opacity: points <= 1300 ? 0.0 : points > 1400 ? 1.0 : ((points - 1300) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 3,)),
          Opacity (opacity: points <= 1400 ? 0.0 : points > 1500 ? 1.0 : ((points - 1400) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 4,)),
          Opacity (opacity: points <= 1500 ? 0.0 : points > 1600 ? 1.0 : ((points - 1500) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 5,)),
          Opacity (opacity: points <= 1600 ? 0.0 : points > 1700 ? 1.0 : ((points - 1600) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 6,)),
          Opacity (opacity: points <= 1700 ? 0.0 : points > 1800 ? 1.0 : ((points - 1700) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 7,)),
          Opacity (opacity: points <= 1800 ? 0.0 : points > 1900 ? 1.0 : ((points - 1800) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 8,)),
          Opacity (opacity: points <= 1900 ? 0.0 : points > 2000 ? 1.0 : ((points - 1900) * 0.01), child:
          CoinStack(left: 0, right:MediaQuery.of(context).size.width / 3.8, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomRight, multiplier: multiplier / 9,)),
          
          Opacity (opacity: points <= 0 ? 0.0 : points > 100 ? 1.0 : ((points - 0) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: 10000,)),
          Opacity (opacity: points <= 100 ? 0.0 : points > 200 ? 1.0 : ((points - 100) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier,)),
          Opacity (opacity: points <= 200 ? 0.0 : points > 300 ? 1.0 : ((points - 200) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 2,)),
          Opacity (opacity: points <= 300 ? 0.0 : points > 400 ? 1.0 :  ((points - 300) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 3,)),
          Opacity (opacity: points <= 400 ? 0.0 : points > 500 ? 1.0 : ((points - 400) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 4,)),
          Opacity (opacity: points <= 500 ? 0.0 : points > 600 ? 1.0 : ((points - 500) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 5,)),
          Opacity (opacity: points <= 600 ? 0.0 : points > 700 ? 1.0 : ((points - 600) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 6,)),
          Opacity (opacity: points <= 700 ? 0.0 : points > 800 ? 1.0 : ((points - 700) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 7,)),
          Opacity (opacity: points <= 800 ? 0.0 : points > 900 ? 1.0 : ((points - 800) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 8,)),
          Opacity (opacity: points <= 900 ? 0.0 : points > 1000 ? 1.0 : ((points - 900) * 0.01), child:
          CoinStack(left: 0.0, right: 0.0, points: points, max: max, sizeDivider: sizeDivider, factor: factor, alignment: Alignment.bottomCenter, multiplier: multiplier / 9,)),

          Opacity(opacity: widget.animate != null && points < 5000 && points > 0 ? 1.0 : 0.0,
              child: Animator(
                  tween: Tween<Offset>(begin: Offset((MediaQuery.of(context).size.width / 50) / widget.coindivider, 0), end: Offset((MediaQuery.of(context).size.width / 50) / widget.coindivider, MediaQuery.of(context).size.height / 50)),
//              : points > 1000 && points <= 2000 ? Tween<Offset>(begin: Offset((MediaQuery.of(context).size.width / 50) / 1, 0), end: Offset((MediaQuery.of(context).size.width / 50) / 1.2, MediaQuery.of(context).size.height / 50))
//              : points > 2000 && points <= 3000 ? Tween<Offset>(begin: Offset((MediaQuery.of(context).size.width / 50) / 2.8, 0), end: Offset((MediaQuery.of(context).size.width / 50) / 2.8, MediaQuery.of(context).size.height / 50))
//              : points > 3000 && points <= 4000 ? Tween<Offset>(begin: Offset((MediaQuery.of(context).size.width / 50) / 0.4, 0), end: Offset((MediaQuery.of(context).size.width / 50) / 0.4, MediaQuery.of(context).size.height / 50))
//              : points > 4000 && points <= 5000 ? Tween<Offset>(begin: Offset((MediaQuery.of(context).size.width / 50) / 13.5, 0), end: Offset((MediaQuery.of(context).size.width / 50) / 13.5, MediaQuery.of(context).size.height / 50))

                  duration: Duration(seconds: 5),
                  cycles: 1, builder: (anim) =>
                  SlideTransition(position: anim,
                      child: Animator(
                          tween: Tween<double>(begin: 0, end: 50),
                          duration: Duration(milliseconds: 100000),
                          repeats: 0,
                          builder:

                              (anim) =>
                              Transform.rotate(angle: anim.value, child: Animator(
                                  tween: Tween<double>(begin: 0, end: 700),
                                  duration: Duration(milliseconds: 100000),
                                  repeats: 0,
                                  builder:

                                      (anim) =>
                                      Transform(
                                          transform: Matrix4.rotationX(anim.value),
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: 50,
                                            color: Colors.transparent,
                                            child: Opacity(
                                              opacity: 1,
                                              child: Image.asset('assets/coin.png',
                                                  fit: BoxFit.cover),
                                            ),
                                          )))))))),

            Center(  child:   FloatingActionButton.extended(
            highlightElevation: 0,
            heroTag: true,
            focusColor: Colors.white,
            icon: Icon(CupertinoIcons.play_arrow_solid, color: Colors.black),
            label: Text("earn points", style: TextStyle(fontFamily: "ColaborateThin", color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
            backgroundColor: color3,
            splashColor: color3.withOpacity(0.5),
            autofocus: true,
            elevation: 0,
            foregroundColor: Colors.black,
            onPressed: () {

              widget.appAds.showVideoAd(state: this);

            },
          ),
          ),

          points >= 1000 ? Center( child: Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 1.8, left: MediaQuery.of(context).size.width / 1.5), child:   FloatingActionButton.extended(
            highlightElevation: 0,
            heroTag: false,
            icon: ImageIcon(
                AssetImage("assets/hammer.png")),
            label: processing ? CupertinoActivityIndicator() : Text("claim", style: TextStyle(fontFamily: "ColaborateThin", color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            backgroundColor: processing ? Colors.white : Colors.black,
            splashColor: color3.withOpacity(0.5),
            autofocus: true,
            elevation: 20,
            foregroundColor: processing ? Colors.black : Colors.white,
            onPressed: () {
              if (sharedPreferences.getString("supportedProjectText") == null) {
                sharedPreferences.setString("supportedProjectText", "all");
              }
              _addUserToPrizepot();
              setState(() {

              });
              },
              ))) : SizedBox(),

          Positioned(top: -10.0, right: 0.0, child: IconButton(color: Colors.white, icon: Icon(CupertinoIcons.info), onPressed: () { _showIntroDialog();})),
        ],
      ),
    );
  }
}

class CoinStack extends StatelessWidget {

  CoinStack({Key key, this.points, this.sizeDivider, this.factor, this.max, this.multiplier, this.alignment, this.left, this.right});

  int points;
  int sizeDivider;
  final int max;
  double factor;
  double multiplier;
  Alignment alignment;
  double left;
  double right;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: alignment,child: Padding(padding: EdgeInsets.only(left: left, right: right, bottom: max / factor / sizeDivider / multiplier ), child: Container(
      height: (MediaQuery.of(context).size.height / sizeDivider )*0.6 + 20,
      color: Colors.transparent,
      child: Opacity(
        opacity: 1,
        child: Image.asset('assets/coins.png',
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover),
      ),
    )));
  }

}

class FlippingCoin extends StatelessWidget {

  FlippingCoin({Key key, this.points, this.coindivider, this.animate});

  int points;
  double coindivider;
  bool animate;


  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: animate != null && points < 5000 && points > 0 ? 1.0 : 0.0,
        child: Animator(
            tween: Tween<Offset>(begin: Offset((MediaQuery.of(context).size.width / 50) / coindivider, 0), end: Offset((MediaQuery.of(context).size.width / 50) / coindivider, MediaQuery.of(context).size.height / 50)),
            duration: Duration(seconds: 5),
            cycles: 1, builder: (anim) =>
            SlideTransition(position: anim,
                child: Animator(
                    tween: Tween<double>(begin: 0, end: 50),
                    duration: Duration(milliseconds: 100000),
                    repeats: 0,
                    builder:

                        (anim) =>
                        Transform.rotate(angle: anim.value, child: Animator(
                            tween: Tween<double>(begin: 0, end: 700),
                            duration: Duration(milliseconds: 100000),
                            repeats: 0,
                            builder:

                                (anim) =>
                                Transform(
                                    transform: Matrix4.rotationX(anim.value),
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50,
                                      color: Colors.transparent,
                                      child: Opacity(
                                        opacity: 1,
                                        child: Image.asset('assets/coin.png',
                                            fit: BoxFit.cover),
                                      ),
                                    ))))))));
  }
}
