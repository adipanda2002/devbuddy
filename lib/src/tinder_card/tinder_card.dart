import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("Sample"),
            )
          ],
        )
      )
    );
  }
}