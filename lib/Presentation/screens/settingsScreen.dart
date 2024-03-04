// ignore_for_file: file_names, use_build_context_synchronously

import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';

class ConfiguracionView extends StatefulWidget {
  const ConfiguracionView({super.key});

  @override
  State<ConfiguracionView> createState() => _ConfiguracionViewState();
}

class _ConfiguracionViewState extends State<ConfiguracionView> {
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: const DrawerWidget(
        currentPage: 'Settings',
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: theme.isDarkModeEnabled
              ? theme.dark['backgroundColor']
              : theme.light['backgroundColor'],
        ),
        child: Column(
          /* mainAxisAlignment: MainAxisAlignment.center, */
          children: <Widget>[
            _settingsHeader(),
            const SizedBox(
              height: 50,
            ),
            _userSettings(user.getUser!.user.name.toString(),
                user.getUser!.user.email.toString(), theme),
            const SizedBox(
              height: 80,
            ),
            _itemSettings(
                user,
                const Icon(Icons.notifications),
                "Notificaciones",
                const Color.fromRGBO(245, 197, 64, 1),
                theme,
                notesProvider),
            const SizedBox(
              height: 50,
            ),
            _itemSettings(
                user,
                const Icon(
                  Icons.dark_mode,
                  color: Colors.white,
                ),
                "Dark Mode",
                const Color.fromARGB(255, 199, 188, 188),
                theme,
                notesProvider),
            const SizedBox(
              height: 50,
            ),
            _itemSettings(user, const Icon(Icons.logout), "Cerrar sesión",
                const Color.fromRGBO(146, 146, 146, 1), theme, notesProvider),
          ],
        ),
      ),
    );
  }

  Widget _settingsHeader() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        const SizedBox(
          width: 20,
        ),
        const Text(
          'Configuración',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _userSettings(String name, String email, ThemeProvider theme) {
    return Row(
      children: [
        theme.isDarkModeEnabled
            ? Image.asset(
                'lib/Config/images/her_head.png',
                width: 50,
                height: 50,
              )
            : Image.asset(
                'lib/Config/images/her_head_.png',
                width: 50,
                height: 50,
              ),
        const SizedBox(
          width: 30,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              email,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              /* Navigator.pushNamed(context, '/login'); */
            },
            icon: const Icon(Icons.arrow_forward_ios)),
      ],
    );
  }

  Widget _itemSettings(UserProvider user, Icon icon, String text, Color color,
      ThemeProvider theme, NotesProvider notesProvider) {
    //en el futuro vas a mandar la ruta o una palabra clave que mande un dialog para configurar
    return InkWell(
      onTap: () {
        if (text == "Cerrar sesión") {
          theme.setTheme(false);
          notesProvider.clearProvider();
          user.logout(context);
        }
        if (text == "Dark Mode") {
          theme.setTheme(!theme.isDarkModeEnabled);
        }
      },
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Icon(
              icon.icon,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
