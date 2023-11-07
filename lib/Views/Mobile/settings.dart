import 'package:first/Views/Mobile/login.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:first/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/drawer.dart';

class ConfiguracionView extends StatefulWidget {
  const ConfiguracionView({super.key});

  @override
  State<ConfiguracionView> createState() => _ConfiguracionViewState();
}

class _ConfiguracionViewState extends State<ConfiguracionView> {
  void logout(BuildContext context, UserProvider user) async {
    user.logout();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: DrawerWidget(
        currentPage: 'Settings',
        userProvider: user,
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
                user.getUser!.user.email.toString()),
            const SizedBox(
              height: 80,
            ),
            _itemSettings(
                user,
                const Icon(Icons.chat),
                "idioma",
                const Color.fromRGBO(183, 109, 56, 1),
                theme), //en el futuro vas a mandar la ruta o una palabra clave que mande un dialog para configurar
            const SizedBox(
              height: 50,
            ),
            _itemSettings(user, const Icon(Icons.notifications),
                "notificaciones", const Color.fromRGBO(245, 197, 64, 1), theme),
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
                theme),
            const SizedBox(
              height: 50,
            ),
            _itemSettings(user, const Icon(Icons.logout), "Serrar sesión",
                const Color.fromRGBO(146, 146, 146, 1), theme),
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
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _userSettings(String name, String email) {
    return Row(
      children: [
        Image.asset(
          'lib/images/her_head.png',
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
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              email,
              style: const TextStyle(
                color: Colors.black,
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
      ThemeProvider theme) {
    //en el futuro vas a mandar la ruta o una palabra clave que mande un dialog para configurar
    return Row(
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
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              if (text == "Serrar sesión") {
                logout(context, user);
              }
              if (text == "Dark Mode") {
                theme.enableDarkMode(!theme.isDarkModeEnabled);
              }
            },
            icon: const Icon(Icons.arrow_forward_ios)),
      ],
    );
  }
}
