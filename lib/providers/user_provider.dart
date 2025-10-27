import 'package:flutter/material.dart';
import '../models/user_model.dart';

// Этот провайдер хранит данные о ЗАЛОГИНЕННОМ пользователе
// 'profile_screen.dart' будет брать данные отсюда

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
