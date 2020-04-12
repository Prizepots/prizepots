import 'package:prizepots/screens/AccountScreen.dart';
import 'package:prizepots/screens/InputField.dart';
import 'package:prizepots/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:prizepots/screens/TutorialSwiper.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawScreen extends StatefulWidget {

  WithdrawScreen({Key key, this.currentBalance});
  double currentBalance;

  @override
  WithdrawScreenState createState() => WithdrawScreenState();
}

class WithdrawScreenState extends State<WithdrawScreen> {
  final SwiperController _swiperController = SwiperController();
  final int _pageCount = 2;
  int _currentIndex = 0;
  double amount = 0.0;
  double cost;
  String userID;
  DateTime timestamp;
  String paymentMethod;
  String emailWallet;
  String username;
  SharedPreferences sharedPreferences;
  final _controller = TextEditingController();
  final _amountController = TextEditingController();
  final List<String> titles = [
    "PayPal",
    "Bitcoin",
    // "Fantom",
  ];
  final List<String> subtitles = [
    "Paypal account E-mail:",
    "BTC wallet address:",
    //"FTM wallet address:",
  ];

  void _requestWithdraw() async {
    timestamp = DateTime.now();
    String url =
        "https://4bik97sfud.execute-api.eu-central-1.amazonaws.com/Login/withdraw";

    String json = '{"UserID": "' +
        userID +
        '", "Timestamp": "' +
        timestamp.toString() +
        '", "Username": "' +
        username +
        '", "PaymentMethod": "' +
        paymentMethod +
        '", "EmailWallet": "' +
        emailWallet +
        '", "Amount": "' +
        amount.toString() +
        '", "AmountToWithdraw": "' +
        (amount - cost).toStringAsFixed(2) +
        '"}';

    http.Response response = await http.post(url, body: json);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(
          msg: "Withdrawal successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: textColor,
          fontSize: 15.0);

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => AccountScreen(isCloseable: true),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 500),
          ));
    } else {
      Fluttertoast.showToast(
          msg: "Withdrawal failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: textColor,
          fontSize: 15.0);
    }
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        emailWallet = _controller.text;
      });
    });
    _amountController.addListener(() {
      setState(() {
        if (_amountController.text != null) {
          amount = double.parse(_amountController.text);
        }
      });
    });

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      userID = sharedPreferences.getString("userID");
      username = sharedPreferences.getString("username");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
              child: Container(
                  height: 130,
                  child: Image.asset("assets/logowhitelong.png",
                      fit: BoxFit.contain))
              )),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                  child: Swiper(
                index: _currentIndex,
                controller: _swiperController,
                itemCount: _pageCount,
                onIndexChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                loop: true,
                itemBuilder: (context, index) {
                  return _buildPage(
                      title: titles[index],
                      subtitle: subtitles[index]);
                },
                pagination: SwiperPagination(
                    builder: TutorialSwiper(
                  activeSize: Size(10.0, 20.0),
                  size: Size(10.0, 15.0),
                  color: Colors.white,
                )),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage({String title, String subtitle}) {
    return Container(
      width: double.infinity,
      height: 250,
      margin: const EdgeInsets.only(top: 15, bottom: 35, left: 45, right: 45),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white.withOpacity(1),
          boxShadow: [
            BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(5.0, 5.0),
                color: color3.withOpacity(0.3))
          ]),
      child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 0.2,
                      color: Colors.black)),
              SizedBox(),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.2,
                    color: Colors.black),
              ),
              InputField(
                black: true,
                controller: _controller,
                hint: "e-mail / wallet",
                obscure: false,
                icon: Icons.account_balance_wallet,
              ),
              InputField(
                number: true,
                black: true,
                controller: _amountController,
                hint: "value in €",
                obscure: false,
                icon: Icons.euro_symbol,
              ),
              emailWallet != null &&
                      emailWallet != "" &&
                      amount != null &&
                      amount > 0.0
                  ? IconButton(
                      icon: Icon(Icons.check_circle,
                          size: 40, color: Colors.green),
                      onPressed: () async {
                        bool valid = false;
                        emailWallet = _controller.text;
                        if (_amountController.text != null) {
                          amount = double.parse(_amountController.text);
                        }
                        if (emailWallet != null && amount != null) {

                          if (amount < 5) {
                            Fluttertoast.showToast(
                                msg: "The withdraw amount has to be at least 5€",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: textColor,
                                fontSize: 15.0);
                          } else {

                          //Paypal
                          if (_currentIndex == 0) {
                            cost = (0.35 + amount * 0.025 + 0.25);
                            paymentMethod = "PayPal";
                            if (emailWallet.contains('@') && emailWallet.contains('.')) {
                              valid = true;
                            } else {
                              Fluttertoast.showToast(
                                  msg: "This is not a valid e-mail address",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: textColor,
                                  fontSize: 15.0);
                            }
                            //Bitcoin
                          } else if (_currentIndex == 1) {
                            cost = 2.00;
                            paymentMethod = "Bitcoin";
                            if (emailWallet.length == 34) {
                              valid = true;
                            } else {
                              Fluttertoast.showToast(
                                  msg: "This is not a valid Bitcoin wallet address",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: textColor,
                                  fontSize: 15.0);
                            }
                          }

                          valid ?

                          showDialog(
                              context: context,
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: new AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    backgroundColor:
                                        Colors.white.withOpacity(1),
                                    title: new Text("\nConfirm Withdraw",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)),
                                    content: new Text(
                                      "Method: " +
                                          paymentMethod +
                                          "\n\n" +
                                          "E-mail / wallet: " +
                                          emailWallet +
                                          "\n\n" +
                                          "Amount: " +
                                          amount.toString() +
                                          " €" +
                                          "\n" +
                                          "Cost for payment: " +
                                          cost.toStringAsFixed(2) +
                                          " €" +
                                          "\n" +
                                          "Withdrawal amount: " +
                                          (amount - cost).toStringAsFixed(2) +
                                          " €",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("cancel"),
                                            color: Colors.red,
                                            colorBrightness: Brightness.dark,
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5),
                                          RaisedButton(
                                              child: Text("confirm"),
                                              color: Colors.green,
                                              colorBrightness: Brightness.dark,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              onPressed: () {
                                                if (amount > widget.currentBalance) {
                                                  Fluttertoast.showToast(
                                                      msg: "The withdraw amount exceeds your current Balance",
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIos: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: textColor,
                                                      fontSize: 15.0);
                                                }
                                                else if (amount < cost) {
                                                  Fluttertoast.showToast(
                                                      msg: "The withdraw amount has to exceed the withdraw costs",
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIos: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: textColor,
                                                      fontSize: 15.0);
                                                } else {
                                                  _requestWithdraw();
                                                }
                                              }),
                                          SizedBox(width: 30),
                                        ],
                                      )
                                    ],
                                  ))) : SizedBox();
                        }}
                        ;
                      })
                  : IconButton(
                      icon: Icon(Icons.check_circle,
                          size: 40, color: Colors.grey),
                      onPressed: () {})
            ],
          )),
    );
  }
}
