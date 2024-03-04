// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:her_notes/Domain/domain.dart';
import 'package:her_notes/Data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:her_notes/Presentation/screens/begginScreen.dart';
import 'package:localstorage/localstorage.dart';

class UserProvider extends ChangeNotifier {
  bool loading = false;
  ModelForControlUsertype? user;
  bool logged = false;
  final AuthService _authService = AuthService();
  final LocalStorage storage;
  UserProvider({required this.storage});

  ModelForControlUsertype? get getUser => user;

  Future<void> getStorage() async {
    user = await _authService.getStorage(storage);

    if (user != null) {
      logged = true;
    }
    loading = false;
    notifyListeners();
  }

  Future<ModelForControlUsertype?> login(Login loginModel) async {
    user = await _authService.login(loginModel, storage);
    if (user != null) {
      logged = true;
      user = user;
    }
    notifyListeners();
    return user;
  }

  Future<int?> singUpPaciente(UserModel userforRegis) async {
    int? paciente = await _authService.singUpPaciente(userforRegis, storage);
    if (paciente != null) {
      notifyListeners();
      return paciente;
    }
    return null;
  }

  Future<int?> singUpDoctor(DoctorModel doctor) async {
    int? user = await _authService.singUpDoctor(doctor, storage);
    if (user != null) {
      notifyListeners();
      return user;
    }
    return null;
  }

  Future<void> logout(
    BuildContext context,
  ) async {
    await _authService.logout(
      storage,
    );
    logged = false;
    notifyListeners();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BegginScreen()),
        (route) => false);
  }

  Future<bool> setDoctorIdInUserStorage(int id) async {
    bool user = await _authService.setDoctorIdInUserStorage(id, storage);
    if (user) {
      notifyListeners();
      return user;
    }
    return false;
  }
}
