import 'package:chiggy_wiggy/helper.dart';
import 'package:flutter/material.dart';

class Checkpoints extends StatelessWidget {
  const Checkpoints(
      {Key key, this.checkTill, this.checkpoints, this.checkpointFillColor})
      : super(key: key);
  final int checkTill;
  final List<String> checkpoints;
  final Color checkpointFillColor;
  final double circleDia = 32;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, s) {
      final double cWidth = ((s.maxWidth - (32.0 * (checkpoints.length + 1))) /
          (checkpoints.length - 1));
      return Container(
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: checkpoints.map((e) {
                  int index = checkpoints.indexOf(e);
                  return Container(
                    height: circleDia,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: circleDia,
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index <= checkTill
                                      ? checkpointFillColor
                                      : checkpointFillColor.withOpacity(0.2),
                                ),
                              ),
                              index != (checkpoints.length - 1)
                                  ? Container(
                                      alignment: Alignment.center,
                                      color: index < checkTill
                                          ? checkpointFillColor
                                          : checkpointFillColor
                                              .withOpacity(0.2),
                                      height: 4,
                                      width: cWidth,
                                    )
                                  : Container()
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: checkpoints.map((e) {
                  return getBoldText(e, 14, Colors.black);
                }).toList(),
              ),
            )
          ],
        ),
      );
    });
  }
}
