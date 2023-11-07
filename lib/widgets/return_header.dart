import 'package:first/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnHeaderWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const ReturnHeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      centerTitle: true,
      title: Text('',
          style: TextStyle(
              color: theme.isDarkModeEnabled ? Colors.white : Colors.black)),
      backgroundColor: theme.isDarkModeEnabled
          ? theme.dark['backgroundColor']
          : theme.light['backgroundColor'],
      toolbarHeight: preferredSize.height,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Color.fromRGBO(47, 137, 252, 1)),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
