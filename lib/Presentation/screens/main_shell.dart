import 'package:flutter/material.dart';
import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:her_notes/Presentation/provider/user_provider.dart';
import 'package:her_notes/Presentation/screens/diaryScreen.dart';
import 'package:her_notes/Presentation/screens/listOfUsersScreen.dart';
import 'package:her_notes/Presentation/screens/progressScreen.dart';
import 'package:her_notes/Presentation/screens/settingsScreen.dart';
import 'package:her_notes/Presentation/widgets/haven_atmosphere.dart';
import 'package:her_notes/Presentation/widgets/haven_bottom_nav.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isDoctor = userProvider.user!.usertype == 'doctor';
    final pages = isDoctor
        ? const [
            ListOfUsersView(),
            ProgresoView(),
            ConfiguracionView(),
          ]
        : [
            DiarioView(userId: userProvider.user!.user.id),
            const ProgresoView(),
            const ConfiguracionView(),
          ];

    return HavenAtmosphere(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: IndexedStack(
          index: _index,
          children: pages,
        ),
        bottomNavigationBar: HavenBottomNav(
          index: _index,
          isDoctor: isDoctor,
          onChanged: (value) => setState(() => _index = value),
        ),
      ),
    );
  }
}

String havenGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Buenos días';
  if (hour < 19) return 'Buenas tardes';
  return 'Buenas noches';
}

String firstNameOf(String fullName) {
  if (fullName.trim().isEmpty) return 'tú';
  return fullName.trim().split(' ').first;
}

class HavenPageHeader extends StatelessWidget {
  final String kicker;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;

  const HavenPageHeader({
    super.key,
    required this.kicker,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final palette = havenPalette(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: palette.primary,
                        letterSpacing: 1.4,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
