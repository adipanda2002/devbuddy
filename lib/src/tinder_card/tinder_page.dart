
import 'package:devbuddy/src/tinder_card/tinder_card.dart';
import 'package:flutter/material.dart';



class TinderPageView extends StatelessWidget {
  const TinderPageView({super.key});



  @override
  Widget build(BuildContext context) {
    List<TinderCard> stack = getCardStack();
    return Scaffold(
      body: Container(
        child: Stack(
          children: stack,
        )
      ),
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

  List<TinderCard> getCardStack() {
    List<TinderCard> stack = [];

    TinderCard janedoe = new TinderCard(
      name:"Janice Manice",
      company: "YASH INDUSTRIES",
      projects: "MY PROJECT",
    );

    TinderCard janicemanice = new TinderCard(
      name:"Janice Manice",
      company: "YASH INDUSTRIES",
      projects: "MY PROJECT",
    );

    TinderCard bobbobby = new TinderCard(
      name:"Bob Bobby",
      company: "Adi Tech",
      projects: "Bobs PROJECTs",
    );

    stack.add(janedoe);
    stack.add(janicemanice);
    stack.add(bobbobby);

    return stack;
  }
}