// ignore_for_file: avoid_print

import 'package:first/models/emocion_model.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:first/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../../widgets/drawer.dart';

class ProgresoView extends StatefulWidget {
  final UserProvider userProvider;
  const ProgresoView({Key? key, required this.userProvider}) : super(key: key);

  @override
  State<ProgresoView> createState() => _ProgresoViewState();
}

class _ProgresoViewState extends State<ProgresoView> {
  bool close = false;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  final colores = {
    'Feliz': Colors.red,
    'En plenitud': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider =
        Provider.of<NotesProvider>(context, listen: true);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: DrawerWidget(
        currentPage: 'Progress',
        userProvider: widget.userProvider,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 10.0),
        color: theme.isDarkModeEnabled
            ? theme.dark['backgroundColor']
            : theme.light['backgroundColor'],
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: DropdownButton(
                    items: _pickerItems(),
                    onChanged: (value) {
                      print(value);
                    },
                    hint: const Text('Dias'), //0
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    underline: Container(
                      height: 0,
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                width: double.infinity,
                height: height * 0.20,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _notesItems(notesProvider),
                  ),
                )),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: close ? 0.0 : (height * 0.25),
              width: width,
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: close
                      ? const SizedBox(
                          height: 10,
                        )
                      : notaBottomWidget(context)),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> _pickerItems() {
    List<DropdownMenuItem> items = [];
    items.add(const DropdownMenuItem(
      value: 0,
      child: Text('Dias'),
    ));

    items.add(const DropdownMenuItem(
      value: 1,
      child: Text('Semanas'),
    ));

    items.add(const DropdownMenuItem(
      value: 2,
      child: Text('Meses'),
    ));
    return items;
  }

  List<Widget> _notesItems(NotesProvider notesProvider) {
    List<Widget> notes = [];
    for (int i = 0; i < notesProvider.notes.length; i++) {
      notes.add(GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _emotionsList(notesProvider.notes[i].emociones!),
          ),
        ),
      ));
    }
    return notes;
  }

  List<Widget> _emotionsList(List<EmocionModel> emotions) {
    int heightInt = 150;
    List<Widget> emotionsList = [];
    for (int i = 0; i < emotions.length; i++) {
      emotionsList.add(Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          padding: const EdgeInsets.all(5.0),
          height: heightInt / emotions.length - 1,
          width: 50.0,
          decoration: BoxDecoration(
            color: colores[emotions[i].tipo],
            borderRadius: i == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  )
                : BorderRadius.circular(0.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
            ],
          )));
    }
    return emotionsList;
  }

//Emocion: Enojado
  Widget notaBottomWidget(BuildContext context) {
    return Container();
  }
}
