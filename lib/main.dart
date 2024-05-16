import 'package:flutter/material.dart';
import 'package:game_brick_breaker/homepage.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
       home: HomePage() ,
    );
  }
}