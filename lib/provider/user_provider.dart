// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();

  UserModel? get getUser => _user;

  Future<void> setUser() async {
    UserModel? user = await _authService.getCurrentUser();
    print("current user: ${user.toJson()}");
    _user = user;
    notifyListeners();
  }

  Future<UserModel?> get getUserFuture async {
    UserModel user = await _authService.getCurrentUser();
    _user = user;
    return _user;
  }

  Stream<User?> get userIsVerified => _authService.authUserStream;
}
