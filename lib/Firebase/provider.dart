// lib/user_provider.dart
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = '';

  String get name => _name;

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }
}
