import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget{
  const TinderCard({
    super.key,
    this.description = "",
    this.tech_stack = "",
    this.development_tags = "",
  });

  //final Image image;
  final String description;
  final String tech_stack;
  final String development_tags;


  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      color: Color(0xffffffff),
      child: SizedBox(
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
                    Text(description, textAlign:TextAlign.left, style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0
                    )),
                    Text(tech_stack, style: TextStyle(fontSize: 24.0),),
                    Text(development_tags, style: TextStyle(fontSize: 24.0),),
                  ]
              ),
            )
        ])
      )
    );
  }
}