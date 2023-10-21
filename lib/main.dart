import 'package:first/Views/Mobile/diary.dart';
import 'package:first/Views/Mobile/homeView.dart';
import 'package:first/Views/Mobile/progress.dart';
import 'package:first/Views/Mobile/settings.dart';
import 'package:first/Views/guia.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = LocalStorage("app.json");
  await storage.ready;
  runApp(MyApp(storage: storage));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final LocalStorage storage;
  const MyApp({Key? key, required this.storage}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider(storage: storage)..getStorage()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: MaterialApp(
          // Resto del código
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          routes: {
            '/homeView': (context) => const HomeView(),
            '/login': (context) => const GuiaView(),
            '/registro': (context) => const GuiaView(),
            '/settings': (context) => const ConfiguracionView(),
            '/progress': (context) => const ProgresoView(),
            '/diary': (context) => const DiarioView(),
            '/home': (context) => const GuiaView(),
          },
          home: const GuiaView()),
    );
  }
}
