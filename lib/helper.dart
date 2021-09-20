import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';

Text getBoldText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    )),
  );
}

Text getNormalText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
      fontSize: fontSize,
      color: color,
    )),
  );
}

String getWeight(String weight) {
  return (double.parse(weight) * 1000).toString() + ' gm';
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

Widget getPlusMinus(int quantity, Function addSub) {
  return Row(
    children: [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.remove),
      ),
      Text(
        quantity.toString(),
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.add),
      ),
    ],
  );
}

Color getThemeColor() {
  // return Color.fromRGBO(244, 91, 85, 1);
  return Color.fromRGBO(203, 32, 45, 1);
}

Color getThemeWhite() {
  return Color.fromRGBO(244, 244, 242, 1);
}
