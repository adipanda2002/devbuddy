import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  final String userId;

  const StudentDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Student Home - User ID: $userId',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
