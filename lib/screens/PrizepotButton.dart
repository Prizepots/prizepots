import 'package:prizepots/main.dart';
import 'package:prizepots/screens/PrizepotDetailScreen.dart';
import 'package:flutter/material.dart';

class PrizepotButton extends StatefulWidget {
  PrizepotButton(
      {Key key,
      this.text,
      this.textCapital,
      this.color,
      this.path,
      this.width,
      this.height,
      this.number,
      this.width2,
        this.opacity,
        this.dollar,
      this.eligibleText})
      : super(key: key);
  String text;
  String dollar;
  String textCapital;
  Color color;
  String path;
  double width;
  double width2;
  double height;
  int number;
  double opacity;
  String eligibleText;

  @override
  _PrizepotButtonState createState() => _PrizepotButtonState();
}

class _PrizepotButtonState extends State<PrizepotButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
    Padding(padding: EdgeInsets.only(left:5,right: 5, bottom: 5, top: 5),child: Container(decoration: new BoxDecoration(color:
    Colors.white
        , border: Border.all(color: Colors.black.withOpacity(1.0)),
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(40),
    bottomRight: Radius.circular(40),
    topLeft: Radius.circular(40),
    bottomLeft: Radius.circular(40))), child:
    Opacity (opacity: widget.opacity,child: Container(child: Container(
    decoration: new BoxDecoration(
        image: DecorationImage(image: AssetImage(widget.path), fit: BoxFit.cover),
    border: Border.all(color: Colors.black.withOpacity(0.0)),
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(40),
    bottomRight: Radius.circular(40),
    topLeft: Radius.circular(40),
    bottomLeft: Radius.circular(40),
    ))))))),
          Container(  height: widget.height,
    width: widget.width,
    decoration: new BoxDecoration(

//                              color: HexColor('bad6e5').withOpacity(0.9),
    color: Colors.black.withOpacity(0),
    border: Border.all(color: Colors.black.withOpacity(0.0)),
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(40),
    bottomRight: Radius.circular(40),
    topLeft: Radius.circular(40),
    bottomLeft: Radius.circular(40))), child:
      Container(


          child: FlatButton(
              color: Colors.transparent,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => PrizepotDetailScreen(
                        prizepot: widget.text,
                        prizepotCapital: widget.textCapital,
                        eligibleText: widget.eligibleText),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 400),
                  ),
                );
              },
              child: Row(children: <Widget>[
//                  Expanded(
//                    child: SizedBox(height: 1),
//                  ),
//                  Center(child: SizedBox(height: widget.height / 3,)),
                Center(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            padding: EdgeInsets.all(0),
                            decoration: new BoxDecoration(
//                              color: HexColor('bad6e5').withOpacity(0.9),
//                              color: Colors.white.withOpacity(0.25),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.0)),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                    topLeft: Radius.circular(40),
                                    bottomLeft: Radius.circular(40)),
                                boxShadow: [
                                  BoxShadow(
                                    color: color3.withOpacity(0.0),
                                    blurRadius: 20.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(
                                      5.0, // horizontal, move right 10
                                      0.0, // vertical, move down 10
                                    ),
                                  )
                                ]),
                            height: widget.height,
                            width: widget.width - 44,
                            alignment: Alignment.center,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 0),
                                    child: Center(
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[

                                          SizedBox(),
                                          Text(widget.text + "\nPot", textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'ColaborateThin',
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                            color: Colors.black
//                                            color: HexColor("#186955").withOpacity(1)
                                                )),
//                                        Text("Pot",
//                                            style: TextStyle(
//                                                fontFamily: 'ColaborateThin',
//                                                fontSize: 30,
//                                                letterSpacing: 0.3,
//                                                color: Colors.white
//                                                    .withOpacity(1))),
                                        Text(widget.dollar,
                                            style: TextStyle(
                                                fontFamily: 'ColaborateThin',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 55,
                                                letterSpacing: 0.3,
//                                                color: Colors.black))
                                                color: HexColor("#186955").withOpacity(1)))

    ],)
                                       )))))),
              ]))))
    ]);

//        child: Padding(padding: EdgeInsets.only(top: 0),
//          child:
////            child: Padding(padding: EdgeInsets.only(top:0, bottom: 0, right: 0, left: 0),
//            Opacity (opacity: 1, child: Container(
//              decoration: new BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage(widget.path), fit: BoxFit.cover),
//                border: Border.all(color: Colors.white.withOpacity(1)),
//                borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40), topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
//              ),
////              child: Padding(padding: EdgeInsets.only(bottom: 0),
//                child:
//                RaisedButton(
//
//                  color: color3.withOpacity(1.0),
//                  onPressed: () {
//                    Navigator.push(
//                      context,
//                      PageRouteBuilder(
//                        pageBuilder: (c, a1, a2) => PrizepotDetailScreen(prizepot: widget.text, prizepotCapital: widget.textCapital, eligibleText: widget.eligibleText),
//                        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
//                        transitionDuration: Duration(milliseconds: 400),
//                      ),
//                    );
//
////              Navigator.push(
////                  context,
////                  ScaleRoute(page: PrizepotDetailScreen(Prizepot: widget.text, PrizepotCapital: widget.textCapital, eligibleText: widget.eligibleText,
//////                          color: Colors.white,
//////                          controller: new PageController(initialPage: widget.number))
////                  )));
//                  },
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40), topLeft: Radius.circular(40), bottomLeft: Radius.circular(40))),
//                  elevation: 5,
//                  child: Row(
//                children: <Widget>[
////                  Expanded(
////                    child: SizedBox(height: 1),
////                  ),
////                  Center(child: SizedBox(height: widget.height / 3,)),
//                  Center(
//                      child: Align(alignment: Alignment.center,child: Container(
//                          padding: EdgeInsets.all(0),
//                          decoration: new BoxDecoration(
////                              color: HexColor('bad6e5').withOpacity(0.9),
//                              color: Colors.white.withOpacity(0.25),
//                              border: Border.all(
//                                  color: Colors.white.withOpacity(1.0)),
//                              borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40),topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
//                              boxShadow: [
//                                BoxShadow(
//                                  color: color3.withOpacity(0.0),
//                                  blurRadius: 20.0,
//                                  spreadRadius: 0.0,
//                                  offset: Offset(
//                                    5.0, // horizontal, move right 10
//                                    0.0, // vertical, move down 10
//                                  ),
//                                )
//                              ]
//                          ),
//                          height: widget.height,
//                          width: widget.width - 34 ,
//                          alignment: Alignment.center,
//                          child: Align(alignment: Alignment.bottomCenter,
//                              child: Padding(padding: EdgeInsets.only(bottom:0), child: Center(
//                              child: Text(widget.text,
//                                  style: TextStyle(
//                                      fontFamily: 'Beauty',
//                                      fontSize: 70,
//                                      letterSpacing: 0.3,
//                                      color: Colors.black.withOpacity(1))))))))),
//
//                  Expanded(
//                    child: SizedBox(height: 1),
//                  ),
//                ],
//
//            ),
//          ),
//
//      ),
//      )))]);
//      Container(child: Image.asset("assets/earth.jpg")),
  }
}
