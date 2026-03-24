class VideoModel {
  final String id;
  final String courseId;
  final String title;
  final String videoUrl;
  final int? durationMinutes;
  final int? orderIndex;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.videoUrl,
    this.durationMinutes,
    this.orderIndex,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      videoUrl: json['video_url'] as String,
      durationMinutes: json['duration_minutes'] as int?,
      orderIndex: json['order_index'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'video_url': videoUrl,
      'duration_minutes': durationMinutes,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
