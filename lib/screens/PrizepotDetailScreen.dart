import 'dart:ui';
import 'package:prizepots/screens/BarChartPrizepot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prizepots/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PrizepotDetailScreen extends StatefulWidget {
  PrizepotDetailScreen({Key key, this.animationController, this.prizepot, this.prizepotCapital, this.eligibleText}) : super(key: key);
  int buttonCounter;
  int buttonCounter2;
  int buttonCounter3;
  String prizepot;
  String prizepotCapital;
  String eligibleText;

  final AnimationController animationController;
  @override
  _PrizepotDetailScreenState createState() => _PrizepotDetailScreenState();
}

class _PrizepotDetailScreenState extends State<PrizepotDetailScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  List<Widget> listViews = <Widget>[];
  double topBarOpacity = 0.0;
  double currentBalance = 0.0;
  double earnedBalance = 0.0;
  double earnedBalanceSingle = 0.0;
  double earnedBalanceNetwork = 0.0;
  double balancePaid = 0.0;
  String userID = "";
  String username = "";
  SharedPreferences sharedPreferences;
  Map<String, double> dataMap = new Map();
  Map<String, double> dataMap2 = new Map();
  final List<Color> colorList = new List();
  List<double> dates = new List();
  int userCount;
  bool participate = false;
  double prizepotSize;
  int qualifyCount = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      userID = sharedPreferences.getString("userID");
      username = sharedPreferences.getString("username");
      _getValues();
    });
    colorList.add(color1);
    colorList.add(color2);
    colorList.add(color3);
  }

  void _getValues() async {

    String urlUser =
        "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/" + widget.prizepot.toLowerCase() + "/qualify/" + userID;

    http.Response responseParticipate = await http.get(urlUser, );
    final decodedParticipate = jsonDecode(responseParticipate.body) as Map;
    int participateInt = decodedParticipate['Count'];
    if (participateInt == 1) {
      participate = true;
    } else if (widget.prizepot.toLowerCase() != "daily") {
    String urlUserPrizepot = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/" + widget.prizepot.toLowerCase() + "/" + userID;
    http.Response responsePrizepot = await http.get(urlUserPrizepot);
    final decodedPrizepot = jsonDecode(responsePrizepot.body) as Map;
    qualifyCount = decodedPrizepot['Count'];
    } else if (widget.prizepot.toLowerCase() == "daily"){
      qualifyCount = sharedPreferences.getInt("Points");
      if (qualifyCount == null) {
        qualifyCount = 0;
      }
    }

    String url =
        "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/details/" +
           widget.prizepot ;

    http.Response response = await http.get(url);

    final decoded = jsonDecode(response.body) as Map;
    List<dynamic> datesplace = decoded['Items'];
    List<dynamic> datesDouble = new List();

    for (dynamic date in datesplace) {
      datesDouble.add(date[widget.prizepot]);
    }

    for (dynamic date in datesDouble) {
      if (dates.length < 7 && date != null) {
        dates.add(double.parse(date));
      } else {
        break;
      }
    }

     String urlprizepot = "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/jackpot/" + widget.prizepotCapital;
     http.Response prizepotUser = await http.get(urlprizepot);

     final decodedUser = jsonDecode(prizepotUser.body) as Map;
//    final decodedUsers = jsonDecode(prizepotUser.body) as Map;
    try {
      userCount = decodedUser['Count'];
    } catch (e) {
    }

    if (userCount == null) {
      userCount = 0;
    }

    if (dates.length >= 3) {
      prizepotSize = (dates[dates.length - 1] + dates[dates.length - 2] + dates[dates.length - 3]) / 3;
    } else if (dates.length == 2) {
      prizepotSize = (dates[dates.length - 1] + dates[dates.length - 2]) / 2;
    } else if (dates.length == 1) {
      prizepotSize = dates[dates.length-1];
    } else {
      prizepotSize = 0;
    }

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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Center(
                child: Container(height: 130,child: Image.asset("assets/logowhitelong.png", fit: BoxFit.contain))
//                child: Text("ADs for Future",
//                    style: TextStyle(
//                      fontFamily: 'ColaborateThin',
//                      fontWeight: FontWeight.w300,
//                      fontSize: 30.0,
//                      fontStyle: FontStyle.normal,
//                      color: color3,
//                      letterSpacing: 0.5,
//                    ))
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
            padding: EdgeInsets.only(top: 8, bottom: 8),
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                  padding: EdgeInsets.all(40),
                  child: BarChartPrizepot(
                    dates: dates, color: color3,
                  )),
              Row(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 8),
                        child: Container(
                            height: 80,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                          padding: EdgeInsets.only(top: 3), child:
                                Text("Projected Size:", style: TextStyle(fontSize: 16),)),
//                                Expanded(child: SizedBox()),
                                Padding(
    padding: EdgeInsets.only(bottom: 0, top:10), child: Row(children: <Widget>[
Expanded(child: SizedBox()),
                                    Padding(padding: EdgeInsets.only(top:0),child: prizepotSize != null ? Text(prizepotSize.round().toString(), style: TextStyle(color: color3, fontSize: 30, fontWeight: FontWeight.bold)) : Container(child: CupertinoActivityIndicator())),



                                  Text(" EUR", style: TextStyle(fontSize: 25)),
                                  Expanded(child: SizedBox()),
                                ],))],
                            )))),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: 20, left: 8),
                        child: Container(
                            height: 80,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 3), child:
                                Text("Qualified:", style: TextStyle(fontSize: 16),)),
