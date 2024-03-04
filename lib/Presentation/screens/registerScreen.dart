// ignore_for_file: deprecated_member_use, file_names

import 'package:her_notes/Presentation/screens/singUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterBegginPage extends StatefulWidget {
  const RegisterBegginPage({super.key});

  @override
  State<RegisterBegginPage> createState() => _RegisterBegginPageState();
}

class _RegisterBegginPageState extends State<RegisterBegginPage> {
  bool? isPaciente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xF5F5F5F5),
          ),
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isPaciente = true;
                      });
                    },
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                            color: isPaciente == null
                                ? const Color.fromRGBO(63, 202, 206, 1)
                                : isPaciente!
                                    ? const Color.fromRGBO(63, 202, 206, 1)
                                    : const Color(0xF5F5F5F5)),
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "lib/Config/images/student.svg",
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  color: isPaciente == null
                                      ? Colors.white
                                      : isPaciente!
                                          ? Colors.white
                                          : Colors.black,
                                ),
                                Text("Soy un paciente",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      color: isPaciente == null
                                          ? Colors.white
                                          : isPaciente!
                                              ? Colors.white
                                              : const Color(0xFF000000),
                                    )),
                              ]),
                        )),
                  ),
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      isPaciente = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    decoration: BoxDecoration(
                        color: isPaciente == null
                            ? const Color(0xF5F5F5F5)
                            : isPaciente!
                                ? const Color(0xF5F5F5F5)
                                : const Color.fromRGBO(63, 202, 206, 1)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "lib/Config/images/professor.svg",
                              height: MediaQuery.of(context).size.height * 0.2,
                              color: isPaciente == null
                                  ? const Color(0xFF000000)
                                  : isPaciente!
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            Text("Soy un terapeuta",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    color: isPaciente == null
                                        ? const Color(0xFF000000)
                                        : isPaciente!
                                            ? Colors.black
                                            : Colors.white)),
                          ]),
                    ),
                  ),
                )),
              ],
            ),

            //make a positioned text that only appers when isPaciente is null and the text is "Selecciona una opción
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: 5,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  isPaciente == null
                      ? Container(
                          color: const Color.fromRGBO(63, 202, 206, 1),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Selecciona una opción",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ]),
        ),
        floatingActionButton: isPaciente == null
            ? null
            : FloatingActionButton(
                onPressed: () {
                  if (isPaciente!) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const SingUpView(mode: "Paciente");
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.easeInOutQuart;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const SingUpView(mode: "Doctor");
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.easeInOutQuart;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                },
                child: const Icon(Icons.arrow_forward),
              ));
  }
}
