import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

Future<Map<String, String>> fetchProjectDetails(String query) async {

  final apiKey = dotenv.env['API_KEY'];
  final baseUrl = dotenv.env['BASE_URL'];

  final List<String> fallbackTags = [
    'Web Development',
    'IOS Development',
    'Data Analytics',
    'Mobile App Development',
    'E-commerce Platform',
    'Cloud Computing',
    'AI Development',
    'Machine Learning'
  ];

  final response = await http.post(
    Uri.parse(baseUrl!),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: json.encode({
      'model': 'llama3.2:latest',
      'messages': [
        {
          'role': 'system',
          'content': '''
You are an assistant that generates project listings for university developers. Always follow this strict response format:

**Project Title:** [Title of the project]

**Description:** [A detailed description of the project]

**Tech Stack:** 
- [Backend: Specify technologies]
- [Frontend: Specify technologies]
- [Database: Specify technologies]
- [APIs/Integration: Specify APIs or services]

**Tags:** [Comma-separated tags selected ONLY from the following list: 
Web Development, IOS Development, Data Analytics, Mobile App Development, E-commerce Platform, Cloud Computing, AI Development, Machine Learning]

Your response must strictly adhere to this format. Do not add extra sections like "Additional Features" or "Evaluation Criteria."
'''
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

    final description = _extractBasicSection(
        completion,
        r'\*\*Description:\*\*([\s\S]*?)(?=\n\*\*|\n$)'
    );

    final techStack = _extractBasicSection(
        completion,
        r'\*\*Tech Stack:\*\*([\s\S]*?)(?=\n\*\*|\n$)'
    );

    final tags = _extractBasicSection(
      completion,
      r'\*\*Tags:\*\*([\s\S]*?)(?=\n\*\*|$)', // Matches until the next section or end of string
    );

    // Filter GPT output tags with fallback tags
    final tagsArray = tags
        ?.split(',')
        .map((tag) => tag.trim())
        .where((tag) => fallbackTags.contains(tag))
        .toList() ??
        [];

    // Debugging extracted sections
    print('Extracted Description: $description');
    print('Extracted Tech Stack: $techStack');
    print('Extracted Tags: $tagsArray');

    return {
      'description': description ?? 'No description found.',
      'techStack': techStack ?? 'No tech stack found.',
      'tags':  tagsArray.join(', '),
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
    String tagInput = '';
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
              onChanged: (value) {
                tagInput = value.trim();
              },
              onSubmitted: (value) {
                addTag(value.trim());
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Development Tags',
                hintText: 'E.g., Web Development, iOS',
                labelStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none, // Removes additional underline
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.deepPurple),
                  onPressed: () {
                    addTag(tagInput);
                  },
                ),
              ),
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
                            tags = details['tags']!
                                .split(',')
                                .map((tag) => tag.trim())
                                .where((tag) => fallbackTags.contains(tag))
                                .toList();
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
                    _buildTagsSection(),
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
