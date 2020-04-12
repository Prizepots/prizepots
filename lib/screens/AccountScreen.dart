import 'dart:ui';
import 'package:prizepots/screens/Home.dart';
import 'package:prizepots/screens/WithdrawScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prizepots/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key, this.animationController, this.isCloseable});
  int buttonCounter;
  int buttonCounter2;
  int buttonCounter3;
  bool isCloseable;

  final AnimationController animationController;
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  List<Widget> listViews = <Widget>[];
  double topBarOpacity = 0.0;
  double currentBalance = 0.0;
  double earnedBalance = 0.0;
  double earnedBalanceSingle = 0.0;
  double earnedBalanceNetwork = 0.0;
  double balancePaid = 0.0;
  double pendingWithdraw = 0.0;
  String userID = "";
  String username;
  SharedPreferences sharedPreferences;
  Map<String, double> dataMap = new Map();
  Map<String, double> dataMap2 = new Map();
  List<Color> colorList;
  double factorNetwork = 0.01;
  double factorSingle = 0.05;
  int friendCount;
  int points;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      userID = sharedPreferences.getString("userID");
      username = sharedPreferences.getString("username");
      points = sharedPreferences.getInt("Points");
      if (sharedPreferences.getBool("firstLoginAccount")) {
        _showIntroDialog();
      }
      _getValues();
    });
  }

  void _showIntroDialog() {
    showDialog(
        context: context,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(1.0)),
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child: new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: Colors.black.withOpacity(1),
              title: new Text("Your Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              content: new Text(
                "1. You can see your account information here. \n\n2. Take a look at your earnings or withdraw them. \n\n3. Remember: You earn a bonus from the earnings of your referred friends. The more friends you referred, the higher your earnings can be.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              actions: <Widget>[
                new RaisedButton(
                  child: Text("Ok"),
                  color: Colors.green,
                  colorBrightness: Brightness.dark,
                  onPressed: () {
                    sharedPreferences.setBool("firstLoginAccount", false);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ],
            )));
  }

  void _getValues() async {
    String url =
        "https://hmr19uex26.execute-api.eu-central-1.amazonaws.com/PostUserBeta/user/" +
            userID;

    String url2 =
        "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/user/referralcode/" +
            username;

    http.Response response = await http.get(url);

    final decoded = jsonDecode(response.body) as Map;
    List<dynamic> users = decoded['Items'];

    earnedBalanceSingle =
        double.parse(decoded['EarnedBalanceSingle'].toString());

    balancePaid = double.parse(decoded['BalancePaid'].toString());
    pendingWithdraw = double.parse(decoded['PendingWithdraw'].toString());

    http.Response response2 = await http.get(url2);

    if (response2.statusCode == 200) {
      final decoded2 = jsonDecode(response2.body) as Map;
      List<dynamic> users2 = decoded2['Items'];
      if (users2.isNotEmpty) {
        friendCount = users2.length;

        for (dynamic name in users2) {
          earnedBalanceNetwork = earnedBalanceNetwork +
              double.parse(name['EarnedBalanceNetwork']) * factorNetwork +
              double.parse(name['EarnedBalanceSingle']) * factorSingle;
        }
      }
    }
    earnedBalance = earnedBalanceSingle + earnedBalanceNetwork;

    currentBalance = earnedBalance - balancePaid - pendingWithdraw;

    dataMap.putIfAbsent("current Balance", () => currentBalance);
    dataMap.putIfAbsent("already paid", () => balancePaid);
    dataMap.putIfAbsent("pending Withdraw", () => pendingWithdraw);
    dataMap2.putIfAbsent("self", () => earnedBalanceSingle);
    dataMap2.putIfAbsent("network effect", () => earnedBalanceNetwork);

    setState(() {});
  }

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

  Future<bool> _onWillPop() {
    return showDialog(context: context, child: new LeaveAppDialog()) ?? false;
  }

  Future<bool> nada() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    colorList = new List();
    colorList.add(color3);
    colorList.add(color3.withOpacity(0.6));
    colorList.add(color3.withOpacity(0.2));
    return WillPopScope(
        onWillPop: widget.isCloseable != null ? nada : _onWillPop,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                title: Center(
                    child: Container(height: 130,child: Image.asset("assets/logowhitelong.png", fit: BoxFit.contain))
                )),
            body: Stack(children: <Widget>[
              Opacity(
                  opacity: 1,
                  child: Container(
                      decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(1)),
                    color: Colors.black,
                  ))),
              ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Row(children: <Widget>[
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 20, right: 8),
                                child: Container(
                                    height: 80,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(top: 3),
                                            child: Text(
                                              "Username:",
                                              style: TextStyle(fontSize: 16),
                                            )),
//                                Expanded(child: SizedBox()),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 0, top: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(child: SizedBox()),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 0),
                                                    child: username != null
                                                        ? Text(username,
                                                            style: TextStyle(
                                                                color: color3,
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                        : Container(
                                                            child:
                                                                CupertinoActivityIndicator())),
                                                Expanded(child: SizedBox()),
                                              ],
                                            ))
                                      ],
                                    )))),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(right: 20, left: 8),
                                child: Container(
                                    height: 80,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(top: 3),
                                            child: Text(
                                              "Balance:",
                                              style: TextStyle(fontSize: 16),
                                            )),
