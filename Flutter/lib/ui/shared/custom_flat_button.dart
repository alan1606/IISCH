import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {

  final String text;
  final Color color;
  final Function onPressed;

  const CustomFlatButton({
    Key? key, 
    required this.text,
    required this.onPressed,
    this.color = Colors.pink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          // primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        onPressed: () => onPressed(),
        child: Container(
          alignment: AlignmentDirectional.center,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))
          )
        )
      ),
    );
  }
}