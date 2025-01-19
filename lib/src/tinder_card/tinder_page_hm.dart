import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:devbuddy/src/tinder_card/tinder_card_hm.dart';

class TinderPageView2 extends StatefulWidget {

  final String userId;

  const TinderPageView2({Key? key, required this.userId}) : super(key: key);

  @override
  State<TinderPageView2> createState() => _TinderPageViewState2();
}

class _TinderPageViewState2 extends State<TinderPageView2> with SingleTickerProviderStateMixin {
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
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
  try {
    final response = await supabase
        .from('users')
        .select('id, role, degree, university, skills, name')
        .eq('role', 'student')
        .order('created_at', ascending: false)
        .limit(10);

    if (response != null && response is List<dynamic>) {
      setState(() {
        stack = response.map((item) {
          return {
            "id": item["id"], 
            "degree": item["degree"] ?? "No degree",
            "university": item["university"] ?? "No university",
            "skills": item["skills"] != null
                ? List<String>.from(item["skills"])
                : [""],
            "name": item["name"] ?? "No name",
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
    print('Error fetching students: $error');
    setState(() {
      isLoading = false;
    });
  }
}



 void _swipeCard(bool isRightSwipe) {
  if (stack.isEmpty) return;

  final studentId = stack.last['id']; // Assuming `id` is the project UUID
  final hmId = widget.userId;

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
    _registerSwipe(hmId, studentId, isRightSwipe); // Register swipe
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
          child: Text('No more students available'),
        ),
      );
    }

    return Scaffold(
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: stack.reversed.map((student) {
            int index = stack.indexOf(student);
            TinderCard2 card = TinderCard2(
              key: ValueKey(student),
              role: student["role"] ?? 'No role',
              degree: student["degree"] ?? 'No degree',
              university: student["university"] ?? 'No university',
              skills: student["skills"] ?? 'No skills',
              name: student["name"] ?? 'No name',
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

  Future<void> _registerSwipe(String hmId, String studentId, bool isRightSwipe) async {
  if (!isRightSwipe) return; // Only register right swipes
  try {
    final response = await supabase.from('swipes').insert({
      'swiper_id': hmId,
      'swipee_id': studentId,
    });
  } catch (error) {
    print("Error registering swipe: $error");
  }
}

}