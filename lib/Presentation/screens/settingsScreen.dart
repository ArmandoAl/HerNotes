// ignore_for_file: use_build_context_synchronously
import 'package:her_notes/Presentation/provider/doctor_provider.dart';
import 'package:her_notes/Presentation/provider/notes_provider.dart';
import 'package:her_notes/Presentation/provider/paciente_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/screens/main_shell.dart';
import 'package:her_notes/Presentation/widgets/app_message.dart';
import 'package:her_notes/Presentation/widgets/haven_button.dart';
import 'package:her_notes/Presentation/widgets/haven_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConfiguracionView extends StatefulWidget {
  const ConfiguracionView({super.key});

  @override
  State<ConfiguracionView> createState() => _ConfiguracionViewState();
}

class _ConfiguracionViewState extends State<ConfiguracionView> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);
    final pacienteProvider = Provider.of<PacienteProvider>(context);
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final palette = havenPalette(context);
    final isDoctor = user.user!.usertype == 'doctor';
    final name = user.getUser!.user.name.toString();
    final email = user.getUser!.user.email.toString();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
          children: [
            const HavenPageHeader(
              kicker: 'Tu espacio',
              title: 'Cuidar el entorno',
              subtitle: 'Tema, vínculo terapéutico y salida, con calma.',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: palette.line),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: palette.primarySoft,
                    backgroundImage: const AssetImage(
                      'lib/Config/images/her_head.png',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(email,
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 6),
                        Text(
                          isDoctor ? 'Terapeuta' : 'Paciente',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: palette.primary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              icon: theme.isDarkModeEnabled
                  ? Icons.nights_stay_rounded
                  : Icons.wb_twilight_rounded,
              title: 'Modo noche',
              subtitle: 'Un fondo más suave para escribir de noche.',
              trailing: Switch.adaptive(
                value: theme.isDarkModeEnabled,
                activeColor: palette.primary,
                onChanged: theme.setTheme,
              ),
            ),
            const SizedBox(height: 12),
            const _SettingsCard(
              icon: Icons.notifications_none_rounded,
              title: 'Recordatorios',
              subtitle: 'Pronto podrás elegir un momento suave para escribir.',
            ),
            if (!isDoctor) ...[
              const SizedBox(height: 12),
              _SettingsCard(
                icon: Icons.handshake_rounded,
                title: pacienteProvider.paciente?.doctorId == null
                    ? 'Vincular terapeuta'
                    : 'Ya tienes un vínculo',
                subtitle: pacienteProvider.paciente?.doctorId == null
                    ? 'Ingresa el código que te compartió tu terapeuta.'
                    : 'Tu diario ya está acompañado.',
                onTap: pacienteProvider.paciente?.doctorId == null
                    ? () => _relateDoctor(pacienteProvider, user)
                    : null,
              ),
            ],
            if (isDoctor) ...[
              const SizedBox(height: 12),
              _SettingsCard(
                icon: Icons.qr_code_2_rounded,
                title: 'Código de vinculación',
                subtitle: doctorProvider.doctor?.tokenForRelate ??
                    'Comparte este código con quien acompañas.',
                onTap: () {
                  final code = doctorProvider.doctor?.tokenForRelate;
                  if (code == null) return;
                  Clipboard.setData(ClipboardData(text: code));
                  showHavenMessage(context, 'Código copiado con cuidado.');
                },
              ),
            ],
            const SizedBox(height: 28),
            HavenButton(
              label: 'Cerrar sesión',
              variant: HavenButtonVariant.secondary,
              icon: Icons.logout_rounded,
              onPressed: () {
                theme.setTheme(false);
                notesProvider.clearProvider();
                user.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _relateDoctor(
    PacienteProvider pacienteProvider,
    UserProvider userProvider,
  ) async {
    final palette = havenPalette(context, listen: false);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vincular terapeuta',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'El código es una puerta, no una exposición. Solo quien tú elijas entra.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                HavenTextField(
                  label: 'Código',
                  controller: _codeController,
                  hint: 'Ej. PROF-2024',
                  icon: Icons.key_rounded,
                ),
                const SizedBox(height: 16),
                HavenButton(
                  label: 'Vincular con calma',
                  onPressed: () async {
                    final result = await pacienteProvider.relateDoctor(
                      pacienteProvider.paciente!.id!,
                      _codeController.text,
                    );
                    if (result != null) {
                      await userProvider.setDoctorIdInUserStorage(result);
                      Navigator.pop(context);
                      showHavenMessage(
                        context,
                        'El vínculo se creó. Ya no estás escribiendo solo.',
                      );
                    } else {
                      showHavenMessage(
                        context,
                        'No encontramos ese código. Revísalo sin prisa.',
                        isError: true,
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Ahora no',
                      style: TextStyle(color: palette.inkSoft),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.line),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: palette.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: palette.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            trailing ??
                (onTap == null
                    ? const SizedBox.shrink()
                    : Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: palette.inkFaint,
                      )),
          ],
        ),
      ),
    );
  }
}
