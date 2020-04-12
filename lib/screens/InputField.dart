import 'package:flutter/material.dart';
import 'package:prizepots/main.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final TextEditingController controller;
  bool black;
  bool number;

  InputField({this.hint, this.obscure, this.icon, this.controller, this.black, this.number});

  @override
  Widget build(BuildContext context) {
    return (new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: color3,
          ),
        ),
      ),
      child: TextFormField(
        obscureText: obscure,
        controller: controller,
        keyboardType: number != null ? TextInputType.number : null ,
        style: TextStyle(

          color: black != null ? Colors.black : Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
        decoration: new InputDecoration(
          icon: new Icon(
            icon,
            color: color3,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: color3, fontSize: 18.0),
          contentPadding: const EdgeInsets.only(
              top: 20.0, right: 5.0, bottom: 20.0, left: 5.0),
        ),
      ),
    ));
  }
}