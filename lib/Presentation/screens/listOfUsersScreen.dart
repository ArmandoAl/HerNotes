// ignore_for_file: file_names

import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/screens/diaryScreen.dart';
import 'package:her_notes/Presentation/widgets/drawer.dart';
import 'package:her_notes/Presentation/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfUsersView extends StatefulWidget {
  final DoctorProvider doctorProvider;
  const ListOfUsersView({Key? key, required this.doctorProvider})
      : super(key: key);

  @override
  State<ListOfUsersView> createState() => _ListOfUsersViewState();
}

class _ListOfUsersViewState extends State<ListOfUsersView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);

    if (widget.doctorProvider.doctor!.pacientes == null) {
      widget.doctorProvider.getPacientes();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: const DrawerWidget(
        currentPage: 'ListOfUsers',
      ),
      body: widget.doctorProvider.doctor!.pacientes!.isEmpty
          ? Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: themeProvider.isDarkModeEnabled
                    ? themeProvider.dark['backgroundColor']
                    : themeProvider.light['backgroundColor'],
              ),
              child: const Center(
                child: Text(
                    'No tienes pacientes registrados, en el menu lateral encontraras la opcion para compartirle tu codigo de vinculacion a tus pacientes.',
                    style: TextStyle(fontSize: 20, color: Colors.grey)),
              ),
            )
          : ListView.builder(
              itemCount: widget.doctorProvider.doctor!.pacientes!.length,
              itemBuilder: (context, index) {
                if (widget.doctorProvider.doctor!.pacientes!.isEmpty) {
                  return const Center(
                    child: Text('No tienes pacientes'),
                  );
                }
                final paciente =
                    widget.doctorProvider.doctor!.pacientes![index];

                return Card(
                  child: ListTile(
                    title: Text(paciente.name),
                    trailing: const Icon(Icons.arrow_forward_ios),
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
                  ),
                );
              },
            ),
    );
  }
}
