import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

Future<Map<String, String>> fetchProjectDetails(String query) async {
  //const apiKey = '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'; // Replace with your actual OpenAI API key
  const apiKey = 'sk-9856cb0b078047c383d8fe09399aafc3';
  const url = "https://gyatword.zrok.jensenhshoots.com/api/chat/completions";
  //const url = 'https://api.openai.com/v1/chat/completions';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: json.encode({
      'model': 'llama3.2:latest',
      'messages': [
        {
          'role': 'system',
          'content': 'You are an assistant that generates project listings based on business requirements and problem statements for university student developers.'
        },
        {
          'role': 'user',
          'content': 'Generate a project listing with description, tech stack, and tags for the following query: $query',
        },
      ],
    }),
  );

  //print(response.body);
  //print(response.statusCode);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final completion = jsonResponse['choices'][0]['message']['content'];

    print(completion);

    final description = _extractBasicSection(completion, r'\*\*Description:\*\*\n([\s\S]*?)(?=\n\*\*|\n$)');
    final techStack = _extractBasicSection(completion, r'\*\*Tech Stack:\*\*\n([\s\S]*?)(?=\n\*\*|\n$)');
    final tags = _extractBasicSection(completion, r'\*\*Tags:\*\*\n([\s\S]*?)(?=\n\*\*|\n$)');
    // Debugging extracted sections
    print('Extracted Description: $description');
    print('Extracted Tech Stack: $techStack');
    print('Extracted Tags: $tags');

    return {
      'description': description ?? 'No description found.',
      'techStack': techStack ?? 'No tech stack found.',
      'tags': tags ?? 'No tags found.',
    };
  } else {
    print(response.body);
    throw Exception('Failed to load project details. Status code: ${response.body}');
  }
}

String? _extractBasicSection(String text, String pattern) {
  final regex = RegExp(pattern, multiLine: true, dotAll: true);
  final match = regex.firstMatch(text);
  return match?.group(1)?.trim();
}



class _FormPageState extends State<FormPage>{
  final TextEditingController searchController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController techStackController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project Listing'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white, // Set the entire background to white
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Section 1: Search Section
              Container(
                margin: const EdgeInsets.only(bottom: 40), // Spacing between sections
                padding: const EdgeInsets.all(16), // Padding inside the section
                decoration: BoxDecoration(
                  color: Colors.white, // Section background
                  borderRadius: BorderRadius.circular(16),

                ),
                child: Column(
                  children: [
                    Text(
                      'Enter your project description and let AI do the rest of the work for you',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Material(
                      elevation: 2,
                      shadowColor: Colors.deepPurpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Search (e.g., Business Problem)',
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: 'Enter a problem statement...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.deepPurpleAccent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });

                          final details = await fetchProjectDetails(searchController.text);
                          setState(() {
                            descriptionController.text = details['description']!;
                            techStackController.text = details['techStack']!;
                            tagsController.text = details['tags']!;
                            isLoading = false;
                          });

                        } catch (error) {
                          setState(() {
                            isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${error.toString()}')),
                          );

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.search),
                      label: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Search'),
                    ),
                  ],
                ),
              ),


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
                      'Project Listing Form We Will Help Fill for You',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Please edit the form before final submission',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildFloatingTextField(
                      controller: descriptionController,
                      label: 'Project Description',
                      hint: 'Provide a short paragraph describing the project',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildFloatingTextField(
                      controller: techStackController,
                      label: 'Tech Stack',
                      hint: 'E.g., Flutter, Node.js, AWS',
                    ),
                    const SizedBox(height: 16),
                    _buildFloatingTextField(
                      controller: tagsController,
                      label: 'Development Tags',
                      hint: 'E.g., Web Development, iOS, Machine Learning',
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Form Submitted')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
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
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
        ),
      ),
    );

}
}
