// ignore_for_file: avoid_print

import 'package:first/models/emocion_model.dart';
import 'package:first/models/notes_model.dart';
import 'package:first/provider/doctor_provider.dart';
import 'package:first/provider/notes_provider.dart';
import 'package:first/provider/user_provider.dart';
import 'package:first/utils/emocion_colors.dart';
import 'package:first/utils/theme_provider.dart';
import 'package:first/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/drawer.dart';

class ProgresoView extends StatefulWidget {
  final UserProvider userProvider;
  const ProgresoView({Key? key, required this.userProvider}) : super(key: key);

  @override
  State<ProgresoView> createState() => _ProgresoViewState();
}

class _ProgresoViewState extends State<ProgresoView> {
  int? itemPressed;
  List<String> weeks = [];
  List<DropdownMenuItem<int>> dropdownItems = [];
  int weekSelected = 0;

  List<String> calculateWeeks(List<NotesModel> notes) {
    List<String> weeks = [];

    for (int i = 0; i < notes.length; i++) {
      if (i == 0) {
        weeks.add("Semana 1");
      } else {
        int weekNumber =
            notes[i].fecha!.difference(notes[0].fecha!).inDays ~/ 7 + 1;
        if (weekNumber > weeks.length) {
          weeks.add("Semana $weekNumber");
        }
      }
    }

    return weeks;
  }

  List<DropdownMenuItem<int>> buildDropdownItems(List<String> weeks) {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < weeks.length; i++) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(weeks[i]),
      ));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      NotesProvider notesProvider =
          Provider.of<NotesProvider>(context, listen: false);
      if (notesProvider.notes.isEmpty) {
        DoctorProvider doctorProvider =
            Provider.of<DoctorProvider>(context, listen: false);
        await notesProvider.getNotes(doctorProvider.doctor!.pacientes![0].id!);
      }
    });

    NotesProvider notesProvider =
        Provider.of<NotesProvider>(context, listen: false);
    weeks = calculateWeeks(notesProvider.notes);
    dropdownItems = buildDropdownItems(weeks);
  }

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider =
        Provider.of<NotesProvider>(context, listen: true);
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);

    if (weeks.isEmpty) {
      print("weeks is empty");
      print(notesProvider.notes.length);
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
                widget.userProvider.user!.usertype == "doctor"
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: DropdownButton(
                          items: pacientesItems(doctorProvider),
                          onChanged: (value) {
                            notesProvider.getNotes(value as int);
                          },
                          value: doctorProvider.doctor!.pacientes![0].id,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black),
                          underline: Container(
                            height: 0,
                          ),
                        ),
                      )
                    : const Spacer(),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: DropdownButton(
                    items: dropdownItems,
                    onChanged: (value) {
                      setState(() {
                        weekSelected = value as int;
                      });
                    },
                    value: weekSelected,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.isDarkModeEnabled
                            ? Colors.white
                            : Colors.black),
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
                height: MediaQuery.of(context).size.height * 0.20,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _notesItems(notesProvider, weekSelected),
                  ),
                )),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: MediaQuery.of(context).size.height * 0.55,
              width: double.infinity,
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 20, 20, 20),
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      notaBottomWidget(context, notesProvider, itemPressed,
                          widget.userProvider),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> pacientesItems(DoctorProvider doctorProvider) {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < doctorProvider.doctor!.pacientes!.length; i++) {
      items.add(DropdownMenuItem(
        value: doctorProvider.doctor!.pacientes![i].id,
        child: Text(doctorProvider.doctor!.pacientes![i].name),
      ));
    }
    return items;
  }

  List<Widget> _notesItems(NotesProvider notesProvider, int weekSelected) {
    List<Widget> notes = [];
    for (int i = 0; i < notesProvider.notes.length; i++) {
      if (notesProvider.notes[i].fecha!
                      .difference(notesProvider.notes[0].fecha!)
                      .inDays ~/
                  7 +
              1 ==
          weekSelected + 1) {
        notes.add(GestureDetector(
          onTap: () {
            setState(() {
              itemPressed = i;
              // close = !close;
            });
          },
          child: Stack(children: [
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _emotionsList(notesProvider.notes[i].emociones!),
              ),
            ),
            Positioned(
              //quiero la fecha de la nota, solo el dia y mes, no el año, en formato dd/mm verticalmente
              bottom: 10,
              left: 15,
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Text(
                  "${notesProvider.notes[i].fecha!.day}/${notesProvider.notes[i].fecha!.month}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ]),
        ));
      }
    }
    return notes;
  }

  List<Widget> _emotionsList(List<EmocionModel> emotions) {
    emotions.sort((a, b) => b.valor.compareTo(a.valor));

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
            color: emotionColors[emotions[i].emocionBase],
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
  Widget notaBottomWidget(BuildContext context, NotesProvider notesProvider,
      int? itemPressed, UserProvider userProvider) {
    if (itemPressed == null) {
      return Column(
        children: [
          const Text("Simbología",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 15,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 28.0,
            children: emotionColors.keys.map((e) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                ),
                padding: const EdgeInsets.all(5.0),
                height: 50.0,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: emotionColors[e],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    e,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  notesProvider.notes[itemPressed].title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "${notesProvider.notes[itemPressed].fecha!.hour}:${notesProvider.notes[itemPressed].fecha!.minute} - ${notesProvider.notes[itemPressed].fecha!.day}/${notesProvider.notes[itemPressed].fecha!.month}/${notesProvider.notes[itemPressed].fecha!.year}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notesProvider.notes[itemPressed].content.texto!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ...notesProvider.notes[itemPressed].emociones!
                        .map((e) => Text(
                              e.tipo,
                              style: TextStyle(
                                color: emotionColors[e.emocionBase],
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.justify,
                            ))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            userProvider.user!.usertype == "doctor" &&
                    notesProvider.notes[itemPressed].notaciones != null
                ? Column(
                    children: [
                      const Text(
                        "Notaciones",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        notesProvider.notes[itemPressed].notaciones!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      );
    }
  }
}
