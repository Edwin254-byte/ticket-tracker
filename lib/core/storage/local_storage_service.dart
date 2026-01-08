import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserEmail = 'user_email';
  static const String _keyResolvedTickets = 'resolved_tickets';
  static const String _keyThemeMode = 'theme_mode';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Authentication
  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(_keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<bool> setUserEmail(String email) async {
    return await _prefs.setString(_keyUserEmail, email);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  // Resolved tickets
  Future<bool> addResolvedTicket(int ticketId) async {
    final resolvedTickets = getResolvedTickets();
    if (!resolvedTickets.contains(ticketId)) {
      resolvedTickets.add(ticketId);
      return await _prefs.setString(
        _keyResolvedTickets,
        jsonEncode(resolvedTickets),
      );
    }
    return true;
  }

  List<int> getResolvedTickets() {
    final String? jsonString = _prefs.getString(_keyResolvedTickets);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e as int).toList();
    }
    return [];
  }

  bool isTicketResolved(int ticketId) {
    return getResolvedTickets().contains(ticketId);
  }

  // Theme mode
  Future<bool> setThemeMode(String mode) async {
    return await _prefs.setString(_keyThemeMode, mode);
  }

  String getThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'system';
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
