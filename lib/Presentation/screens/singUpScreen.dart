// ignore_for_file: file_names, use_build_context_synchronously
import 'package:her_notes/Config/utils/validateEmailFuction.dart';
import 'package:her_notes/Domain/models/doctor_model.dart';
import 'package:her_notes/Domain/models/login_model.dart';
import 'package:her_notes/Domain/models/model_for_control_usertype.dart';
import 'package:her_notes/Domain/models/user_model.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notifications_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/setterView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingUpView extends StatefulWidget {
  final String mode;
  const SingUpView({Key? key, required this.mode}) : super(key: key);

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  bool loading = false;
  bool obscureText = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();

  void singIn(UserProvider userProvider, BuildContext context,
      NotificationsProvider notificationsProvider) async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Las contraseñas no coinciden"),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          loading = false;
        });
        return;
      }

      if (!validateEmail(emailController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Por favor ingresa un correo valido"),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          loading = false;
        });
        return;
      }

      if (widget.mode == "Doctor" && cedulaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Por favor llena el campo de cedula profesional"),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          loading = false;
        });
        return;
      }

      if (widget.mode == "Paciente") {
        UserModel user = UserModel(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            token: notificationsProvider.token ?? 'tokenForPaciente');

        final result = await userProvider.singUpPaciente(user);

        if (result != null) {
          Login loginModel = Login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          ModelForControlUsertype? response =
              await userProvider.login(loginModel);

          if (response != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SetterView(
                        userProvider: userProvider,
                      )),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Error al registrarse, por favor intenta de nuevo"),
                duration: Duration(seconds: 2),
              ),
            );

            setState(() {
              loading = false;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error al registrarse, por favor intenta de nuevo"),
              duration: Duration(seconds: 2),
            ),
          );

          setState(() {
            loading = false;
          });
        }
      }
      if (widget.mode == "Doctor") {
        DoctorModel doctor = DoctorModel(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            cedulaProfesional: cedulaController.text,
            token: notificationsProvider.token ?? "tokenForDoctor");
        final result = await userProvider.singUpDoctor(doctor);

        if (result != null) {
          Login loginModel = Login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          ModelForControlUsertype? response =
              await userProvider.login(loginModel);
          if (response != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SetterView(
                        userProvider: userProvider,
                      )),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Error al registrarse, por favor intenta de nuevo"),
                duration: Duration(seconds: 2),
              ),
            );

            setState(() {
              loading = false;
            });
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al registrarse, por favor intenta de nuevo"),
            duration: Duration(seconds: 2),
          ),
        );

        setState(() {
          loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor llena todos los campos"),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    NotificationsProvider notificationsProvider =
        Provider.of<NotificationsProvider>(context);

    if (widget.mode == "Paciente") {
      return pacienteUserSingUp(
          context,
          nameController,
          emailController,
          passwordController,
          confirmPasswordController,
          singIn,
          loading,
          doctorProvider,
          userProvider,
          () => setState(() {
                loading = true;
              }),
          obscureText, () {
        setState(() {
          obscureText = !obscureText;
        });
      }, notificationsProvider);
    } else {
      return doctorUserSingUp(
          context,
          nameController,
          emailController,
          passwordController,
          confirmPasswordController,
          cedulaController,
          singIn,
          loading,
          doctorProvider,
          userProvider,
          () => setState(() {
                loading = true;
              }),
          obscureText, () {
        setState(() {
          obscureText = !obscureText;
        });
      }, notificationsProvider);
    }
  }
}

Widget pacienteUserSingUp(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    Function singIn,
    bool loading,
    DoctorProvider doctorProvider,
    UserProvider userProvider,
    Function setState,
    bool obscureText,
    Function? oscureConfirmText,
    NotificationsProvider notificationsProvider) {
  return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xF5F5F5F5),
      ),
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
                width: 150,
                height: 150,
                child: Image.asset("lib/Config/images/her_head_.png"),
              ),
              const SizedBox(
                height: 20,
              ),
              textFieldWidget(
                  context,
                  "Nombre",
                  nameController,
                  const Icon(Icons.person,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  null,
                  null),
              const SizedBox(
                height: 50,
              ),
              textFieldWidget(
                  context,
                  "Correo electrónico",
                  emailController,
                  const Icon(Icons.email,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  null,
                  null),
              const SizedBox(
                height: 40,
              ),
              textFieldWidget(
                  context,
                  "Contraseña",
                  passwordController,
                  const Icon(Icons.lock,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  oscureConfirmText,
                  obscureText),
              const SizedBox(
                height: 50,
              ),
              textFieldWidget(
                  context,
                  "Confirmar contraseña",
                  confirmPasswordController,
                  const Icon(Icons.lock,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  oscureConfirmText,
                  obscureText),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  setState();
                  singIn(userProvider, context, notificationsProvider);
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

Widget doctorUserSingUp(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    TextEditingController cedulaController,
    Function singIn,
    bool loading,
    DoctorProvider doctorProvider,
    UserProvider userProvider,
    Function? setState,
    bool obscureText,
    Function? oscureConfirmText,
    NotificationsProvider notificationsProvider) {
  return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xF5F5F5F5),
      ),
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
                width: 150,
                height: 150,
                child: Image.asset("lib/Config/images/her_head_.png"),
              ),
              const SizedBox(
                height: 20,
              ),
              textFieldWidget(
                  context,
                  "Nombre",
                  nameController,
                  const Icon(
                    Icons.person,
                    color: Color.fromRGBO(63, 202, 206, 1),
                  ),
                  null,
                  null),
              const SizedBox(
                height: 50,
              ),
              textFieldWidget(
                  context,
                  "Correo electrónico",
                  emailController,
                  const Icon(Icons.email,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  null,
                  null),
              const SizedBox(
                height: 40,
              ),
              textFieldWidget(
                  context,
                  "Cedula Profesional",
                  cedulaController,
                  const Icon(Icons.file_copy,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  null,
                  null),
              const SizedBox(
                height: 40,
              ),
              textFieldWidget(
                  context,
                  "Contraseña",
                  passwordController,
                  const Icon(Icons.lock,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  oscureConfirmText,
                  obscureText),
              const SizedBox(
                height: 40,
              ),
              textFieldWidget(
                  context,
                  "Confirmar contraseña",
                  confirmPasswordController,
                  const Icon(Icons.lock,
                      color: Color.fromRGBO(63, 202, 206, 1)),
                  oscureConfirmText,
                  obscureText),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  setState!();
                  singIn(userProvider, context, notificationsProvider);
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
    BuildContext context,
    String text,
    TextEditingController controller,
    Icon? icon,
    Function? setState,
    bool? obscureText) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05),
    child: SizedBox(
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
                obscureText: obscureText ?? false,
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
                  icon: icon,
                ),
              ),
            ),
            text == "Contraseña"
                ? IconButton(
                    onPressed: () {
                      setState!();
                    },
                    icon: Icon(
                      obscureText! ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromRGBO(63, 202, 206, 1),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ]),
    ),
  );
}
