// ignore_for_file: file_names
// import 'package:first/provider/user_provider.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    // UserProvider user = Provider.of<UserProvider>(context);

    return Container();
    // FutureBuilder(
    //     future: user.getUserFuture,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else {
    //         if (snapshot.hasData) {
    //           return const DiarioView();
    //         } else {
    //           // Usuario no autenticado
    //           Navigator.pushNamedAndRemoveUntil(
    //               context, '/login', (route) => false);
    //           return const SizedBox.shrink();
    //         }
    //       }
    //     });
  }
}
