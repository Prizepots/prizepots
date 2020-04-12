
import 'package:prizepots/screens/QuickLoginView.dart';
import 'package:prizepots/screens/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prizepots/main.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:prizepots/screens/TutorialSwiper.dart';

class TutorialScreen extends StatefulWidget {
  static final String path = "lib/src/pages/onboarding/intro4.dart";
  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  final SwiperController  _swiperController = SwiperController();
  final int _pageCount = 5;
  int _currentIndex = 0;
  final List<String> images = [
    "assets/tut1.png",
    "assets/tut2.png",
    "assets/tut3.png",
    "assets/tut4.png",
    "assets/tut5.png",
  ];
  final List<String> titles = [
    "1. Choose your favorite project",
    "2. Generate Points",
    "3. Earn money daily",
    "4. Get your friends involved",
    "5. Start helping",
  ];
  final List<String> subtitles = [
    "First and foremost this app was created to support charity organisations. So it is important to choose your favorite organisation. The organisation will receive a part of your generated earnings.",
    "You'll need to generate points to help earning rewards. Once you reached enough points, you are eligible to participate at the Prizepot allocation.",
    "You can receive guaranteed earnings daily. There are 4 different prizepot types with different constraints and payments. Generally speaking: The longer you are involved the more earnings you'll receive.",
    "Invite your friends to earn even more. You'll actually earn a share from your friends rewards and their networks too. The bigger your network the more you can earn!",
    "Let's get started and thanks for helping!",
  ];

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        child: new LeaveAppDialog());
  }


  @override
  Widget build(BuildContext context){
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
      body: Stack(
        children: <Widget>[
          Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Colors.black),
          Center(child: Container(height: 180, child: Image.asset("assets/logowhitelong.png"))),
          Container(color: Colors.transparent, child:
          Column(
            children: <Widget>[
              SizedBox(height: 25),
              Expanded(child: Swiper(
                index: _currentIndex,
                controller: _swiperController,
                itemCount: _pageCount,
                onIndexChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                loop: false,
                itemBuilder: (context, index){
                  return _buildPage(title: titles[index], subtitle: subtitles[index], images: images[index]);
                },
                pagination: SwiperPagination(
                    builder: TutorialSwiper(
                        activeSize: Size(10.0, 20.0),
                        size: Size(10.0, 15.0),
                        color: Colors.white
                    )
                ),
              )),
              _buildButtons(),
            ],
          ),)
        ],
      ),
    ));
  }

  Widget _buildButtons(){
    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            textColor: Colors.white.withOpacity(1),
            child: Text("Skip"),
            onPressed: (){
              Navigator.push(context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => QuickLoginView(),
                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 500),
                  ));
//              Navigator.push(context, CupertinoPageRoute(builder: (context) => QuickLoginView()));
            },
          ),
          IconButton(
            icon: _currentIndex < _pageCount - 1 ? Icon(Icons.arrow_forward, size: 30, color: Colors.white) : Icon(Icons.check, size: 30, color: color3),
            onPressed: () async {
              if(_currentIndex < _pageCount - 1)
                _swiperController.next();
              else {
                Navigator.push(context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => QuickLoginView(),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 500),
                ));
//                Navigator.push(context, CupertinoPageRoute(builder: (context) => QuickLoginView()));
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPage({String title, String subtitle, String images}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(45.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.black,
          boxShadow: [
            BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(5.0,5.0),
                color: color3.withOpacity(0.0)
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(title, textAlign: TextAlign.center, style: TextStyle(
//        fontFamily: 'Beauty',
        fontSize: 35,
        letterSpacing: 0.2,
        color: Colors.white)),
          SizedBox(),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(
//              fontFamily: 'Beauty',
              fontSize: 20,
              letterSpacing: 0.2,
              color: Colors.white
          ),),
          Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
          image: AssetImage(images),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.0), BlendMode.multiply)
          ),)),
        ],
      ),
    );
  }
}