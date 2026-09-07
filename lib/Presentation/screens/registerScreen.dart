import 'package:her_notes/Presentation/screens/singUpScreen.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterBegginPage extends StatefulWidget {
  const RegisterBegginPage({super.key});

  @override
  State<RegisterBegginPage> createState() => _RegisterBegginPageState();
}

class _RegisterBegginPageState extends State<RegisterBegginPage> {
  bool? isPaciente;

  void _continue() {
    if (isPaciente == null) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return SingUpView(mode: isPaciente! ? 'Paciente' : 'Doctor');
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return HavenAtmosphere(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HavenBackButton(),
                const SizedBox(height: 16),
                Text(
                  '¿Cómo quieres\nhabitar este espacio?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Elige el rol que mejor te representa. Podrás escribir o acompañar con la misma calma.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _RoleCard(
                          selected: isPaciente == true,
                          title: 'Quiero escribir',
                          subtitle:
                              'Un diario privado para nombrar emociones y, si lo deseas, vincularte con tu terapeuta.',
                          asset: 'lib/Config/images/student.svg',
                          tint: palette.primarySoft,
                          iconColor: palette.primary,
                          onTap: () => setState(() => isPaciente = true),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: _RoleCard(
                          selected: isPaciente == false,
                          title: 'Quiero acompañar',
                          subtitle:
                              'Un espacio para seguir a tus pacientes, dejar ejercicios y leer su proceso con respeto.',
                          asset: 'lib/Config/images/professor.svg',
                          tint: palette.accentSoft,
                          iconColor: palette.accent,
                          onTap: () => setState(() => isPaciente = false),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                HavenButton(
                  label: isPaciente == null
                      ? 'Elige una forma de entrar'
                      : isPaciente!
                          ? 'Continuar como paciente'
                          : 'Continuar como terapeuta',
                  onPressed: isPaciente == null ? null : _continue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final String asset;
  final Color tint;
  final Color iconColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.tint,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? tint : palette.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: selected ? iconColor.withOpacity(0.45) : palette.line,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: SvgPicture.asset(
                asset,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: selected ? iconColor : palette.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}
