import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepository repository;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  EditProfileCubit(this.repository) : super(const EditProfileState());

  ProfileModel? _currentProfile;

  void init(ProfileModel profile) {
    _currentProfile = profile;
    firstNameController.text = profile.firstName;
    lastNameController.text = profile.lastName;
    phoneController.text = profile.phone;
  }

  Future<void> updateProfile() async {
    if (_currentProfile == null) return;
    
    emit(state.copyWith(status: EditProfileStatus.loading));
    try {
      final updatedProfile = _currentProfile!.copyWith(
        fullName: '${firstNameController.text} ${lastNameController.text}'.trim(),
        phone: phoneController.text,
      );
      await repository.updateProfile(updatedProfile);
      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditProfileStatus.error, message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
