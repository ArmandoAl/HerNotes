import 'package:first/provider/user_provider.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
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
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('lib/images/her_head.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.getUser!.name.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              user.getUser!.email.toString(),
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
            Container(
              color: widget.currentPage == 'Chat'
                  ? const Color.fromARGB(255, 222, 235, 247)
                  : Colors.transparent,
              child: ListTile(
                selectedColor: Colors.white,
                selected: ModalRoute.of(context)!.settings.name == '/chat',
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.message,
                      color: widget.currentPage == 'Chat'
                          ? Colors.black
                          : Colors.white,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Mensajes',
                      style: TextStyle(
                          color: widget.currentPage == 'Chat'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 18),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (ModalRoute.of(context)!.settings.name != '/chat') {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/chat', (route) => false);
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
                    Navigator.pushNamed(context, '/progress');
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: widget.currentPage == 'Diary'
                  ? const Color.fromARGB(255, 222, 235, 247)
                  : Colors.transparent,
              child: ListTile(
                selectedColor: Colors.white,
                selected: ModalRoute.of(context)!.settings.name == '/diary',
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
                    Navigator.pushNamed(context, '/diary');
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
                    Navigator.pushNamed(context, '/settings');
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
