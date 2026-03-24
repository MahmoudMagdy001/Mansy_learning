class ProfileModel {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String email;
  final String phone;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    this.email = '',
    this.phone = '',
    required this.createdAt,
  });

  String get firstName {
    if (fullName.isEmpty) return '';
    return fullName.split(' ').first;
  }

  String get lastName {
    final parts = fullName.split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    return '';
  }


  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'New User',
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'student',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    String? role,
    String? email,
    String? phone,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

