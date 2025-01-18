import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tinder_card.dart';


class TinderPageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TinderCard(),
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(50.0, 0.0, 15.0, 40.0),
        child: SizedBox(
          height: 80.0,
          child: Row(
            children: [
              FloatingActionButton.large(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child:  Icon(Icons.close, color: Colors.red),
                  onPressed: () => print("Pressed1")
              ),
              Spacer(),
              FloatingActionButton.large(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: Colors.purple),
                  onPressed: () => print("Pressed2")
              )
            ],
          ),
        ),
      ),
    );
  }
}