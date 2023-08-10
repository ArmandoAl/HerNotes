// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? user;
  final AuthService _authService = AuthService();

  UserModel? get getUser => user;

  Future<void> setUser() async {
    UserModel? user = await _authService.getCurrentUser();
    print("current user: ${user.toJson()}");
    user = user;
    notifyListeners();
  }

  Future<UserModel?> get getUserFuture async {
    UserModel user = await _authService.getCurrentUser();
    this.user = user;
    return user;
  }

  Stream<User?> get userIsVerified => _authService.authUserStream;
}
