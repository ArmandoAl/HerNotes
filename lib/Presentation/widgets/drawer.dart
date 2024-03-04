// ignore_for_file: use_build_context_synchronously

import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/provider/paciente_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/screens/diaryScreen.dart';
import 'package:her_notes/Presentation/screens/listOfUsersScreen.dart';
import 'package:her_notes/Presentation/screens/progressScreen.dart';
import 'package:her_notes/Presentation/screens/settingsScreen.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  final String currentPage;
  const DrawerWidget({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final pacienteProvider = Provider.of<PacienteProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    NotesProvider notesProvider =
        Provider.of<NotesProvider>(context, listen: true);
    bool isLoading = false;

    void setState() {
      isLoading = !isLoading;
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.55,
      backgroundColor: theme.isDarkModeEnabled
          ? theme.dark['drawerColor']
          : theme.light['drawerColor'],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.zero,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: theme.isDarkModeEnabled
                            ? const AssetImage('lib/Config/images/her_head.png')
                            : const AssetImage(
                                'lib/Config/images/her_head_.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProvider.getUser!.user.name.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              userProvider.getUser!.user.email.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Menu de opciones',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            userProvider.user!.usertype == "paciente"
                ? Container(
                    color: widget.currentPage == 'Diary'
                        ? const Color.fromARGB(255, 222, 235, 247)
                        : Colors.transparent,
                    child: ListTile(
                      selectedColor: Colors.white,
                      selected:
                          ModalRoute.of(context)!.settings.name == '/diary',
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.book,
                            color: widget.currentPage == 'Diary'
                                ? Colors.black
                                : Colors.white,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Diario',
                            style: TextStyle(
                                color: widget.currentPage == 'Diary'
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (ModalRoute.of(context)!.settings.name != '/diary') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiarioView(
                                userId: userProvider.user!.user.id,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                : Container(
                    color: widget.currentPage == 'ListOfUsers'
                        ? const Color.fromARGB(255, 222, 235, 247)
                        : Colors.transparent,
                    child: ListTile(
                      selectedColor: Colors.white,
                      selected: ModalRoute.of(context)!.settings.name ==
                          '/ListOfUsers',
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.book,
                            color: widget.currentPage == 'ListOfUsers'
                                ? Colors.black
                                : Colors.white,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Pacientes',
                            style: TextStyle(
                                color: widget.currentPage == 'ListOfUsers'
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (ModalRoute.of(context)!.settings.name !=
                            '/ListOfUsers') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOfUsersView(
                                      doctorProvider: doctorProvider,
                                    )),
                          );
                        }
                      },
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: widget.currentPage == 'Progress'
                  ? const Color.fromARGB(255, 222, 235, 247)
                  : Colors.transparent,
              child: ListTile(
                selectedColor: Colors.white,
                selected: ModalRoute.of(context)!.settings.name == '/progress',
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.bar_chart,
                      color: widget.currentPage == 'Progress'
                          ? Colors.black
                          : Colors.white,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Progreso',
                      style: TextStyle(
                          color: widget.currentPage == 'Progress'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 18),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (notesProvider.notes.isEmpty &&
                      userProvider.user!.usertype == "paciente") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Agrega notas para ver tu progreso')),
                    );
                  } else {
                    if (ModalRoute.of(context)!.settings.name != '/progress') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgresoView(
                            userProvider: userProvider,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: widget.currentPage == 'Settings'
                  ? const Color.fromARGB(255, 222, 235, 247)
                  : Colors.transparent,
              child: ListTile(
                selectedColor: Colors.white,
                selected: ModalRoute.of(context)!.settings.name == '/settings',
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: widget.currentPage == 'Settings'
                          ? Colors.black
                          : Colors.white,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Configuración',
                      style: TextStyle(
                          color: widget.currentPage == 'Settings'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 18),
                    ),
                  ],
                ),
                onTap: () {
                  //close the drawer
                  Navigator.pop(context);
                  if (ModalRoute.of(context)!.settings.name != '/settings') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfiguracionView(),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            userProvider.user!.usertype == "paciente"
                ? pacienteProvider.paciente!.doctorId == null
                    ? Container(
                        color: widget.currentPage == 'RelateDoctor'
                            ? const Color.fromARGB(255, 222, 235, 247)
                            : Colors.transparent,
                        child: ListTile(
                          selectedColor: Colors.white,
                          selected: ModalRoute.of(context)!.settings.name ==
                              '/relateDoctor',
                          title: Row(
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                color: widget.currentPage == 'RelateDoctor'
                                    ? Colors.black
                                    : Colors.white,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Vincular doctor',
                                style: TextStyle(
                                    color: widget.currentPage == 'RelateDoctor'
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          onTap: () async {
                            //open a share dialog
                            Navigator.pop(context);
                            //show the share dialog with the token
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Vincula a tu doctor'),
                                  content: SizedBox(
                                    height: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Ingresa el código de tu doctor:',
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          onChanged: (value) {
                                            _textFieldController.text = value;
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Código',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        setState();

                                        final result =
                                            await pacienteProvider.relateDoctor(
                                                pacienteProvider.paciente!.id!,
                                                _textFieldController.text);

                                        if (result != null) {
                                          await userProvider
                                              .setDoctorIdInUserStorage(result);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Vinculación exitosa con el doctor')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'No se pudo vincular con el doctor')),
                                          );
                                        }

                                        setState();

                                        Navigator.pop(context);
                                      },
                                      child: isLoading
                                          ? const CircularProgressIndicator()
                                          : const Text('Vincular'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Container()
                : Container(),
            userProvider.user!.usertype == "doctor"
                ? Container(
                    color: widget.currentPage == 'ShareCode'
                        ? const Color.fromARGB(255, 222, 235, 247)
                        : Colors.transparent,
                    child: ListTile(
                      selectedColor: Colors.white,
                      selected:
                          ModalRoute.of(context)!.settings.name == '/shareCode',
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: widget.currentPage == 'ShareCode'
                                ? Colors.black
                                : Colors.white,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Compartir código',
                            style: TextStyle(
                                color: widget.currentPage == 'ShareCode'
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () async {
                        //open a share dialog
                        Navigator.pop(context);
                        //show the share dialog with the token
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Comparte tu código'),
                              content: SizedBox(
                                height: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Tu código de vinculación es:',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      doctorProvider.doctor!.tokenForRelate!,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    _copyToClipboard(
                                        doctorProvider.doctor!.tokenForRelate!,
                                        context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Copiar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

void _copyToClipboard(String text, BuildContext context) {
  Clipboard.setData(ClipboardData(text: text));
  // Puedes mostrar un mensaje o realizar cualquier otra acción después de copiar
  // Por ejemplo, puedes mostrar un SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Token copiado al portapapeles')),
  );
}
