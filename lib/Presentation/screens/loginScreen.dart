// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore, unused_import
import 'package:her_notes/Domain/models/login_model.dart';
import 'package:her_notes/Domain/models/model_for_control_usertype.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/setterView.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Config/utils/validateEmailFuction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool loading = false;
  bool doctorLoading = false;
  bool oscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(BuildContext context, UserProvider userProvider,
      DoctorProvider doctorProvider) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por favor, llene todos los campos"),
      ));
      setState(() {
        loading = false;
        doctorLoading = false;
      });
      return;
    }

    if (validateEmail(emailController.text.trim()) == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por favor, ingrese un correo válido"),
      ));
      setState(() {
        loading = false;
        doctorLoading = false;
      });
      return;
    }

    Login loginModel = Login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    ModelForControlUsertype? response = await userProvider.login(loginModel);
    if (response != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SetterView(
                  userProvider: userProvider,
                )),
      );
    } else {
      setState(() {
        loading = false;
        doctorLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar sesión'),
        ),
      );
    }
  }

  void changeControllerContent(String email, String password) {
    setState(() {
      emailController.text = email;
      passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return mobileLogin(
        context,
        emailController,
        passwordController,
        login,
        loading,
        userProvider,
        doctorProvider,
        changeControllerContent,
        () {
          setState(() {
            loading = true;
          });
        },
        () {
          setState(() {
            doctorLoading = true;
          });
        },
        theme,
        oscureText,
        () {
          setState(() {
            oscureText = !oscureText;
          });
        });
  }

  Widget mobileLogin(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      Function login,
      bool loading,
      UserProvider userProvider,
      DoctorProvider doctorProvider,
      Function changeControllerContent,
      Function setState,
      Function setDoctorState,
      ThemeProvider theme,
      bool oscureText,
      Function changeOscureText) {
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.18,
                backgroundImage: theme.isDarkModeEnabled
                    ? const AssetImage('lib/Config/images/her_head.png')
                    : const AssetImage('lib/Config/images/her_head.png'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            textFieldWidget(
                context, "Correo electrónico", emailController, null, null),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            textFieldWidget(context, "Contraseña", passwordController,
                oscureText, changeOscureText),
            const SizedBox(
              height: 50,
            ),
            // Padding(
            //   padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            //   child: Text(
            //     "Hola, si estas viendo esto es porque vienes de linkedin o de mi portafolio, asi que muchas gracias por interesarte en mi trabajo, esta aplicacion tiene un uso real, pero para fines practicos, puedes iniciar sesion con de manera rapida con estos usuarios de prueba",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontSize: MediaQuery.of(context).size.width * 0.03),
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     changeControllerContent(
            //       "paciente@gmail.com",
            //       "paciente",
            //     );
            //     setState();
            //     login(context, userProvider, doctorProvider);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.all(20),
            //     foregroundColor: Colors.white,
            //     backgroundColor: const Color.fromRGBO(63, 202, 206, 1),
            //     shape: const RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(15)),
            //     ),
            //   ),
            //   child: loading
            //       ? const CircularProgressIndicator()
            //       : const Text(
            //           "Iniciar como paciente",
            //           style: TextStyle(
            //             fontSize: 20,
            //           ),
            //         ),
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.05,
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     changeControllerContent("doctor@gmail.com", "doctor");
            //     setDoctorState();
            //     login(context, userProvider, doctorProvider);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.all(20),
            //     foregroundColor: Colors.white,
            //     backgroundColor: const Color.fromRGBO(63, 202, 206, 1),
            //     shape: const RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(15)),
            //     ),
            //   ),
            //   child: doctorLoading
            //       ? const CircularProgressIndicator()
            //       : const Text(
            //           "Iniciar como doctor",
            //           style: TextStyle(
            //             fontSize: 20,
            //           ),
            //         ),
            // ),

            ElevatedButton(
              onPressed: () {
                setState();
                login(context, userProvider, doctorProvider);
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
          ],
        ),
      ]),
    ));
  }

  Widget textFieldWidget(
      BuildContext context,
      String text,
      TextEditingController controller,
      bool? oscureText,
      Function? changeOscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.12,
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
        Row(
          children: [
            Expanded(
                child: TextField(
              obscureText: oscureText ?? false,
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
                icon: Icon(
                  text == "Correo electrónico" ? Icons.email : Icons.lock,
                  color: const Color.fromRGBO(63, 202, 206, 1),
                ),
                labelText: text,
              ),
            )),
            oscureText != null
                ? IconButton(
                    onPressed: () {
                      changeOscureText!();
                    },
                    icon: Icon(
                      oscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color.fromRGBO(63, 202, 206, 1),
                    ),
                  )
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ]),
    );
  }
}