//                                Expanded(child: SizedBox()),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 0, top:10), child: Row(children: <Widget>[
                                  Expanded(child: SizedBox()),
                                  Padding(padding: EdgeInsets.only(top:0),child: userCount != null? Text(userCount.toString(), style: TextStyle(color: color3, fontSize: 30, fontWeight: FontWeight.bold)) : Container(child: CupertinoActivityIndicator())),



                                  Text("  User", style: TextStyle(fontSize: 25)),
                                  Expanded(child: SizedBox()),
                                ],))],
                            )))),
              ]),
              Row(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 8, top: 12),
                        child: Container(
                            height: 80,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 3), child:
                                Text("Share / User:", style: TextStyle(fontSize: 16),)),
//                                Expanded(child: SizedBox()),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 0, top:10), child: Row(children: <Widget>[
                                  Expanded(child: SizedBox()),
                                  Padding(padding: EdgeInsets.only(top:0),child: userCount != null?  Text( userCount == 0 ? "0" : (prizepotSize / userCount).toStringAsFixed(2), style: TextStyle(color: color3, fontSize: 30, fontWeight: FontWeight.bold)): Container(child: CupertinoActivityIndicator())),

                                  Padding(padding: EdgeInsets.only(top:0),child: userCount != null && (prizepotSize / userCount).toString().length < 6 ?  Text( userCount == 0 ? "" : "," + (prizepotSize / userCount).toStringAsFixed(2).substring((prizepotSize / userCount).toStringAsFixed(2).length - 2, (prizepotSize / userCount).toStringAsFixed(2).length), style: TextStyle(color: color3, fontSize: 30, fontWeight: FontWeight.bold)): SizedBox()),


                                  Text(" EUR", style: TextStyle(fontSize: 25)),
                                  Expanded(child: SizedBox()),
                                ],))],
                            )))),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: 20, left: 8, top: 12),
                        child: Container(
                            height: 80,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(child: SizedBox()),
                                Padding(
                                    padding: EdgeInsets.only(top: 3), child:
                                Text("Participating:", style: TextStyle(fontSize: 16),)),
                                Padding(padding: EdgeInsets.only(top:0),child: participate ?
                                SizedBox() : userCount != null ?
                                Icon(Icons.block, color: Colors.red) : SizedBox()),
                                  Expanded(child: SizedBox())],),
//                                Expanded(child: SizedBox()),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 0, top:5), child: Row(children: <Widget>[
                                  Expanded(child: SizedBox()),
                                  userCount != null ?
                                  participate ?
                                  Container(child:Icon(Icons.check, size: 35.0, color: Colors.green)) :
                                  Padding(padding: EdgeInsets.only(top:0),child: Text(qualifyCount.toString(), style: TextStyle(color: color3, fontSize: 25, fontWeight: FontWeight.bold))) : Container(child: CupertinoActivityIndicator()),
                                  userCount != null ? participate ?
                                  SizedBox() : Padding(padding: EdgeInsets.only(top:0),child: Text(widget.eligibleText, style: TextStyle(fontSize: 15))) : SizedBox(),
                                  Expanded(child: SizedBox()),
                                ],
                                )),
                                Expanded(child: SizedBox()),
                                Padding(padding: EdgeInsets.only(bottom: 3), child: Container (child: widget.prizepot == "Daily" ? Text("") : widget.prizepot == "Weekly" ? Text("this week", style: TextStyle(fontSize: 15)) : widget.prizepot == "Monthly" ? Text("this month", style: TextStyle(fontSize: 15)) : Text("this year", style: TextStyle(fontSize: 15)))),
                              ],
                            )))),
              ])
            ],
          )
        ]));
  }
}
