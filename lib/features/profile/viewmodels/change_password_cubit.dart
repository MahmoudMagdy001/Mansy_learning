import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/profile_repository.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ProfileRepository repository;

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ChangePasswordCubit(this.repository) : super(const ChangePasswordState());

  Future<void> updatePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      emit(state.copyWith(
        status: ChangePasswordStatus.error,
        message: 'كلمات المرور غير متطابقة',
      ));
      return;
    }

    emit(state.copyWith(status: ChangePasswordStatus.loading));
    try {
      await repository.updatePassword(
        currentPasswordController.text,
        newPasswordController.text,
      );
      emit(state.copyWith(status: ChangePasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ChangePasswordStatus.error,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
