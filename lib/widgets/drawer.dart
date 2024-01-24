import 'package:first/provider/doctor_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/screens/diary.dart';
import 'package:first/screens/listOfUsersView.dart';
import 'package:first/screens/progress.dart';
import 'package:first/screens/settings.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  final UserProvider userProvider;
  final String currentPage;
  const DrawerWidget({
    Key? key,
    required this.currentPage,
    required this.userProvider,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
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
                        backgroundImage: theme.isDarkModeEnabled ? const AssetImage('lib/images/her_head.png') : const AssetImage('lib/images/her_head_.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userProvider.getUser!.user.name.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.userProvider.getUser!.user.email
                                  .toString(),
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
            widget.userProvider.user!.usertype == "paciente"
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
                                userId: widget.userProvider.user!.user.id,
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
                  if (ModalRoute.of(context)!.settings.name != '/progress') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgresoView(
                          userProvider: widget.userProvider,
                        ),
                      ),
                    );
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
          ],
        ),
      ),
    );
  }
}
