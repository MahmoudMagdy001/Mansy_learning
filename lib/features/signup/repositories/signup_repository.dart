import '../models/signup_model.dart';

abstract class SignupRepository {
  Future<void> signup(SignupModel model);
}
