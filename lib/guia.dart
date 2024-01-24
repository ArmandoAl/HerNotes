// ignore_for_file: avoid_print
import 'package:first/screens/login.dart';
import 'package:first/setterView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/user_provider.dart';

class GuiaView extends StatefulWidget {
  const GuiaView({
    Key? key,
  }) : super(key: key);

  @override
  State<GuiaView> createState() => _GuiaViewState();
}

class _GuiaViewState extends State<GuiaView> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);

    if (userProvider.loading == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userProvider.user == null) {
      return const LoginView();
    } else {
      return SetterView(userProvider: userProvider);
    }
  }
}
