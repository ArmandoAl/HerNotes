import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';

/// Keeps the journal at a humane, phone-like width on large screens.
class HavenViewport extends StatelessWidget {
  final Widget child;
  const HavenViewport({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 640) return child;
        final frameHeight = math.min(constraints.maxHeight - 40, 880.0);
        return ColoredBox(
          color: palette.backgroundAlt,
          child: Center(
            child: Container(
              width: 420,
              height: frameHeight,
              decoration: BoxDecoration(
                color: palette.background,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: palette.line),
                boxShadow: [
                  BoxShadow(
                    color: palette.shadow,
                    blurRadius: 48,
                    offset: const Offset(0, 22),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
