import 'package:flutter/material.dart';
import 'package:her_notes/Presentation/screens/loginScreen.dart';
import 'package:her_notes/Presentation/screens/registerScreen.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';

class BegginScreen extends StatefulWidget {
  const BegginScreen({super.key});

  @override
  State<BegginScreen> createState() => _BegginScreenState();
}

class _BegginScreenState extends State<BegginScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(Widget page, {bool fromRight = true}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          if (!fromRight) {
            return FadeTransition(opacity: animation, child: child);
          }
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
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'HERNOTES',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            letterSpacing: 3.4,
                            color: palette.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      'Un espacio suave\npara lo que sientes',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 40,
                            height: 1.12,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Escribe, nombra tus emociones y, si quieres, comparte el camino con quien te acompaña.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.32,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(color: palette.line),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'lib/Config/images/her.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Spacer(),
                    HavenButton(
                      label: 'Entrar a mi diario',
                      icon: Icons.menu_book_rounded,
                      onPressed: () => _go(const LoginView()),
                    ),
                    const SizedBox(height: 12),
                    HavenButton(
                      label: 'Crear una cuenta',
                      variant: HavenButtonVariant.secondary,
                      onPressed: () =>
                          _go(const RegisterBegginPage(), fromRight: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
