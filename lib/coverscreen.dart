import 'package:flutter/material.dart';

// stateless widget
class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;

  CoverScreen({required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
          alignment: Alignment(0, -0.5),
            child: Text(
            "BRICK BREAKER",
            style: TextStyle(fontSize: 20, color: Colors.deepPurple[200]),
          ))
        : Stack(
            children: [
              Container(
                  alignment: Alignment(0, -0.5),
                  child: Text(
                    "BRICK BREAKER",
                    style: TextStyle(fontSize: 20, color: Colors.deepPurple[200]),
                  )),
              Container(
                  alignment: Alignment(0, -0.1),
                  child: Text(
                    "Tap to play",
                    style: TextStyle(fontSize: 20, color: Colors.deepPurple[400]),
                  ))
            ],
          );
  }
}
