import 'package:prizepots/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectButton extends StatefulWidget {
  ProjectButton(
      {Key key,
      this.text,
      this.color,
      this.path,
      this.width,
      this.height,
      this.number,
      this.url,
      this.pressed,
      this.hexcolor})
      : super(key: key);
  String text;
  Color color;
  String path;
  double width;
  double height;
  int number;
  String url;
  bool pressed;
  String hexcolor;

  @override
  _ProjectButtonState createState() => _ProjectButtonState();
}

class _ProjectButtonState extends State<ProjectButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Center(
          child: Padding(
        padding: EdgeInsets.only(top: 5),
        child:
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.only(
//                  topRight: Radius.circular(40),
//                  bottomRight: Radius.circular(40),
//                  topLeft: Radius.circular(40),
//                  bottomLeft: Radius.circular(40))),
//          elevation: 5,
//          child: Padding(
//            padding: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
//            widget.path != null ?
            Container(

    child: FlatButton(
      shape: RoundedRectangleBorder(
    borderRadius:
    BorderRadius.circular(50)),
    color: Colors.black.withOpacity(0.5),
    onPressed: () {
    if (widget.url != null) {
    _launchURL();
    }},
    child: Center(child: Text(widget.path, style: TextStyle(
                  fontFamily: 'ColaborateThin',
                  fontSize: 20,
                  fontWeight: widget.pressed ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: 0.3,
                  color: widget.pressed ? color3 : Colors.white)))),
              decoration: new BoxDecoration(
                color: Colors.transparent,
//                image: DecorationImage(
//                    image: AssetImage(widget.path), fit: BoxFit.cover),
                border: widget.pressed
                    ? Border.all(
                        width: 4, color: color3.withOpacity(1.0))
                    : Border.all(
                        width: 0, color: Colors.white.withOpacity(1.0)),
                borderRadius: BorderRadius.all(
                    Radius.circular(40))
              ),
              height: widget.height - 50,
              width: widget.width,

//        : Container(
//              child: Text("Support all",
//                  style: TextStyle(
//                      fontFamily: 'Beauty',
//                      fontSize: 30,
//                      letterSpacing: 0.3,
//                      color: Colors.white.withOpacity(1))),
//              decoration: new BoxDecoration(
//                border: widget.pressed
//                    ? Border.all(
//                    width: 0, color: Colors.black.withOpacity(1.0))
//                    : Border.all(
//                    width: 8, color: Colors.black.withOpacity(1.0)),
//                borderRadius: BorderRadius.all(
//                    Radius.circular(40))
//              ),
//              height: widget.height - 10,
//              width: widget.width ,
//            ),
          ),
        ),
      )
    ]);
//      Container(child: Image.asset("assets/earth.jpg")),
  }

  void _launchURL() async {
    if (await canLaunch(widget.url)) {
      await launch(widget.url);
    } else {
      throw 'Could not launch $widget.url';
    }
  }
}
