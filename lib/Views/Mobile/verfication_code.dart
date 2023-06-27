import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/Views/Mobile/homeView.dart';
import 'package:first/Views/Web/webMain.dart';
import 'package:first/Views/responsiveBuilder.dart';
import 'package:first/services/auth_service.dart';
import 'package:flutter/material.dart';

class VerficationUserView extends StatefulWidget {
  const VerficationUserView({super.key});

  @override
  State<VerficationUserView> createState() => _VerficationUserViewState();
}

class _VerficationUserViewState extends State<VerficationUserView> {
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.sendVerificationEmail();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.authUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user!.emailVerified) {
              return const Responsive(mobile: HomeView(), web: WebMain());
            } else {
              return Responsive(
                  mobile: mobileVerif(context), web: const WebMain());
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget mobileVerif(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xF5F5F5F5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Verificacion",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Hemos enviado un enlace de verificacion a tu correo electronico",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Volver a enviar el correo"),
            ),
          ),
        ],
      ),
    ));
  }
}
