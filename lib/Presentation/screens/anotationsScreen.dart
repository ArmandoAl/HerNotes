import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:flutter/material.dart';

class AnotationsView extends StatefulWidget {
  final String? anotations;
  final NotesProvider notesProvider;
  final int idNote;
  const AnotationsView({
    super.key,
    required this.anotations,
    required this.notesProvider,
    required this.idNote,
  });

  @override
  State<AnotationsView> createState() => _AnotationsViewState();
}

class _AnotationsViewState extends State<AnotationsView> {
  final TextEditingController anotationsController = TextEditingController();

  @override
  void initState() {
    anotationsController.text = widget.anotations ?? '';
    super.initState();
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
                Row(
                  children: [
                    const HavenBackButton(),
                    const Spacer(),
                    HavenButton(
                      label: 'Guardar nota',
                      expanded: false,
                      icon: Icons.check_rounded,
                      onPressed: () {
                        widget.notesProvider.addNotations(
                          anotationsController.text,
                          widget.idNote,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Una nota para la persona',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Escribe con respeto clínico. Esta nota vive junto a su página, no encima.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: palette.line),
                    ),
                    child: TextField(
                      controller: anotationsController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(height: 1.65),
                      decoration: const InputDecoration(
                        hintText: 'Lo que observas, con suavidad...',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
