// ignore_for_file: file_names
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/provider/paciente_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/screens/diaryScreen.dart';
import 'package:her_notes/Presentation/screens/listOfUsersScreen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.userProvider.user!.usertype == "doctor") {
        doctorProvider.setDoctor(widget.userProvider.user!);
      } else {
        pacienteProvider.setPaciente(widget.userProvider.user!);
        await Provider.of<NotesProvider>(context, listen: false)
            .getNotes(pacienteProvider.paciente!.id!);
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
