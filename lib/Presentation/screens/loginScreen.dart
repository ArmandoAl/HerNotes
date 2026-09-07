// ignore_for_file: use_build_context_synchronously
import 'package:her_notes/Data/mocks/mock_credentials.dart';
import 'package:her_notes/Domain/models/login_model.dart';
import 'package:her_notes/Domain/models/model_for_control_usertype.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/setterView.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:her_notes/Presentation/widgets/haven_text_field.dart';
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
  bool obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login({bool asDoctor = false}) async {
    setState(() {
      if (asDoctor) {
        doctorLoading = true;
      } else {
        loading = true;
      }
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showHavenMessage(context, 'Toma aire. Falta completar algunos campos.',
          isError: true);
      setState(() {
        loading = false;
        doctorLoading = false;
      });
      return;
    }

    if (validateEmail(emailController.text.trim()) == false) {
      showHavenMessage(context, 'Revisa el correo para poder entrar.',
          isError: true);
      setState(() {
        loading = false;
        doctorLoading = false;
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final Login loginModel = Login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    final ModelForControlUsertype? response =
        await userProvider.login(loginModel);
    if (response != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetterView(userProvider: userProvider),
        ),
      );
    } else {
      setState(() {
        loading = false;
        doctorLoading = false;
      });
      showHavenMessage(
        context,
        'No pudimos entrar. Revisa tu correo y contraseña.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return HavenAtmosphere(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: HavenBackButton(),
              ),
              const SizedBox(height: 18),
              Text(
                'Qué bueno\nverte de nuevo',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Entra con calma. Tu diario te espera exactamente donde lo dejaste.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: palette.line),
                ),
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: palette.primarySoft,
                        backgroundImage: const AssetImage(
                          'lib/Config/images/her_head.png',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    HavenTextField(
                      label: 'Correo',
                      hint: 'tu@correo.com',
                      controller: emailController,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    HavenTextField(
                      label: 'Contraseña',
                      controller: passwordController,
                      icon: Icons.lock_outline_rounded,
                      obscureText: obscureText,
                      onToggleObscure: () {
                        setState(() => obscureText = !obscureText);
                      },
                    ),
                    const SizedBox(height: 22),
                    HavenButton(
                      label: 'Entrar',
                      loading: loading && !doctorLoading,
                      onPressed: () => login(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                '¿Solo quieres explorar?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'La demo usa ${MockCredentials.studentEmail} o ${MockCredentials.teacherEmail}.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: HavenButton(
                      label: 'Soy paciente',
                      variant: HavenButtonVariant.secondary,
                      loading: loading && !doctorLoading,
                      onPressed: () {
                        emailController.text = MockCredentials.studentEmail;
                        passwordController.text =
                            MockCredentials.studentPassword;
                        login();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HavenButton(
                      label: 'Soy terapeuta',
                      variant: HavenButtonVariant.secondary,
                      loading: doctorLoading,
                      onPressed: () {
                        emailController.text = MockCredentials.teacherEmail;
                        passwordController.text =
                            MockCredentials.teacherPassword;
                        login(asDoctor: true);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
