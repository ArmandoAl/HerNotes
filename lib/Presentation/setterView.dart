import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/provider/paciente_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/screens/main_shell.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_loader.dart';
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
      if (widget.userProvider.user!.usertype == 'doctor') {
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
    if (widget.userProvider.user!.usertype == 'doctor') {
      if (doctorProvider.loading) {
        return const HavenAtmosphere(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: HavenLoader(message: 'Abriendo el consultorio...'),
          ),
        );
      }
      return const MainShell();
    } else {
      if (pacienteProvider.loading) {
        return const HavenAtmosphere(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: HavenLoader(message: 'Abriendo tu diario...'),
          ),
        );
      }
      return const MainShell();
    }
  }
}
