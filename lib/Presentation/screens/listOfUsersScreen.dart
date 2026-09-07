import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/screens/diaryScreen.dart';
import 'package:her_notes/Presentation/screens/main_shell.dart';
import 'package:her_notes/Presentation/widgets/empty_state.dart';
import 'package:her_notes/Presentation/widgets/haven_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfUsersView extends StatefulWidget {
  const ListOfUsersView({Key? key}) : super(key: key);

  @override
  State<ListOfUsersView> createState() => _ListOfUsersViewState();
}

class _ListOfUsersViewState extends State<ListOfUsersView> {
  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);
    final palette = havenPalette(context);

    if (doctorProvider.doctor?.pacientes == null) {
      doctorProvider.getPacientes();
      return const HavenLoader(message: 'Reuniendo a las personas...');
    }

    final pacientes = doctorProvider.doctor!.pacientes!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: pacientes.isEmpty
            ? const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: HavenPageHeader(
                      kicker: 'Consultorio',
                      title: 'Tus pacientes',
                      subtitle:
                          'Comparte tu código desde Espacio para empezar a acompañar.',
                    ),
                  ),
                  Expanded(
                    child: HavenEmptyState(
                      icon: Icons.people_outline_rounded,
                      title: 'Todavía no hay vínculos',
                      subtitle:
                          'Cuando alguien ingrese tu código, aparecerá aquí con su diario.',
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
                itemCount: pacientes.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: HavenPageHeader(
                        kicker: 'Consultorio',
                        title: 'Quienes acompañas',
                        subtitle:
                            'Entra a un diario para leer con respeto y dejar un ejercicio.',
                      ),
                    );
                  }
                  final paciente = pacientes[index - 1];
                  final initials = paciente.name.isEmpty
                      ? '?'
                      : paciente.name
                          .trim()
                          .split(' ')
                          .take(2)
                          .map((e) => e[0])
                          .join()
                          .toUpperCase();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        notesProvider.getNotes(paciente.id!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiarioView(
                              userId: paciente.id!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: palette.line),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: palette.primarySoft,
                              child: Text(
                                initials,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: palette.primaryDeep),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    paciente.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Abrir diario compartido',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: palette.inkFaint,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
