import 'package:equatable/equatable.dart';

enum ContactType { phone, whatsapp, facebook, instagram, youtube }

class ContactUsModel extends Equatable {
  final String title;
  final String value;
  final ContactType type;
  final String iconPath;

  const ContactUsModel({
    required this.title,
    required this.value,
    required this.type,
    required this.iconPath,
  });

  @override
  List<Object?> get props => [title, value, type, iconPath];
}
