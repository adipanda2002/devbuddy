import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TinderCard extends StatelessWidget{
  const TinderCard({
    super.key,
    this.name = "NULL",
    this.company = "COMPANY",
    this.projects = "PROJECTS",
  });

  //final Image image;
  final String name;
  final String company;
  final String projects;


  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      color: Color(0xffffffff),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset("assets/images/HiringManagerTest.png", fit: BoxFit.cover,),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                spacing: 20.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jane Doe", textAlign:TextAlign.left, style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0
                    )),
                    Text("Yuzhang INC", style: TextStyle(fontSize: 24.0),),
                    Text("Projects: project 1, project 2")
                  ]
              ),
            )
        ])
      )
    );
  }
}