import 'package:firebase_core/firebase_core.dart';
import 'package:first/firebase_options.dart';
import 'package:first/guia.dart';
import 'package:first/provider/doctor_provider.dart';
import 'package:first/provider/emotions_provider.dart';
import 'package:first/config/push_notifications.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:first/provider/paciente_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/screens/register_page.dart';
import 'package:first/screens/singUp.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

final navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await PushNotifications().init();
  final storage = LocalStorage("app.json");
  await storage.ready;
  runApp(MyApp(storage: storage));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final LocalStorage storage;
  const MyApp({Key? key, required this.storage}) : super(key: key);
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider(storage: storage)..getStorage()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(storage: storage)..getTheme()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => PacienteProvider()),
      ],
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context, listen: true);
    return MaterialApp(
      navigatorKey: navKey,
      routes: {'/home': (context) => const RegisterPage()},
      initialRoute: '/home',
      theme: theme.isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      title: 'HerNotes',
      debugShowCheckedModeBanner: false,
    );
  }
}
