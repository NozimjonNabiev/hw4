import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  int? _userId;
  String? _userEmail;

  int? get userId => _userId;
  String? get userEmail => _userEmail;

  static Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? userEmail = prefs.getString('userEmail');
    return {'userId': userId, 'userEmail': userEmail};
  }

  Future<void> loadUserData() async {
    Map<String, dynamic> userData = await getUserData();
    _userId = userData['userId'] as int?;
    _userEmail = userData['userEmail'] as String?;
    notifyListeners();
  }
}
