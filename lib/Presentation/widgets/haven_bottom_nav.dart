import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';

class HavenBottomNav extends StatelessWidget {
  final int index;
  final bool isDoctor;
  final ValueChanged<int> onChanged;

  const HavenBottomNav({
    super.key,
    required this.index,
    required this.isDoctor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    final items = isDoctor
        ? const [
            _NavSpec(Icons.people_alt_outlined, Icons.people_alt_rounded,
                'Pacientes'),
            _NavSpec(Icons.insights_outlined, Icons.insights_rounded, 'Mapa'),
            _NavSpec(
                Icons.tune_outlined, Icons.tune_rounded, 'Espacio'),
          ]
        : const [
            _NavSpec(Icons.menu_book_outlined, Icons.menu_book_rounded, 'Diario'),
            _NavSpec(Icons.insights_outlined, Icons.insights_rounded, 'Mapa'),
            _NavSpec(
                Icons.tune_outlined, Icons.tune_rounded, 'Espacio'),
          ];

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: palette.navBar,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: palette.line),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = index == i;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? palette.primarySoft
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? items[i].active : items[i].idle,
                        color: selected ? palette.primaryDeep : palette.inkFaint,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: selected
                                  ? palette.primaryDeep
                                  : palette.inkFaint,
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavSpec {
  final IconData idle;
  final IconData active;
  final String label;
  const _NavSpec(this.idle, this.active, this.label);
}
