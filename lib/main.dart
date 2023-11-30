import 'package:first/guia.dart';
import 'package:first/provider/doctor_provider.dart';
import 'package:first/provider/emotions_provider.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:first/provider/paciente_provider.dart';
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
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => PacienteProvider()),
      ],
      child: const MaterialApp(
          title: 'HerNotes',
          debugShowCheckedModeBanner: false,
          home: GuiaView()),
    );
  }
}
