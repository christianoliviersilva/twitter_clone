import 'package:fireflutter/Constants/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;

  const RoundedButton({Key key, this.btnText, this.onBtnPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: KTweeterColor,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: onBtnPressed,
        minWidth: 310,
        height: 55,
        child: Text(
          btnText,
          style: TextStyle(
            color: Colors.white, fontSize: 20
          ),
        ),
      ),
    );
  }
}
