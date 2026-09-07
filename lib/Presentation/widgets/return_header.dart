import 'package:her_notes/Config/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnHeaderWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const ReturnHeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final palette = theme.palette;
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text(
        'HerNotes',
        style: TextStyle(color: palette.ink, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.transparent,
      toolbarHeight: preferredSize.height,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: palette.ink),
        iconSize: 26,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
