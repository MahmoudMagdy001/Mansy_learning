import 'package:equatable/equatable.dart';
import '../models/contact_us_model.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object?> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final List<ContactUsModel> contacts;
  final String? message; // For showing result of launcher

  const ContactUsSuccess(this.contacts, {this.message});

  @override
  List<Object?> get props => [contacts, message];
}

class ContactUsError extends ContactUsState {
  final String message;

  const ContactUsError(this.message);

  @override
  List<Object?> get props => [message];
}
