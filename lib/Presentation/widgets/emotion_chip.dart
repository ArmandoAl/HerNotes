import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/emocion_colors.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Domain/models/emocion_model.dart';

class EmotionChip extends StatelessWidget {
  final EmocionModel emotion;
  final bool compact;
  const EmotionChip({
    super.key,
    required this.emotion,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = emotionColorOf(emotion.emocionBase);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            emotionIconOf(emotion.emocionBase),
            size: compact ? 11 : 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            emotion.tipo,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 11 : 12,
                ),
          ),
        ],
      ),
    );
  }
}

class SelectableEmotionChip extends StatelessWidget {
  final EmocionModel emotion;
  final VoidCallback onTap;
  const SelectableEmotionChip({
    super.key,
    required this.emotion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    final color = emotionColorOf(emotion.emocionBase);
    final selected = emotion.selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.28),
          ),
        ),
        child: Text(
          emotion.tipo,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? Colors.white : palette.ink,
                fontSize: 13,
              ),
        ),
      ),
    );
  }
}
