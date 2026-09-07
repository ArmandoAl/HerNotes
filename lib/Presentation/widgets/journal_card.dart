import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Presentation/widgets/emotion_chip.dart';
import 'package:intl/intl.dart';

class JournalCard extends StatelessWidget {
  final NotesModel note;
  final VoidCallback? onTap;
  final Widget? trailingAction;
  const JournalCard({
    super.key,
    required this.note,
    this.onTap,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    final date = note.fecha;
    final timeLabel = date == null
        ? ''
        : DateFormat('HH:mm').format(date.toLocal());
    final preview = note.content.texto ?? '';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: note.selected ? palette.primary : palette.line,
            width: note.selected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title.isEmpty ? 'Sin título' : note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 22,
                        ),
                  ),
                ),
                Text(
                  timeLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              preview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.inkSoft,
                    height: 1.55,
                  ),
            ),
            if (note.emociones != null && note.emociones!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: note.emociones!
                    .map((e) => EmotionChip(emotion: e, compact: true))
                    .toList(),
              ),
            ],
            if (trailingAction != null) ...[
              const SizedBox(height: 12),
              trailingAction!,
            ],
          ],
        ),
      ),
    );
  }
}
