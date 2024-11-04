import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DiceShower(),
    );
  }
}
class DiceShower extends StatefulWidget {
  const DiceShower({super.key});


  @override
  State<DiceShower> createState() => _DiceShowerState();
}
class _DiceShowerState extends State<DiceShower> {


var _dice ="die1.jpg";

void rollDice(){
  final value =Random().nextInt(6)+1;
  setState(() {
    _dice = "die" + value.toString()+".jpg";

  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dice randomizer"),
      ),
      body: Column(
        children: [
         IconButton(
             onPressed: rollDice,
             icon: Image.asset("assets/$_dice") )
        ],
      ),
    );
  }
}
