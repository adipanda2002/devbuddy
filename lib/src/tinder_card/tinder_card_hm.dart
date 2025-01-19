import 'package:flutter/material.dart';

class TinderCard2 extends StatelessWidget {
  const TinderCard2({
    super.key,
    this.role = "",
    this.degree = "",
    this.university = "",
    this.skills = const [],
    this.name = "",
  });

  final String role;
  final String degree;
  final String university;
  final List<String> skills;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      color: const Color(0xff1e1e1e), // Dark background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // name
            Row(
              children: [
                const Icon(Icons.person, color: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Role
            Row(
              children: [
                const Icon(Icons.assignment_ind, color: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Degree
            Row(
              children: [
                const Icon(Icons.school, color: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                Text(
                  degree,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // University
            Row(
              children: [
                const Icon(Icons.location_city, color: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                Text(
                  university,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Skill
            Text(
                  'Skills:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.deepPurpleAccent,
                      ),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: skills.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 12.0, color: Colors.white),
                      ),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
