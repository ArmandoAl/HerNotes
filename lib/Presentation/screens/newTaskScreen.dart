// ignore_for_file: use_build_context_synchronously
import 'package:her_notes/Domain/models/task_model.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteNewTask extends StatefulWidget {
  final int pacienteId;
  const WriteNewTask({super.key, required this.pacienteId});

  @override
  State<WriteNewTask> createState() => _WriteNewTaskState();
}

class _WriteNewTaskState extends State<WriteNewTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String pacienteName = '';
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    pacienteName = doctorProvider.getPacienteName(widget.pacienteId) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final palette = havenPalette(context);
    final first = pacienteName.split(' ').first;

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
                      label: 'Enviar',
                      expanded: false,
                      loading: saving,
                      icon: Icons.send_rounded,
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            contentController.text.isEmpty) {
                          showHavenMessage(
                            context,
                            'Necesitamos un título y una invitación para escribir.',
                            isError: true,
                          );
                          return;
                        }
                        setState(() => saving = true);
                        final task = TaskModel(
                          title: titleController.text,
                          content: contentController.text,
                          isDone: false,
                        );
                        await doctorProvider.sendNewTask(
                            task, widget.pacienteId);
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Un ejercicio para $first',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Invita, no impongas. Una pregunta abierta suele abrir más que una orden.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: palette.line),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          style: Theme.of(context).textTheme.headlineSmall,
                          decoration: const InputDecoration(
                            hintText: 'Título del ejercicio',
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Divider(color: palette.line),
                        Expanded(
                          child: TextField(
                            controller: contentController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(height: 1.65),
                            decoration: const InputDecoration(
                              hintText:
                                  'Describe la invitación. Qué observar, qué sentir, qué escribir...',
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
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
