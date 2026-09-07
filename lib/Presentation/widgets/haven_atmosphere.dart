import 'package:flutter/material.dart';
import 'package:her_notes/Config/theme/app_palette.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';

class HavenAtmosphere extends StatelessWidget {
  final Widget child;
  const HavenAtmosphere({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                palette.background,
                palette.backgroundAlt,
                palette.background,
              ],
            ),
          ),
        ),
        IgnorePointer(
          child: CustomPaint(
            painter: _AtmospherePainter(palette),
            size: Size.infinite,
          ),
        ),
        child,
      ],
    );
  }
}

class _AtmospherePainter extends CustomPainter {
  final AppPalette palette;
  _AtmospherePainter(this.palette);

  @override
  void paint(Canvas canvas, Size size) {
    final sage = Paint()..color = palette.blobSage;
    final rose = Paint()..color = palette.blobRose;
    final sand = Paint()..color = palette.blobSand;

    canvas.drawCircle(Offset(size.width * 0.12, size.height * 0.08), 140, sage);
    canvas.drawCircle(Offset(size.width * 0.95, size.height * 0.18), 160, rose);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.92), 180, sand);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.72), 110, sage);
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter oldDelegate) {
    return oldDelegate.palette != palette;
  }
}
