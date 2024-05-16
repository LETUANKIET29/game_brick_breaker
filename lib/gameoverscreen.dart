import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {

  final bool isGameOver;
  final function; 

  GameOverScreen({required this.isGameOver, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameOver ? Stack(
      children: [
        Container(
        alignment: Alignment(0, -0.3),
        child: Text(
          "GAME OVER",
          style: TextStyle(color: Colors.deepPurple),
        )),
        Container(
        alignment: Alignment(0, 0),
        child: GestureDetector(
          onTap: function,
          child: ClipRRect(borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.deepPurple,
            child: Text(
              "PLAY AGAIN",
              style: TextStyle(color: Colors.white),
            ),
          ),
          )        
        ))
      ],
    ) : Container();
  }
}