// ignore_for_file: file_names

import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/screens/loginScreen.dart';
import 'package:her_notes/Presentation/screens/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BegginScreen extends StatefulWidget {
  const BegginScreen({super.key});

  @override
  State<BegginScreen> createState() => _BegginScreenState();
}

class _BegginScreenState extends State<BegginScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
        //I want a fade animation here when the app starts that appers this asset lib/Config/images/her.gif
        decoration: const BoxDecoration(
          color: Color.fromARGB(245, 255, 255, 255),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
                opacity: _animation,
                child: Text(
                  'Bienvenido a Your Notes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                )),
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'lib/Config/images/her.gif',
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(63, 202, 206, 1),
                        elevation: 10,
                      ),
                      onPressed: () {
                        //navigate with animation
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimation,
                                  Widget child) {
                                //other animation
                                //slide from right to left
                                return SlideTransition(
                                  position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero)
                                      .animate(animation),
                                  child: child,
                                );
                              },
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimation) {
                                return const LoginView();
                              }),
                        );
                      },
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.light["backgroundColor"],
                      elevation: 10,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const RegisterBegginPage();
                          },
                          //fade animation
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ));
  }
}
