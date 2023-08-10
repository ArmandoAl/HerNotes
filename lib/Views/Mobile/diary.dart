import 'package:first/Views/Mobile/notePage.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:first/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/header.dart';

class DiarioView extends StatefulWidget {
  const DiarioView({super.key});

  @override
  State<DiarioView> createState() => _DiarioViewState();
}

class _DiarioViewState extends State<DiarioView> {
  ScrollController notesScrollController = ScrollController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: true);

    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: const DrawerWidget(
        currentPage: 'Diary',
      ),
      body: ListView.builder(
        controller: notesProvider.notesScrollController,
        itemCount: notesProvider.notes.length,
        itemBuilder: (context, index) {
          if (notesProvider.notes.isEmpty) {
            return const Center(
                child: Text('No hay notas', style: TextStyle(fontSize: 20)));
          } else {
            final note = notesProvider.notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.content),
              trailing: Text(note.mood.toString()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const WriteNotePage();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOutQuart;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
