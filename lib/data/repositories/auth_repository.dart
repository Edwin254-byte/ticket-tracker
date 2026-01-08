import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthDataSource dataSource;

  AuthRepository(this.dataSource);

  Future<User> login(String email, String password) async {
    final user = await dataSource.login(email, password);
    await dataSource.persistLoginState(user);
    return user;
  }

  Future<void> logout() async {
    await dataSource.logout();
  }

  bool isLoggedIn() {
    return dataSource.isLoggedIn();
  }

  User? getCurrentUser() {
    return dataSource.getCurrentUser();
  }
}
