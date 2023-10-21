// ignore_for_file: avoid_print
import 'package:first/models/login_model.dart';
import 'package:first/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  bool loading = false;
  UserModel? user;
  bool logged = false;
  final AuthService _authService = AuthService();
  final LocalStorage storage;
  UserProvider({required this.storage});

  UserModel? get getUser => user;

  Future<void> getStorage() async {
    user = await _authService.getStorage(storage);

    if (user != null) {
      logged = true;
    }
    loading = false;
    notifyListeners();
  }

  Future<UserModel?> login(Login loginModel) async {
    user = await _authService.login(loginModel, storage);
    if (user != null) {
      // print("user${user!.id}");
      logged = true;
      user = user;
    }
    notifyListeners();
    return user;
  }

  Future<UserModel?> singUp(String email, String password, String name) async {
    UserModel? user =
        await _authService.singUpUser(email, password, name, storage);
    if (user != null) {
      logged = true;
      user = user;
    }
    notifyListeners();
    return user;
  }

  Future<void> logout() async {
    await _authService.logout(
      storage,
    );
    logged = false;
    notifyListeners();
  }
}
