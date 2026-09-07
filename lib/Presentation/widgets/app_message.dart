import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';

void showHavenMessage(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final palette = havenPalette(context, listen: false);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? palette.danger : palette.ink,
    ),
  );
}

class HavenBackButton extends StatelessWidget {
  const HavenBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.line),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: palette.ink,
          size: 20,
        ),
      ),
    );
  }
}

class HavenIconWell extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const HavenIconWell({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.line),
        ),
        child: Icon(icon, color: palette.ink, size: 20),
      ),
    );
  }
}
