import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {

  final bricksX;
  final bricksY;
  final bricksHeight;
  final bricksWidth;
  final bool isBrickHit;

  MyBrick({this.bricksX, this.bricksY, this.bricksHeight, this.bricksWidth, required this.isBrickHit});

  @override
  Widget build(BuildContext context) {
    return isBrickHit ? Container() : Container(
        alignment: Alignment((2* bricksX + bricksWidth)/(2 - bricksWidth), bricksY),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: MediaQuery.of(context).size.height * bricksHeight / 2,
            width: MediaQuery.of(context).size.width * bricksWidth / 2,
            color: Colors.deepPurple,
          ),
        ));
  }
}
