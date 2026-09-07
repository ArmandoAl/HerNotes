// ignore_for_file: use_build_context_synchronously
import 'package:her_notes/Config/utils/validateEmailFuction.dart';
import 'package:her_notes/Domain/models/doctor_model.dart';
import 'package:her_notes/Domain/models/login_model.dart';
import 'package:her_notes/Domain/models/model_for_control_usertype.dart';
import 'package:her_notes/Domain/models/user_model.dart';
import 'package:her_notes/Presentation/provider/notifications_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/setterView.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:her_notes/Presentation/widgets/haven_text_field.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController cedulaController = TextEditingController();

  bool get isPaciente => widget.mode == 'Paciente';

  Future<void> singIn() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);

    setState(() => loading = true);

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      showHavenMessage(context, 'Falta completar algunos campos.',
          isError: true);
      setState(() => loading = false);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showHavenMessage(context, 'Las contraseñas aún no coinciden.',
          isError: true);
      setState(() => loading = false);
      return;
    }

    if (!validateEmail(emailController.text.trim())) {
      showHavenMessage(context, 'Ese correo no parece válido.', isError: true);
      setState(() => loading = false);
      return;
    }

    if (!isPaciente && cedulaController.text.isEmpty) {
      showHavenMessage(context, 'Necesitamos tu cédula profesional.',
          isError: true);
      setState(() => loading = false);
      return;
    }

    if (isPaciente) {
      final user = UserModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        token: notificationsProvider.token ?? 'tokenForPaciente',
      );
      final result = await userProvider.singUpPaciente(user);
      if (result != null) {
        await _loginAfterSignUp(userProvider);
        return;
      }
    } else {
      final doctor = DoctorModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        cedulaProfesional: cedulaController.text,
        token: notificationsProvider.token ?? 'tokenForDoctor',
      );
      final result = await userProvider.singUpDoctor(doctor);
      if (result != null) {
        await _loginAfterSignUp(userProvider);
        return;
      }
    }

    showHavenMessage(
      context,
      'No pudimos crear la cuenta. Inténtalo otra vez.',
      isError: true,
    );
    setState(() => loading = false);
  }

  Future<void> _loginAfterSignUp(UserProvider userProvider) async {
    final loginModel = Login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    final ModelForControlUsertype? response =
        await userProvider.login(loginModel);
    if (response != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SetterView(userProvider: userProvider),
        ),
        (route) => false,
      );
    } else {
      showHavenMessage(
        context,
        'La cuenta se creó, pero no pudimos entrar. Prueba iniciar sesión.',
        isError: true,
      );
      setState(() => loading = false);
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
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.primarySoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isPaciente ? 'Cuenta de paciente' : 'Cuenta de terapeuta',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: palette.primaryDeep,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isPaciente
                    ? 'Vamos a preparar\ntu diario'
                    : 'Vamos a preparar\ntu consultorio',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Solo lo esencial. Después el espacio es tuyo.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: palette.line),
                ),
                child: Column(
                  children: [
                    HavenTextField(
                      label: 'Nombre',
                      controller: nameController,
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    HavenTextField(
                      label: 'Correo',
                      controller: emailController,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (!isPaciente) ...[
                      const SizedBox(height: 16),
                      HavenTextField(
                        label: 'Cédula profesional',
                        controller: cedulaController,
                        icon: Icons.badge_outlined,
                      ),
                    ],
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
                    const SizedBox(height: 16),
                    HavenTextField(
                      label: 'Confirmar contraseña',
                      controller: confirmPasswordController,
                      icon: Icons.lock_outline_rounded,
                      obscureText: obscureText,
                    ),
                    const SizedBox(height: 22),
                    HavenButton(
                      label: 'Crear mi espacio',
                      loading: loading,
                      onPressed: singIn,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
