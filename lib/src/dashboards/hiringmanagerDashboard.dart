import 'package:flutter/material.dart';

class HiringManagerDashboard extends StatelessWidget {
  final String userId;

  const HiringManagerDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hiring Manager Home - User ID: $userId',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}