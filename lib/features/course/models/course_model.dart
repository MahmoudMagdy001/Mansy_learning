class CourseModel {
  final String id;
  final String? departmentId;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? instructorId;
  final double? price;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    this.departmentId,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.instructorId,
    this.price,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      departmentId: json['department_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      instructorId: json['instructor_id'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department_id': departmentId,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'instructor_id': instructorId,
      'price': price,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

