// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore
import 'package:first/Views/Mobile/singUp.dart';
import 'package:first/models/login_model.dart';
import 'package:first/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(BuildContext context, UserProvider userProvider) async {
    setState(() {
      loading = true;
    });

    Login loginModel = Login(
      email: emailController.text,
      password: passwordController.text,
    );

    final response = userProvider.login(loginModel);

    // ignore: unnecessary_null_comparison
    if (response != null) {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar sesión'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return mobileLogin(context, emailController, passwordController, login,
        loading, userProvider);
  }
}

Widget mobileLogin(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    Function login,
    bool loading,
    UserProvider userProvider) {
  return Scaffold(
      body: Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      color: Color(0xF5F5F5F5),
    ),
    child: ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset("lib/images/her_head.png"),
          ),
          const SizedBox(
            height: 50,
          ),
          textFieldWidget(context, "Correo electrónico", emailController),
          const SizedBox(
            height: 40,
          ),
          textFieldWidget(context, "Contraseña", passwordController),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              login(context, userProvider);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(63, 202, 206, 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator()
                : const Text(
                    "Iniciar sesión",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
          ),
          const SizedBox(
            height: 35,
          ),
          const Text(
            "¿No tienes cuenta?",
            style: TextStyle(
              color: Color.fromRGBO(30, 82, 84, 1),
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SingUpView()));
              },
              child: const Text(
                "Regístrate",
                style: TextStyle(
                  color: Color.fromRGBO(63, 202, 206, 1),
                  fontSize: 20,
                ),
              )),
        ],
      ),
    ]),
  ));
}

Widget textFieldWidget(
    BuildContext context, String text, TextEditingController controller) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    height: 80,
    child: Column(children: <Widget>[
      Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Color.fromRGBO(63, 202, 206, 1),
              fontSize: 20,
            ),
          ),
          const Spacer(),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              fillColor: const Color.fromRGBO(63, 202, 206, 1),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Color.fromRGBO(63, 202, 206, 1),
                ),
              ),
              icon: const Icon(
                Icons.email,
                color: Color.fromRGBO(63, 202, 206, 1),
              ),
              labelText: text,
            ),
          )),
    ]),
  );
}
