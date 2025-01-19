import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  _StudentFormPageState createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage>{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController techSkillsController = TextEditingController();

  List<String> tags = []; // Store tags dynamically
  final List<String> fallbackTags = [
    'Web Development',
    'IOS Development',
    'Machine Learning',
    'Data Analytics',
    'Mobile App Development',
    'E-commerce Platform',
    'Cloud Computing',
    'AI Development'
  ];
  bool isLoading = false;

  void addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag) && fallbackTags.contains(tag)) {
      setState(() {
        tags.add(tag);
      });
    }
  }

  void removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  Widget _buildTagsSection() {
    return Material(
      elevation: 2,
      shadowColor: Colors.deepPurpleAccent.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Rounded box styling
          border: Border.all(color: Colors.deepPurpleAccent), // Border color matches other fields
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: techSkillsController,
              decoration: InputDecoration(
                labelText: 'Development Tags',
                hintText: 'E.g., Web Development, iOS',
                labelStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none, // Removes additional underline
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.deepPurple),
                  onPressed: () {
                    addTag(techSkillsController.text.trim());
                  },
                ),
              ),
              onSubmitted: (value) {
                addTag(value.trim());
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  onDeleted: () {
                    removeTag(tag);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> insertStudentPortfolio({
    required String name,
    required String degree,
    required List<String> skills,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      // Retrieve the current user's ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user session found. Please log in.')),
        );
        return;
      }

      // Update the `users` table
      final response = await supabase
          .from('users')
          .update({
          'name': name,
          'degree': degree,
          'skills': skills,
          })
          .eq('id', userId);


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student portfolio updated successfully!')),
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student Portfolio'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white, // Set the entire background to white
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Section 2: Form Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, // Section background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Student Portfolio',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildFloatingTextField(
                      controller: nameController,
                      label: 'Your name',
                      hint: 'Provide your full name',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildFloatingTextField(
                      controller: degreeController,
                      label: 'Your Degree, Year and University.',
                      hint: 'E.g., Year 2 NUS Computer Science',
                    ),
                    const SizedBox(height: 16),
                    _buildTagsSection(),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          await insertStudentPortfolio(
                            name: nameController.text.trim(),
                            degree: degreeController.text.trim(),
                            skills: tags, // Pass the tags as skills
                          );

                          setState(() {
                            isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Material(
      elevation: 2,
      shadowColor: Colors.deepPurpleAccent.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Rounded box styling
          border: Border.all(color: Colors.deepPurpleAccent), // Purple border
        ),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none, // Removes default underline
            labelText: label,
            hintText: hint,
            labelStyle: const TextStyle(color: Colors.grey),
            hintStyle: const TextStyle(color: Colors.grey),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      ),
    );
  }

}
