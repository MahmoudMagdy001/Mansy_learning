import '../models/signup_model.dart';
import '../services/signup_service.dart';
import 'signup_repository.dart';

class SignupRepositoryImpl implements SignupRepository {
  final SignupService service;

  SignupRepositoryImpl(this.service);

  @override
  Future<void> signup(SignupModel model) async {
    try {
      return await service.signup(model);
    } catch (e) {
      rethrow;
    }
  }
}
