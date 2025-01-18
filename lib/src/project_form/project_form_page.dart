import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController techStackController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search (e.g., Business Problem)',
                  hintText: 'Enter a problem statement...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Trigger AI wrapper integration here
                  print('Search input: $value');
                },
              ),
              const SizedBox(height: 24),

              // Project Description
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Project Description',
                  hintText: 'Provide a short paragraph describing the project',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Tech Stack
              TextField(
                controller: techStackController,
                decoration: InputDecoration(
                  labelText: 'Tech Stack',
                  hintText: 'E.g., Flutter, Node.js, AWS',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Development Tags
              TextField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Development Tags',
                  hintText: 'E.g., Web Development, iOS, Machine Learning',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  print('Description: ${descriptionController.text}');
                  print('Tech Stack: ${techStackController.text}');
                  print('Tags: ${tagsController.text}');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Form Submitted')),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
