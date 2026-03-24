class FileModel {
  final String id;
  final String courseId;
  final String title;
  final String fileUrl;
  final String? fileType;
  final DateTime createdAt;

  FileModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.fileUrl,
    this.fileType,
    required this.createdAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      fileUrl: json['file_url'] as String,
      fileType: json['file_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'file_url': fileUrl,
      'file_type': fileType,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
