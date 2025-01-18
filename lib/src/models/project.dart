class Project {
  final int? id; // Nullable because it might not be available initially (e.g., when creating a new project)
  final String description;
  final String stack;
  final List<String> tags;

  const Project({
    this.id, // Optional field
    required this.description,
    required this.stack,
    required this.tags,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'], // Nullable, might be null if not present in the JSON
        description: json['description'],
        stack: json['stack'],
        tags: List<String>.from(json['tags']),
      );

  Map<String, dynamic> toJson() => {
        'id': id, // Nullable, can be null if not set
        'description': description,
        'stack': stack,
        'tags': tags,
      };
}
