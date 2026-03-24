class SubscriptionModel {
  final String userId;
  final String courseId;
  final DateTime enrolledAt;

  SubscriptionModel({
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      enrolledAt: DateTime.parse(json['enrolled_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'course_id': courseId,
      'enrolled_at': enrolledAt.toIso8601String(),
    };
  }
}
