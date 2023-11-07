import 'package:first/Views/Mobile/anotations_view.dart';
import 'package:first/Views/Mobile/notePage.dart';
import 'package:first/models/emocion_model.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/widgets/drawer.dart';
import 'package:first/widgets/return_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/header.dart';

class DiarioView extends StatefulWidget {
  final int userId;
  const DiarioView({Key? key, required this.userId}) : super(key: key);
  @override
  State<DiarioView> createState() => _DiarioViewState();
}

class _DiarioViewState extends State<DiarioView> {
  ScrollController notesScrollController = ScrollController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);

    if (notesProvider.loading) {
      notesProvider.getNotes(widget.userId);

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: userProvider.user!.usertype == "doctor"
          ? const ReturnHeaderWidget() as PreferredSizeWidget?
          : const HeaderWidget(),
      drawer: DrawerWidget(
        currentPage: 'Diary',
        userProvider: userProvider,
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
            return InkWell(
              onLongPress: userProvider.user!.usertype == "doctor"
                  ? () {
                      notesProvider.toggleNoteSelection(note.id!);
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.content.texto!,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _notesList(
                                    notesProvider.notes[index].emociones!),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    note.selected
                        ? InkWell(
                            onTap: () {
                              //poner todas las notas en false
                              notesProvider.clearNotes();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AnotationsView(
                                          anotations: note.notaciones!,
                                          notesProvider: notesProvider,
                                          idNote: note.id!)));
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "Anotaciones",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: userProvider.user!.usertype == "paciente"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return WriteNotePage(
                        userId: widget.userId,
                        notesProvider: notesProvider,
                      );
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
            )
          : null,
    );
  }

  List<Widget> _notesList(List<EmocionModel> emociones) {
    List<Widget> lista = [];
    for (var i = 0; i < emociones.length; i++) {
      lista.add(
        Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Text(
                emociones[i].tipo,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }
    return lista;
  }
}
