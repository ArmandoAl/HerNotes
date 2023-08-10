import 'package:first/Views/Mobile/homeView.dart';
import 'package:first/Views/Mobile/login.dart';
import 'package:first/Views/Mobile/settings.dart';
import 'package:first/Views/Mobile/singUp.dart';
import 'package:first/Views/start.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Views/Mobile/diary.dart';
import '../Views/Mobile/progress.dart';
import '../Views/guia.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) => const StartView(),
  ),
  GoRoute(path: '/login', builder: (context, state) => const LoginView()),
  GoRoute(path: '/registro', builder: (context, state) => const SingUpView()),
  GoRoute(
      path: '/settings',
      builder: (context, state) => const ConfiguracionView()),
  GoRoute(path: '/progress', builder: (context, state) => const ProgresoView()),
  GoRoute(path: '/diary', builder: (context, state) => const DiarioView()),
  GoRoute(path: '/homeView', builder: (context, state) => const HomeView()),
  GoRoute(
      path: '/guialogin',
      builder: (context, state) => const GuiaView(
            ruta: 'login',
          )),
  GoRoute(
      path: '/guiaverificacion',
      builder: (context, state) => const GuiaView(
            ruta: 'verificacion',
          )),
  GoRoute(
      path: '/guiahomeView',
      builder: (context, state) => const GuiaView(
            ruta: 'diary',
          )),
]);
