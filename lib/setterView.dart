// ignore_for_file: file_names

import 'package:first/Views/Mobile/diary.dart';
import 'package:first/Views/Mobile/listOfUsersView.dart';
import 'package:first/provider/doctor_provider.dart';
import 'package:first/provider/paciente_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetterView extends StatefulWidget {
  final UserProvider userProvider;
  const SetterView({super.key, required this.userProvider});

  @override
  State<SetterView> createState() => _SetterViewState();
}

class _SetterViewState extends State<SetterView> {
  @override
  void initState() {
    super.initState();
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final pacienteProvider =
        Provider.of<PacienteProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userProvider.user!.usertype == "doctor") {
        doctorProvider.setDoctor(widget.userProvider.user!);
      } else {
        pacienteProvider.setPaciente(widget.userProvider.user!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final pacienteProvider = Provider.of<PacienteProvider>(context);
    if (widget.userProvider.user!.usertype == "doctor") {
      if (doctorProvider.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListOfUsersView(doctorProvider: doctorProvider);
    } else {
      if (pacienteProvider.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return DiarioView(userId: pacienteProvider.paciente!.id!);
    }
  }
}
