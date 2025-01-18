import 'package:devbuddy/src/tinder_card/tinder_card.dart';
import 'package:flutter/material.dart';
import '/src/services/userQueries.dart';


class TinderPageView extends StatefulWidget {
  const TinderPageView({super.key});

  @override
  State<TinderPageView> createState() => _TinderPageViewState();
}

class _TinderPageViewState extends State<TinderPageView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Future<List<Map<String, dynamic>>> stack;

  @override
  void initState() {
    super.initState();
    stack = getCardStack();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400)
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOut)
    );
  }

  void _swipeCard(bool isRightSwipe) {
    // If right swipe, card ends up 1.5 to the right
    // If left swipe, card ends up 1.5 to the left
    final endOffset = Offset(isRightSwipe ? 1.5 : -1.5, 0.0);
    setState(() {
      _animation = Tween<Offset>(
        begin: Offset.zero,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));
    });

    _animationController.forward(from: 0.0).then((_){
      setState(() {
        stack.then((stack) {
          stack.removeLast();
        });
      });
      _animationController.reset();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: stack,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }
          final stack = snapshot.data!;
          return Container(
              child: Stack(
                  clipBehavior: Clip.none,
                  children: stack.reversed.map((map) {
                    int index = stack.indexOf(map);
                    TinderCard card = TinderCard(
                      key: ValueKey(map),
                      name: map["name"] ?? "Unknown name",
                      company: map["company"],
                      industry: map["industry"],
                      projects: map["projects"] ?? "Unknown projects",
                    );

                    if (index == stack.length - 1) {
                      return SlideTransition(
                        position: _animation,
                        child: card,
                      );
                    }

                    return card;
                  }
                  ).toList().reversed.toList()
              )
          );

        },
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
                  child: Icon(Icons.close, color: Colors.red),
                  onPressed: (){
                    print("Swiped Left");
                    _swipeCard(false);
                  }
              ),
              Spacer(),
              FloatingActionButton.large(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: Colors.purple),
                  onPressed: (){
                    print("Swiped right");
                    _swipeCard(true);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String,dynamic>>> getCardStack() async {
    
    // Map<String, dynamic> janedoe = {
    //   "name": "Jane Doe",
    //   "company": "YUZHANG INC",
    //   "projects": "MY PROJECT",
    // };
    //
    // Map<String, dynamic> janicemanice = {
    //   "name": "Janice Manice",
    //   "company": "YASH INDUSTRIES",
    //   "projects": "MY PROJECT",
    // };
    //
    // Map<String, dynamic> bobbobby = {
    //   "name": "Bob Bobby",
    //   "company": "Bob Bus",
    //   "projects": "Bobs PROJECTs",
    // };
    //
    // Map<String, dynamic> adipanda = {
    //   "name": "adipanda",
    //   "company": "Adi Tech",
    //   "projects": "ADIS PROJECTs",
    // };
    //
    // stack.add(janedoe);
    // stack.add(janicemanice);
    // stack.add(bobbobby);
    // stack.add(adipanda);
    return await getHiringManagers();
  }
}