//                                Expanded(child: SizedBox()),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 0, top: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(child: SizedBox()),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 0),
                                                    child: currentBalance !=
                                                                null ||
                                                            currentBalance == 0
                                                        ? Text(
                                                            currentBalance.toStringAsFixed(2),
                                                            style: TextStyle(
                                                                color: color3,
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                        : Container(
                                                            child:
                                                                CupertinoActivityIndicator())),
                                                Text(" EUR",
                                                    style: TextStyle(
                                                        fontSize: 25)),

                                                Expanded(child: SizedBox()),
                                              ],
                                            ))
                                      ],
                                    )))),
                      ]),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 8, top: 12),
                                  child: Container(
                                      height: 80,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: Text(
                                                "Number of Friends:",
                                                style: TextStyle(fontSize: 16),
                                              )),
//                                Expanded(child: SizedBox()),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0, top: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(child: SizedBox()),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: friendCount != null
                                                          ? Text(
                                                              friendCount
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: color3,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                          : currentBalance !=
                                                                  null
                                                              ? Text("0",
                                                                  style: TextStyle(
                                                                      color:
                                                                          color3,
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                              : Container(
                                                                  child:
                                                                      CupertinoActivityIndicator())),
                                                  Expanded(child: SizedBox()),
                                                ],
                                              ))
                                        ],
                                      )))),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 20, left: 8, top: 12),
                                  child: Container(
                                      height: 80,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(child: SizedBox()),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 3),
                                                  child: Text(
                                                    "Current Points:",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  )),
                                              Expanded(child: SizedBox())
                                            ],
                                          ),
//                                Expanded(child: SizedBox()),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0, top: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(child: SizedBox()),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Text(
                                                          points.toString(),
                                                          style: TextStyle(
                                                              color: color3,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                  Expanded(child: SizedBox()),
                                                ],
                                              )),
                                        ],
                                      )))),
                        ],
                      ),
                      SizedBox(height: 10),
                      RaisedButton(
                          child:
                          Text("Withdraw"),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      45))),
                          color: color3,
                          elevation: 5,
                          onPressed: () {

                            if (currentBalance < 5) {
                              Fluttertoast.showToast(
                                  msg: "The minimum withdraw amount is 5€",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: textColor,
                                  fontSize: 15.0);
                            } else {
                              Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => WithdrawScreen(currentBalance: currentBalance),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 500),
                              ));}}),
                      SizedBox(height: 10),
                      Container(
                          height: 210,
                          child: ListView(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(40),
                                              bottomRight: Radius.circular(40),
                                              topLeft: Radius.circular(40),
                                              bottomLeft: Radius.circular(40)),
                                        ),
                                        child: dataMap.isNotEmpty
                                            ? PieChart(
                                                dataMap: dataMap,
                                                animationDuration:
                                                    Duration(milliseconds: 800),
                                                chartLegendSpacing: 32.0,
                                                chartRadius:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3,
                                                showChartValuesInPercentage:
                                                    false,
                                                showChartValues: true,
                                                showChartValuesOutside: true,
                                                chartValueBackgroundColor:
                                                    Colors.white,
                                                colorList: colorList,
                                                showLegends: true,
                                                legendPosition:
                                                    LegendPosition.right,
                                                decimalPlaces: 1,
                                                showChartValueLabel: true,
                                                initialAngle: 0,
                                                chartValueStyle:
                                                    defaultChartValueStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                chartType: ChartType.ring,
                                              )
                                            : SizedBox(
                                                child:
                                                    CupertinoActivityIndicator()))),
                                Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(40),
                                              bottomRight: Radius.circular(40),
                                              topLeft: Radius.circular(40),
                                              bottomLeft: Radius.circular(40)),
                                        ),
                                        child: dataMap2.isNotEmpty
                                            ? PieChart(
                                                dataMap: dataMap2,
                                                animationDuration:
                                                    Duration(milliseconds: 800),
                                                chartLegendSpacing: 32.0,
                                                chartRadius:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3,
                                                showChartValuesInPercentage:
                                                    false,
                                                showChartValues: true,
                                                showChartValuesOutside: true,
                                                chartValueBackgroundColor:
                                                    Colors.white,
                                                colorList: colorList,
                                                showLegends: true,
                                                legendPosition:
                                                    LegendPosition.right,
                                                decimalPlaces: 1,
                                                showChartValueLabel: true,
                                                initialAngle: 0,
                                                chartValueStyle:
                                                    defaultChartValueStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                chartType: ChartType.ring,
                                              )
                                            : SizedBox(
                                                child:
                                                    CupertinoActivityIndicator()))),
                              ])),
                      Padding(
                          padding: EdgeInsets.only(left: 100, right: 100),
                          child: RaisedButton(
                              child: Text("Logout & close"),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              color: color3,
                              elevation: 5,
                              onPressed: () {
                                sharedPreferences?.setBool("firstLogin", true);
                                sharedPreferences?.setString("userID", "");
                                sharedPreferences?.setString("username", "");
                                sharedPreferences?.setBool("loggedIn", false);
                                SystemNavigator.pop();
                              })),
                    ],
                  )
                ],
              ),
              Positioned(top: -10.0, right: 0.0, child: IconButton(color: Colors.white, icon: Icon(CupertinoIcons.info), onPressed: () { _showIntroDialog();})),
            ])));
  }
}

class UserModel {
  final String username;
  final String userID;
  final double currentBalance;
  final String referredBy;
  final double earnedBalanceSingle;
  final double earnedBalanceNetwork;
  final double balancePaid;

  UserModel(
      {this.username,
      this.userID,
      this.currentBalance,
      this.referredBy,
      this.earnedBalanceSingle,
      this.earnedBalanceNetwork,
      this.balancePaid});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['Username'],
      userID: json['UserID'],
      currentBalance: json['Balance'],
      referredBy: json['ReferredBy'],
      earnedBalanceSingle: json['earnedBalanceSingle'],
      earnedBalanceNetwork: json['earnedBalanceNetwork'],
      balancePaid: json['balancePaid'],
    );
  }
}
