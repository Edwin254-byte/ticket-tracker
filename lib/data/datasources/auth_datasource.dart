import '../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class AuthDataSource {
  final LocalStorageService storageService;

  AuthDataSource(this.storageService);

  // Mocked login - accepts any email that matches the pattern and password >= 6 chars
  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate email format
    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }

    // Validate password length
    if (password.length < AppConstants.minPasswordLength) {
      throw Exception('Password must be at least ${AppConstants.minPasswordLength} characters');
    }

    // Mock successful login
    return User(email: email);
  }

  Future<void> persistLoginState(User user) async {
    await storageService.setLoggedIn(true);
    await storageService.setUserEmail(user.email);
  }

  Future<void> logout() async {
    await storageService.clearAll();
  }

  bool isLoggedIn() {
    return storageService.isLoggedIn();
  }

  User? getCurrentUser() {
    final email = storageService.getUserEmail();
    if (email != null) {
      return User(email: email);
    }
    return null;
  }
}
