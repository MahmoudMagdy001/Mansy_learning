import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/contact_us_model.dart';
import '../repositories/contact_us_repository.dart';
import '../services/contact_us_service.dart';
import 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final ContactUsRepository repository;
  final ContactUsService service;

  ContactUsCubit({required this.repository, required this.service}) : super(ContactUsInitial());

  void getContactOptions() {
    emit(ContactUsLoading());
    try {
      final contacts = repository.getContactOptions();
      emit(ContactUsSuccess(contacts));
    } catch (e) {
      emit(ContactUsError(e.toString()));
    }
  }

  Future<void> launchContact(ContactUsModel contact) async {
    final currentState = state;
    if (currentState is ContactUsSuccess) {
      try {
        await service.launchContact(contact);
        // We stay in success state with existing contacts
      } catch (e) {
        emit(ContactUsError(e.toString()));
        // After showing error, we reload to success state
        getContactOptions();
      }
    }
  }
}
