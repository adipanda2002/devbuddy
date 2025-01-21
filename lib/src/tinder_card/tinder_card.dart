import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({
    super.key,
    this.description = "",
    this.tech_stack = "",
    this.development_tags = const [],
    this.company = "",
    this.website = "",
    this.industry = "",
  });

  final String description;
  final String tech_stack;
  final List<String> development_tags;
  final String company;
  final String website;
  final String industry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      color: const Color(0xff1e1e1e), // Dark background color
      child: ListView(
        padding: EdgeInsets.zero, // Remove extra padding
        children: [
          // Image section with rounded corners
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Image.network(
              'https://img.logo.dev/$company.com?token=pk_M4WpImW8QLCAndVVgL-2ug&retina=true',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 350.0, // Larger image height
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white, // White text
                      ),
                ),
                const SizedBox(height: 10),

                // Tech Stack
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tech Stack:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.deepPurpleAccent,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tech_stack,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.0,
                              color: Colors.white70, // White text with some transparency
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Development Tags
                Text(
                  'Development Tags:',
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
                  children: development_tags.map((tag) {
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

                // Divider
                Divider(color: Colors.grey[600]),

                // Company Details
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.business, size: 16.0, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    Text(
                      company.isNotEmpty ? company : "No company provided",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.0,
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Website
                Row(
                  children: [
                    const Icon(Icons.link, size: 16.0, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    Text(
                      website.isNotEmpty ? website : "No website provided",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.0,
                            color: website.isNotEmpty ? Colors.blueAccent : Colors.white70,
                            decoration: website.isNotEmpty ? TextDecoration.underline : null,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Industry
                Row(
                  children: [
                    const Icon(Icons.category, size: 16.0, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    Text(
                      industry.isNotEmpty ? industry : "No industry provided",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.0,
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
