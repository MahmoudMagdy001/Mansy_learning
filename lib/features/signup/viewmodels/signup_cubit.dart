import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/signup_model.dart';
import '../repositories/signup_repository.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository repository;

  SignupCubit(this.repository) : super(const SignupState());

  Future<void> signup(SignupModel model) async {
    emit(state.copyWith(status: SignupStatus.loading));
    try {
      await repository.signup(model);
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.error, message: e.toString()));
    }
  }
}
