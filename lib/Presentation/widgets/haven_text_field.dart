import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';

class HavenTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final IconData? icon;
  final TextInputType? keyboardType;
  final int maxLines;

  const HavenTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscureText = false,
    this.onToggleObscure,
    this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.inkSoft,
                letterSpacing: 0.4,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint ?? label,
            prefixIcon: icon == null
                ? null
                : Icon(icon, color: palette.primary, size: 22),
            suffixIcon: onToggleObscure == null
                ? null
                : IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: palette.inkSoft,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
