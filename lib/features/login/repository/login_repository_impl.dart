import 'login_repository.dart';
import '../service/login_service.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(this.service);
  final LoginService service;

  @override
  Future<void> login(String email, String password) =>
      service.login(email, password);
}
