import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:devbuddy/src/tinder_card/tinder_card.dart';

class TinderPageView extends StatefulWidget {
  const TinderPageView({super.key});

  @override
  State<TinderPageView> createState() => _TinderPageViewState();
}

class _TinderPageViewState extends State<TinderPageView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  List<Map<String, dynamic>> stack = [];
  bool isLoading = true;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400)
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.easeOut)
    );
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
  try {
    // Fetch data from the 'projects' table
    final response = await supabase
        .from('projects') // Specify the table name
        .select('description, tech_stack, development_tags') // Specify the columns
        .order('created_at', ascending: false) // Sort by creation time
        .limit(10); // Optional: Limit the number of rows fetched

    // Debug the response
    print('Supabase response: $response');

    // Check if the response contains data
    if (response != null && response is List<dynamic>) {
      setState(() {
        stack = response.map((item) {
          return {
            "description": item["description"] ?? "No description",
            "tech_stack": item["tech_stack"] ?? "No tech stack",
            "development_tags": item["development_tags"] ?? "No tags",
          };
        }).toList();
        isLoading = false;
      });
    } else {
      print("Response is null or empty.");
      setState(() {
        isLoading = false;
      });
    }
  } catch (error) {
    print('Error fetching projects: $error');
    setState(() {
      isLoading = false;
    });
  }
}




  void _swipeCard(bool isRightSwipe) {
    if (stack.isEmpty) return;
    
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
        stack.removeLast();
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
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (stack.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No more projects available'),
        ),
      );
    }

    return Scaffold(
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: stack.reversed.map((project) {
            int index = stack.indexOf(project);
            TinderCard card = TinderCard(
              key: ValueKey(project),
              description: project["description"] ?? 'No description',
              tech_stack: project["tech_stack"] ?? 'No tech stack',
              development_tags: project["development_tags"] ?? 'No tags',
            );

            if (index == stack.length - 1) {
              return SlideTransition(
                position: _animation,
                child: card,
              );
            }

            return card;
          }).toList().reversed.toList(),
        ),
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
                onPressed: () {
                  print("Swiped Left");
                  _swipeCard(false);
                }
              ),
              Spacer(),
              FloatingActionButton.large(
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
                child: Icon(Icons.favorite, color: Colors.purple),
                onPressed: () {
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
}