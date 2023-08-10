// ignore_for_file: avoid_print

import 'package:first/Views/Mobile/homeView.dart';
import 'package:first/Views/Mobile/verfication_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import 'Mobile/login.dart';

class GuiaView extends StatefulWidget {
  final String ruta;
  const GuiaView({
    Key? key,
    required this.ruta,
  }) : super(key: key);

  @override
  State<GuiaView> createState() => _GuiaViewState();
}

class _GuiaViewState extends State<GuiaView> {
  @override
  void initState() {
    super.initState();
    if (widget.ruta != 'login') {
      addData(context);
    }
  }

  void addData(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.setUser();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ruta == 'login') {
      return const LoginView();
    } else if (widget.ruta == 'verificacion') {
      return const VerficationUserView();
    } else if (widget.ruta == 'homeView') {
      return const HomeView();
    } else {
      return const Text("Otro");
    }
  }
}
