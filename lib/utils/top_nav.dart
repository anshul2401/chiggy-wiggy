import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Stack getTopNav(BuildContext context, String heading, Color color,
    Widget rightSideIcon, bool showBackButton) {
  return Stack(
    alignment: AlignmentDirectional.bottomEnd,
    children: [
      Container(
        padding: EdgeInsets.all(0),
        height: 95,
        width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.bottomRight,
        //     end: Alignment.topLeft,
        //     colors: [
        //       lightColor,
        //       darkColor,
        //     ],
        //   ),
        // ),
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                showBackButton
                    ? MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                        ),
                        padding: EdgeInsets.all(5),
                        shape: CircleBorder(),
                      )
                    : Container(
                        height: 18,
                        width: 18,
                      ),
                Text(
                  heading,
                  style: GoogleFonts.bevan(
                    textStyle: TextStyle(
                        // letterSpacing: 1.3,
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            rightSideIcon
          ],
        ),
      ),
      Container(
        height: 20,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
      ),
    ],
  );
}
