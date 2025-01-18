import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Color(0xffffffff),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/HiringManagerTest.png"),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text("Jane Doe", textAlign:TextAlign.left, style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0
                )),
                Text("Yuzhang INC", style: TextStyle(fontSize: 24.0),),
                Text("Projects: project 1, project 2")
              ],
            )
          )
        ],
      ),
    );
  }
}