import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/Views/Mobile/chat.dart';
import 'package:first/Views/Mobile/diary.dart';
import 'package:first/Views/Mobile/homeView.dart';
import 'package:first/Views/Mobile/progress.dart';
import 'package:first/Views/Mobile/settings.dart';
import 'package:first/Views/guia.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/services/auth_service.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  AuthService authService = AuthService();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        // Resto del código
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routes: {
          '/homeView': (context) => const HomeView(),
          '/login': (context) => const GuiaView(
                ruta: 'login',
              ),
          '/verificacion': (context) => const GuiaView(
                ruta: 'verificacion',
              ),
          '/registro': (context) => const GuiaView(
                ruta: 'registro',
              ),
          '/settings': (context) => const ConfiguracionView(),
          '/chat': (context) => const ChatView(),
          '/progress': (context) => const ProgresoView(),
          '/diary': (context) => const DiarioView(),
          '/home': (context) => const GuiaView(
                ruta: 'homeView',
              ),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.data == null) {
                // Usuario no autenticado
                return const GuiaView(
                  ruta: 'login',
                );
              } else if (snapshot.data!.emailVerified == false) {
                // Usuario autenticado pero no ha verificado el correo electrónico
                return const GuiaView(
                  ruta: 'verificacion',
                );
              } else {
                // Usuario autenticado y correo electrónico verificado
                return const GuiaView(
                  ruta: 'homeView',
                );
              }
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
