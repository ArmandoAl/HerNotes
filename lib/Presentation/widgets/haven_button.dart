import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';

enum HavenButtonVariant { primary, secondary, ghost, accent }

class HavenButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final HavenButtonVariant variant;
  final IconData? icon;
  final bool expanded;

  const HavenButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.variant = HavenButtonVariant.primary,
    this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    late Color background;
    late Color foreground;
    late BorderSide border;

    switch (variant) {
      case HavenButtonVariant.primary:
        background = palette.primary;
        foreground = palette.onPrimary;
        border = BorderSide.none;
        break;
      case HavenButtonVariant.secondary:
        background = palette.surface;
        foreground = palette.ink;
        border = BorderSide(color: palette.line);
        break;
      case HavenButtonVariant.ghost:
        background = Colors.transparent;
        foreground = palette.primaryDeep;
        border = BorderSide.none;
        break;
      case HavenButtonVariant.accent:
        background = palette.accent;
        foreground = palette.isDark ? palette.ink : const Color(0xFFFFFBF7);
        border = BorderSide.none;
        break;
    }

    final child = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foreground,
                    ),
              ),
            ],
          );

    return SizedBox(
      width: expanded ? double.infinity : null,
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background.withOpacity(0.7),
          side: border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: child,
      ),
    );
  }
}
