import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:devbuddy/src/tinder_card/tinder_card.dart';

class TinderPageView extends StatefulWidget {

  final String userId;

  const TinderPageView({Key? key, required this.userId}) : super(key: key);

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
    final response = await supabase
        .from('projects')
        .select('id, description, tech_stack, development_tags, company, website, industry')
        .order('created_at', ascending: false)
        .limit(10);

    if (response != null && response is List<dynamic>) {
      setState(() {
        stack = response.map((item) {
          return {
            "id": item["id"], // Include project ID
            "description": item["description"] ?? "No description",
            "tech_stack": item["tech_stack"] ?? "No tech stack",
            "development_tags": item["development_tags"] != null
                ? List<String>.from(item["development_tags"])
                : [""],
            "company": item["company"] ?? "No company",
            "website": item["website"] ?? "No website",
            "industry": item["industry"] ?? "No industry",
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

  final projectId = stack.last['id']; // Assuming `id` is the project UUID
  final swiperId = widget.userId;

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

  _animationController.forward(from: 0.0).then((_) {
    _registerSwipe(swiperId, projectId, isRightSwipe); // Register swipe
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
              company: project["company"] ?? "No company",
              website: project["website"] ?? "No website",
              industry: project["industry"] ?? "No industry",
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

  Future<void> _registerSwipe(String swiperId, String projectId, bool isRightSwipe) async {
  if (!isRightSwipe) return; // Only register right swipes
  try {
    final response = await supabase.from('swipes').insert({
      'swiper_id': swiperId,
      'project_id': projectId,
    });
  } catch (error) {
    print("Error registering swipe: $error");
  }
}

}