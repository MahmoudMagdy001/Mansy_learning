class UserEnrollmentModel {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrolledAt;

  UserEnrollmentModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
  });

  factory UserEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return UserEnrollmentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      enrolledAt: DateTime.parse(json['enrolled_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'enrolled_at': enrolledAt.toIso8601String(),
    };
  }
}
