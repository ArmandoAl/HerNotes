import 'package:her_notes/Presentation/screens/begginScreen.dart';
import 'package:her_notes/Presentation/setterView.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_loader.dart';
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
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);

    if (userProvider.loading == true) {
      return const HavenAtmosphere(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: HavenLoader(message: 'Preparando tu espacio...'),
        ),
      );
    }

    if (userProvider.user == null) {
      return const BegginScreen();
    } else {
      return SetterView(userProvider: userProvider);
    }
  }
}
