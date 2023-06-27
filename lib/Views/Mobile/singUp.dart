// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../Web/webMain.dart';
import '../guia.dart';
import '../responsiveBuilder.dart';

class SingUpView extends StatefulWidget {
  const SingUpView({Key? key}) : super(key: key);

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  bool loading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void singIn() async {
    setState(() {
      loading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      String res = await AuthService().singUpUser(
        email: email,
        password: password,
        name: name,
      );

      if (res == "Signed up") {
        setState(() {
          loading = false;
        });

        // UserProvider user =
        //     // ignore: use_build_context_synchronously
        //     Provider.of<UserProvider>(context, listen: false);

        // await user.setUser();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const GuiaView(ruta: 'verificacion')));
      } else {
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: mobileSingUp(context, emailController, passwordController,
            nameController, singIn, loading),
        web: const WebMain());
  }
}

Widget mobileSingUp(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController nameController,
    Function singIn,
    bool loading) {
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
          textFieldWidget(context, "Nombre", nameController),
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
            onPressed: () => singIn(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(63, 202, 206, 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
          ),
          const SizedBox(
            height: 35,
          ),
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
