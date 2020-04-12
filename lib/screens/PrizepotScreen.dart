import 'package:prizepots/screens/Home.dart';
import 'package:prizepots/screens/PrizepotButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrizepotScreen extends StatefulWidget {
  PrizepotScreen({Key key, this.animationController}) : super(key: key);
  int buttonCounter;
  int buttonCounter2;
  int buttonCounter3;

  final AnimationController animationController;
  @override
  _PrizepotScreenState createState() => _PrizepotScreenState();
}

class _PrizepotScreenState extends State<PrizepotScreen> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  SharedPreferences sharedPreferences;

  List<Widget> listViews = <Widget>[];
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if (sharedPreferences.getBool("firstLoginPrizepot")) {
        _showIntroDialog();
      }
    });
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
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: Colors.black.withOpacity(1),
              title: new Text("Win Prizepots",
                  style: TextStyle(color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              content: new Text (
                "1. With a click on the buttons you'll see detail information about the Prizepots. \n\n 2. You take part in the money distribution once you reached the conditions for participation shown in the details. \n\n 3. You can gain points to participate while watching Ads (see next tab for more information)",
                style: TextStyle(color: Colors.white, fontSize: 18),),
              actions: <Widget>[
                new RaisedButton(
                  child: Text("Ok"),
                  color: Colors.green,
                  colorBrightness: Brightness.dark,
                  onPressed: () {
                    sharedPreferences.setBool("firstLoginPrizepot", false);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ],
            )));
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

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      child: new LeaveAppDialog()
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
//                  child: Text("ADs for Future",
//                      style: TextStyle(
//                        fontFamily: 'ColaborateThin',
//                        fontWeight: FontWeight.w300,
//                        fontSize: 30.0,
//                        fontStyle: FontStyle.italic,
//                        color: color3,
//                        letterSpacing: 0.5,
//                      ))
          )),
          body: Stack(children: <Widget>[

            Opacity(
                opacity: 1,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(1)),
                      color: Colors.black,
//                        image: DecorationImage(
//                            fit: BoxFit.cover,
//                            image: AssetImage("assets/background.jpg"))
                    ))
            ),

            GridView.count(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                childAspectRatio: (0.69),
                children: [

//                  Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
                      PrizepotButton(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 415,
                          width2: MediaQuery.of(context).size.width / 2.5,
                          number: 0,
                          opacity: 0.5,
                          dollar: "\$",
                          text: "Daily",
                          textCapital: "daily",
                          eligibleText: " / 1000 Points",
                          path: "assets/weekly.jpg"),
//                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                      PrizepotButton(
                          width: MediaQuery.of(context).size.width / 2 ,
                          height: 415,
                          width2: MediaQuery.of(context).size.width / 2.0,
                          number: 1,
                          opacity: 0.5,
                          dollar: "\$\$",
                          text: "Weekly",
                          textCapital: "weekly",
                          eligibleText: " / 5 Daily",
                          path: "assets/weekly.jpg"),
//                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                      PrizepotButton(
                          width: MediaQuery.of(context).size.width / 2 ,
                          height: 415,
                          width2: MediaQuery.of(context).size.width / 1.65,
                          number: 2,
                          opacity: 0.5,
                          dollar: "\$\$\$",
                          text: "Monthly",
                          textCapital: "monthly",
                          eligibleText: " / 3 Weekly",
                          path: "assets/weekly.jpg"),
//                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                      PrizepotButton(
                          width: MediaQuery.of(context).size.width / 2 ,
                          height: 415,
                          width2: MediaQuery.of(context).size.width / 1.35,
                          number: 3,
                          opacity: 0.5,
                          dollar: "\$\$\$\$",
                          text: "Yearly",
                          textCapital: "yearly",
                          eligibleText: " / 10 Monthly",
                          path: "assets/weekly.jpg"),
//                    ],
//                  ),
                ]),
            Positioned(top: -15.0, right: 0.0, child: IconButton(color: Colors.white, icon: Icon(CupertinoIcons.info), onPressed: () { _showIntroDialog();})),
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
