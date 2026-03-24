import 'package:equatable/equatable.dart';

enum TermsSectionType { header, paragraph, bullet }

class TermsSection extends Equatable {
  final String content;
  final TermsSectionType type;

  const TermsSection({required this.content, required this.type});

  @override
  List<Object?> get props => [content, type];
}

class TermsAndConditionsModel extends Equatable {
  final String title;
  final String lastUpdated;
  final List<TermsSection> sections;

  const TermsAndConditionsModel({
    required this.title,
    required this.lastUpdated,
    required this.sections,
  });

  @override
  List<Object?> get props => [title, lastUpdated, sections];
}
