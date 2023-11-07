// ignore_for_file: file_names

import 'package:first/Views/Mobile/diary.dart';
import 'package:first/provider/doctor_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/widgets/drawer.dart';
import 'package:first/widgets/header.dart';
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
    final userProvider = Provider.of<UserProvider>(context);

    if (widget.doctorProvider.doctor!.pacientes == null) {
      widget.doctorProvider.getPacientes();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: DrawerWidget(
        currentPage: 'ListOfUsers',
        userProvider: userProvider,
      ),
      body: ListView.builder(
        itemCount: widget.doctorProvider.doctor!.pacientes!.length,
        itemBuilder: (context, index) {
          if (widget.doctorProvider.doctor!.pacientes!.isEmpty) {
            return const Center(
              child: Text('No tienes pacientes'),
            );
          }
          final paciente = widget.doctorProvider.doctor!.pacientes![index];

          return Card(
            child: ListTile(
              title: Text(paciente.name),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
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
