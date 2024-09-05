import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalState extends ChangeNotifier {
  String _username = "";

  String get username => _username;

  void setUsername(String username) {
    _username = username;
    _saveUsernameToPrefs(username); // Save the username to SharedPreferences
    notifyListeners();
  }

Future<void> loadUsernameFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  _username = prefs.getString('username') ?? '';
  notifyListeners();
}

  Future<void> _saveUsernameToPrefs(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }
}
