// ignore_for_file: avoid_print

import 'dart:async';

import 'package:first/utils/theme_provider.dart';
import 'package:first/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/drawer.dart';

class ProgresoView extends StatefulWidget {
  const ProgresoView({super.key});

  @override
  State<ProgresoView> createState() => _ProgresoViewState();
}

class _ProgresoViewState extends State<ProgresoView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  bool close = false;

  List<Nota> notasFecha = [
    Nota('Proxima cita', 'Dr. Victor V', DateTime(2023, 06, 10), null, null),
    Nota('Detalles cita', 'Dr. Victor V', DateTime(2023, 06, 20), 'Notas',
        'Archivos'),
    Nota('Emocion: Enojado', null, DateTime(2023, 06, 18), 'Notas', 'Archivos'),
  ];

  static const colores = {
    'Proxima cita': Color.fromARGB(255, 136, 81, 10),
    'Detalles cita': Color.fromARGB(255, 166, 55, 218),
    'Emocion: Enojado': Colors.red,
    "none": Colors.blue,
  };

  late Nota notaActual = Nota("none", "persona", DateTime.now(), "notas",
      "archivos"); //esta variable se usara para mostrar la nota actual en la parte de abajo (la que se selecciona al hacer click en el evento

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  void cambioDeNota(Nota nota) {
    setState(() {
      notaActual = nota;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: const DrawerWidget(
        currentPage: 'Progress',
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20.0),
        color: theme.isDarkModeEnabled
            ? theme.dark['backgroundColor']
            : theme.light['backgroundColor'],
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2023, 01, 01),
              lastDay: DateTime.utc(2024, 01, 01),
              focusedDay: _focusedDay,
              selectedDayPredicate: (DateTime date) {
                return isSameDay(_selectedDay, date);
              },
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  _selectedDay = selectDay;
                  _focusedDay = focusDay;
                });
              },
              eventLoader: (date) {
                return _getEventsForDay(date, notasFecha);
              },
              calendarStyle: const CalendarStyle(
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                // Personaliza el estilo de los eventos
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    for (int i = 0; i < notasFecha.length; i++) {
                      if (isSameDay(day, notasFecha[i].fecha)) {
                        return Align(
                          alignment:
                              Alignment.topCenter + const Alignment(0.5, 0.5),
                          child: IconButton(
                            icon: Icon(
                              Icons.timelapse_rounded,
                              size: 15.0,
                              color: colores[notasFecha[i].titulo],
                            ),
                            onPressed: () {
                              if (notaActual != notasFecha[i]) {
                                setState(() {
                                  close = true;
                                });
                                cambioDeNota(notasFecha[i]);
                                Timer(const Duration(seconds: 1), () {
                                  setState(() {
                                    close = false;
                                  });
                                });
                              }
                            },
                          ),
                        );
                      }
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: close ? 0.0 : height,
              width: width,
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              decoration: BoxDecoration(
                color: colores[notaActual.titulo],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: const [
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
                      : notaBottomWidget(notaActual, context)),
            )
          ],
        ),
      ),
    );
  }

//Emocion: Enojado
  Widget notaBottomWidget(Nota nota, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Text(nota.titulo == "none" ? " " : nota.titulo,
            style: const TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
        ),
        nota.titulo == "Emocion: Enojado"
            ? Row(
                children: [
                  Column(
                    children: [
                      const Text("Notas",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0)),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(nota.notas!,
                          style: const TextStyle(color: Colors.white))
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                          "${nota.fecha.month}/${nota.fecha.day}/${nota.fecha.year}",
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              )
            : nota.titulo == "Proxima cita"
                ? Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50.0,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                nota.persona!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const Text("Valle dorado"),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            "${nota.fecha.month}/${nota.fecha.day}/${nota.fecha.year}",
                            style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text("10:00 AM"),
                        ],
                      ),
                    ],
                  )
                : nota.titulo == "Detalles cita"
                    ? Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50.0,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                    nota.persona!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text("Valle dorado"),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    "${nota.fecha.month}/${nota.fecha.day}/${nota.fecha.year}",
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text("10:00 AM"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Column(
                                    children: [
                                      const Text("Notas",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0)),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(nota.notas!,
                                          style: const TextStyle(
                                              color: Colors.white))
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  const Text("Archivos",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0)),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(nota.archivos!,
                                      style:
                                          const TextStyle(color: Colors.white))
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    print('hola');
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_rounded,
                                    color: Colors.white,
                                    size: 30.0,
                                  )),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text(
                                'Agendar cita',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add_circle_rounded,
                                    color: Colors.white,
                                    size: 30.0,
                                  )),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text(
                                'Seguimiento de progreso',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
      ],
    );
  }

//esta funcion en el futuro tambien recibira un arreglo de dias que tendra las fechas recogidas del back y se hare un arreglo con la funcion isSameDay para poner los dias que se han hecho citas
  List<Nota> _getEventsForDay(DateTime date, List<Nota> notasFecha) {
    List<Nota> eventos = [];
    for (int i = 0; i < notasFecha.length; i++) {
      if (isSameDay(date, notasFecha[i].fecha)) {
        eventos.add(notasFecha[i]);
      }
    }
    return eventos;
  }
}

class Nota {
  final String titulo;
  final String? persona;
  final DateTime fecha;
  final String? notas;
  final String? archivos;

  Nota(this.titulo, this.persona, this.fecha, this.notas, this.archivos);
}
