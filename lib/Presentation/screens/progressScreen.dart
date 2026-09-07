import 'package:her_notes/Domain/models/emocion_model.dart';
import 'package:her_notes/Domain/models/notes_model.dart';
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Config/utils/emocion_colors.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/screens/main_shell.dart';
import 'package:her_notes/Presentation/widgets/empty_state.dart';
import 'package:her_notes/Presentation/widgets/haven_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgresoView extends StatefulWidget {
  const ProgresoView({Key? key}) : super(key: key);

  @override
  State<ProgresoView> createState() => _ProgresoViewState();
}

class _ProgresoViewState extends State<ProgresoView> {
  int? itemPressed;
  int weekSelected = 0;
  int? selectedPacienteId;

  List<String> calculateWeeks(List<NotesModel> notes) {
    final weeks = <String>[];
    for (int i = 0; i < notes.length; i++) {
      if (i == 0) {
        weeks.add('Semana 1');
      } else {
        final weekNumber =
            notes[i].fecha!.difference(notes[0].fecha!).inDays ~/ 7 + 1;
        if (weekNumber > weeks.length) {
          weeks.add('Semana $weekNumber');
        }
      }
    }
    if (weeks.isEmpty) weeks.add('Semana 1');
    return weeks;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (notesProvider.notes.isNotEmpty) return;

      if (userProvider.user!.usertype == 'doctor') {
        final doctorProvider =
            Provider.of<DoctorProvider>(context, listen: false);
        if (doctorProvider.doctor?.pacientes == null) {
          await doctorProvider.getPacientes();
        }
        final pacientes = doctorProvider.doctor?.pacientes;
        if (pacientes != null && pacientes.isNotEmpty) {
          selectedPacienteId = pacientes[0].id;
          await notesProvider.getNotes(pacientes[0].id!);
        } else {
          notesProvider.markLoaded();
        }
      } else {
        await notesProvider.getNotes(userProvider.user!.user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final palette = havenPalette(context);
    final weeks = calculateWeeks(notesProvider.notes);
    if (weekSelected >= weeks.length) weekSelected = 0;
    final isDoctor = userProvider.user!.usertype == 'doctor';

    if (notesProvider.loading) {
      return const HavenLoader(message: 'Leyendo tu mapa emocional...');
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HavenPageHeader(
                kicker: 'Mapa emocional',
                title: isDoctor ? 'El clima interior' : 'Tu clima interior',
                subtitle: 'Mira cómo se mueven las emociones a lo largo de los días.',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isDoctor)
                    Expanded(
                      child: _HavenSelect<int>(
                        value: selectedPacienteId ??
                            doctorProvider.doctor?.pacientes?.firstOrNull?.id,
                        items: (doctorProvider.doctor?.pacientes ?? [])
                            .map(
                              (p) => DropdownMenuItem(
                                value: p.id,
                                child: Text(p.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedPacienteId = value;
                            itemPressed = null;
                            weekSelected = 0;
                          });
                          notesProvider.getNotes(value);
                        },
                      ),
                    ),
                  if (isDoctor) const SizedBox(width: 10),
                  Expanded(
                    child: _HavenSelect<int>(
                      value: weekSelected,
                      items: [
                        for (int i = 0; i < weeks.length; i++)
                          DropdownMenuItem(
                            value: i,
                            child: Text(weeks[i]),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          weekSelected = value;
                          itemPressed = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (notesProvider.notes.isEmpty)
                const Expanded(
                  child: HavenEmptyState(
                    icon: Icons.insights_rounded,
                    title: 'Aún no hay un mapa',
                    subtitle:
                        'Cuando existan páginas en el diario, aquí verás el pulso emocional de cada día.',
                  ),
                )
              else ...[
                SizedBox(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: _notesItems(notesProvider, weekSelected),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: palette.line),
                    ),
                    child: SingleChildScrollView(
                      child: itemPressed == null
                          ? _legend(context)
                          : _noteDetail(
                              context,
                              notesProvider,
                              itemPressed!,
                              isDoctor,
                            ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _legend(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Simbología suave',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          'Cada color es una familia emocional. Toca una columna para leer el día.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: emotionColors.keys.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: emotionColorOf(e).withOpacity(0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(emotionIconOf(e), size: 16, color: emotionColorOf(e)),
                  const SizedBox(width: 6),
                  Text(
                    e,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: emotionColorOf(e),
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _noteDetail(
    BuildContext context,
    NotesProvider notesProvider,
    int index,
    bool isDoctor,
  ) {
    final note = notesProvider.notes[index];
    final palette = havenPalette(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(note.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          '${note.fecha!.day}/${note.fecha!.month}/${note.fecha!.year} · ${note.fecha!.hour}:${note.fecha!.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 14),
        Text(
          note.content.texto ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: palette.inkSoft,
                height: 1.55,
              ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (note.emociones ?? [])
              .map(
                (e) => Text(
                  e.tipo,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: emotionColorOf(e.emocionBase),
                      ),
                ),
              )
              .toList(),
        ),
        if (isDoctor && note.notaciones != null && note.notaciones!.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text('Nota clínica', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(note.notaciones!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }

  List<Widget> _notesItems(NotesProvider notesProvider, int weekSelected) {
    final notes = <Widget>[];
    for (int i = 0; i < notesProvider.notes.length; i++) {
      if (notesProvider.notes[i].fecha!
                      .difference(notesProvider.notes[0].fecha!)
                      .inDays ~/
                  7 +
              1 ==
          weekSelected + 1) {
        final selected = itemPressed == i;
        notes.add(
          GestureDetector(
            onTap: () => setState(() => itemPressed = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 62,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              decoration: BoxDecoration(
                color: havenPalette(context).surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected
                      ? havenPalette(context).primary
                      : havenPalette(context).line,
                  width: selected ? 1.8 : 1,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: _emotionsList(
                        notesProvider.notes[i].emociones ?? [],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${notesProvider.notes[i].fecha!.day}/${notesProvider.notes[i].fecha!.month}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return notes;
  }

  List<Widget> _emotionsList(List<EmocionModel> emotions) {
    final sorted = [...emotions]..sort((a, b) => b.valor.compareTo(a.valor));
    return [
      for (int i = 0; i < sorted.length; i++)
        Container(
          height: 18,
          margin: const EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
            color: emotionColorOf(sorted[i].emocionBase),
            borderRadius: i == 0
                ? const BorderRadius.vertical(top: Radius.circular(8))
                : BorderRadius.circular(4),
          ),
        ),
    ];
  }
}

class _HavenSelect<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  const _HavenSelect({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.line),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          items: items,
          onChanged: onChanged,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: palette.inkSoft),
          dropdownColor: palette.surface,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.ink,
              ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
