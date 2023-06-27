import 'package:first/utils/theme_provider.dart';
import 'package:first/widgets/drawer.dart';
import 'package:first/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiarioView extends StatefulWidget {
  const DiarioView({super.key});

  @override
  State<DiarioView> createState() => _DiarioViewState();
}

class _DiarioViewState extends State<DiarioView> {
  final List<Notes> _notes = <Notes>[];

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: const DrawerWidget(currentPage: 'Diary'),
      body: Container(
        decoration: BoxDecoration(
          color: theme.isDarkModeEnabled
              ? const Color(0xFF212121)
              : const Color.fromARGB(245, 223, 219, 219),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(reverse: true, children: <Widget>[
                ListBody(
                  reverse: true,
                  children: _notes,
                ),
              ]),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                //put border radius only on the top
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: theme.isDarkModeEnabled
                    ? theme.dark['backgroundColor']
                    : theme.light['backgroundColor'],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Center(
                        child: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.search)),
                      )),
                  const Spacer(),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              showAddNoteDialog(context, _notes);
                            },
                            icon: const Icon(Icons.add)),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showAddNoteDialog(BuildContext context, List<Notes> notes) {
    List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem(
        value: 'Feliz',
        child: Text('Feliz'),
      ),
      const DropdownMenuItem(
        value: 'Triste',
        child: Text('Triste'),
      ),
      const DropdownMenuItem(
        value: 'Enojado',
        child: Text('Enojado'),
      ),
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String content = '';
        final String currentDate =
            '${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text(currentDate),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField(
                  items: items,
                  onChanged: (value) {
                    title = value.toString();
                  }),
              TextField(
                onChanged: (value) {
                  content = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Escribe',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Guardar la nota en la lista de notas
                final Notes newNote = Notes(title, content, currentDate);
                setState(() {
                  notes.add(newNote);
                });
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

class Notes extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const Notes(this.title, this.description, this.date, {super.key});

  List<Widget> note(context) {
    return <Widget>[
      Container(
        color: const Color(0xF5F5F5F5),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          trailing: Text(
            date,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
      const Divider(
        color: Colors.black,
        thickness: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: note(context),
    );
  }
}
