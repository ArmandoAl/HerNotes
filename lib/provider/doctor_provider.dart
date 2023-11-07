import 'package:first/models/doctor_model.dart';
import 'package:first/models/model_for_control_usertype.dart';
import 'package:first/services/doctor_service.dart';
import 'package:flutter/material.dart';

class DoctorProvider extends ChangeNotifier {
  bool loading = true;
  DoctorModel? doctor;
  DoctorModel? get getDoctor => doctor;
  final DoctorService _doctorService = DoctorService();

  DoctorProvider({this.doctor});

  Future<void> setDoctor(ModelForControlUsertype doctor) async {
    this.doctor = DoctorModel(
      id: doctor.user.id,
      name: doctor.user.name,
      email: doctor.user.email,
      password: doctor.user.password,
      pacientes: null,
    );
    loading = false;
    notifyListeners();
  }

  Future<void> getPacientes() async {
    doctor!.pacientes = await _doctorService.getPacientes(doctor!.id!);
    notifyListeners();
  }
}
