import 'package:her_notes/Data/mocks/mock_credentials.dart';

/// In-memory demo database used when [useMocks] is true.
class MockStore {
  MockStore._() {
    reset();
  }

  static final MockStore instance = MockStore._();

  late List<Map<String, dynamic>> emotions;
  late Map<int, Map<String, dynamic>> users;
  late Map<int, List<Map<String, dynamic>>> notesByUser;
  late Map<int, List<Map<String, dynamic>>> tasksByUser;
  int _nextNoteId = 200;
  int _nextTaskId = 600;
  int _nextUserId = 50;
  int _nextContentId = 200;

  int nextNoteId() => _nextNoteId++;
  int nextTaskId() => _nextTaskId++;
  int nextUserId() => _nextUserId++;
  int nextContentId() => _nextContentId++;

  Map<String, dynamic>? userByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (final user in users.values) {
      if ((user['email'] as String).toLowerCase() == normalized) {
        return user;
      }
    }
    return null;
  }

  void reset() {
    emotions = _buildEmotions();
    users = {
      1: {
        'id': 1,
        'name': 'Lucía Martínez',
        'email': MockCredentials.studentEmail,
        'password': MockCredentials.studentPassword,
        'token': 'mock-student-token',
        'doctorId': 10,
        'doctorid': 10,
        'userType': 'paciente',
      },
      2: {
        'id': 2,
        'name': 'Mateo Ruiz',
        'email': 'mateo.ruiz@hernotes.com',
        'password': 'Alumno123',
        'token': 'mock-mateo-token',
        'doctorId': 10,
        'doctorid': 10,
        'userType': 'paciente',
      },
      3: {
        'id': 3,
        'name': 'Sofía Navarro',
        'email': 'sofia.navarro@hernotes.com',
        'password': 'Alumno123',
        'token': 'mock-sofia-token',
        'doctorId': 10,
        'doctorid': 10,
        'userType': 'paciente',
      },
      10: {
        'id': 10,
        'name': 'Dr. Carlos Hernández',
        'email': MockCredentials.teacherEmail,
        'password': MockCredentials.teacherPassword,
        'token': 'mock-teacher-token',
        'tokenForRelate': MockCredentials.relateCode,
        'cedulaProfesional': '12345678',
        'userType': 'doctor',
      },
    };

    notesByUser = {
      1: _luciaNotes(),
      2: _mateoNotes(),
      3: _sofiaNotes(),
    };

    tasksByUser = {
      1: [
        _task(
          501,
          'Escribe sobre tu semana',
          'Describe cómo te sentiste en las clases de esta semana y qué te ayudó a concentrarte.',
          '2026-09-05T09:00:00.000Z',
        ),
        _task(
          502,
          'Carta a tu yo del lunes',
          'Escribe una nota corta con un propósito para empezar la semana con más calma.',
          '2026-09-06T18:30:00.000Z',
        ),
      ],
      2: [
        _task(
          510,
          'Registro de estudio',
          'Anota qué temas revisaste hoy y cómo te sentiste al terminar.',
          '2026-09-04T16:00:00.000Z',
        ),
      ],
      3: [],
    };
  }

  Map<String, dynamic> loginPayload(Map<String, dynamic> user) {
    return {
      'userType': user['userType'],
      'user': {
        'id': user['id'],
        'name': user['name'],
        'email': user['email'],
        'password': user['password'],
        'token': user['token'],
        'doctorid': user['doctorid'],
        'tokenForRelate': user['tokenForRelate'],
        'cedulaProfesional': user['cedulaProfesional'] ?? '',
      },
    };
  }

  List<Map<String, dynamic>> pacientesOfDoctor(int doctorId) {
    return users.values
        .where((user) =>
            user['userType'] == 'paciente' && user['doctorId'] == doctorId)
        .map((user) => {
              'id': user['id'],
              'name': user['name'],
              'email': user['email'],
              'password': user['password'],
              'doctorId': user['doctorId'],
              'token': user['token'],
            })
        .toList();
  }

  Map<String, dynamic>? emotionById(int id) {
    for (final emotion in emotions) {
      if (emotion['id'] == id) return Map<String, dynamic>.from(emotion);
    }
    return null;
  }

  List<Map<String, dynamic>> _buildEmotions() {
    return [
      _emotion(1, 'Alegre', 0.82, 'Felicidad'),
      _emotion(2, 'Esperanzado', 0.74, 'Felicidad'),
      _emotion(3, 'Orgulloso', 0.70, 'Felicidad'),
      _emotion(4, 'Triste', 0.68, 'Tristeza'),
      _emotion(5, 'Melancólico', 0.55, 'Tristeza'),
      _emotion(6, 'Cansado', 0.48, 'Tristeza'),
      _emotion(7, 'Enojado', 0.72, 'Enojo'),
      _emotion(8, 'Irritado', 0.58, 'Enojo'),
      _emotion(9, 'Ansioso', 0.80, 'Miedo'),
      _emotion(10, 'Preocupado', 0.64, 'Miedo'),
      _emotion(11, 'Inseguro', 0.52, 'Miedo'),
      _emotion(12, 'Cariñoso', 0.76, 'Amor'),
      _emotion(13, 'Agradecido', 0.71, 'Amor'),
      _emotion(14, 'Sorprendido', 0.60, 'Sorpresa'),
      _emotion(15, 'Curioso', 0.57, 'Sorpresa'),
      _emotion(16, 'Disgustado', 0.50, 'Repugnancia'),
    ];
  }

  Map<String, dynamic> _emotion(
      int id, String tipo, double valor, String emocionBase) {
    return {
      'id': id,
      'tipo': tipo,
      'valor': valor,
      'emocionBase': emocionBase,
    };
  }

  Map<String, dynamic> _task(
      int id, String title, String description, String createdDate) {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdDate': createdDate,
      'isDone': false,
    };
  }

  Map<String, dynamic> note({
    required int id,
    required String title,
    required String texto,
    required String createdDate,
    required List<Map<String, dynamic>> emociones,
    String? notaciones,
  }) {
    return {
      'id': id,
      'title': title,
      'contenido': {
        'id': id,
        'texto': texto,
        'imagenUrl': null,
        'notaDeVozUrl': null,
      },
      'notaciones': notaciones,
      'emociones': emociones,
      'createdDate': createdDate,
    };
  }

  List<Map<String, dynamic>> _luciaNotes() {
    return [
      note(
        id: 101,
        title: 'Primer día de clases',
        texto:
            'Hoy volví a la universidad. Me sentí nerviosa al entrar al salón, pero una compañera me habló y eso me ayudó a relajarme. Quiero sostener este ritmo.',
        createdDate: '2026-08-17T09:20:00.000Z',
        emociones: [
          emotionById(9)!,
          emotionById(2)!,
          emotionById(15)!,
        ],
        notaciones:
            'Buena apertura de semestre. Lucía identifica un apoyo social concreto; reforzar esa estrategia la próxima semana.',
      ),
      note(
        id: 102,
        title: 'Estudiando para cálculo',
        texto:
            'Pasé la tarde con ejercicios de derivadas. Al principio me bloqueé, después entendí dos problemas seguidos y me sentí capaz otra vez.',
        createdDate: '2026-08-19T21:10:00.000Z',
        emociones: [
          emotionById(10)!,
          emotionById(3)!,
          emotionById(1)!,
        ],
      ),
      note(
        id: 103,
        title: 'Discusión en equipo',
        texto:
            'En el proyecto de historia alguien interrumpió mis ideas. Me enojé, respiré y pude decir lo que pensaba sin alzar la voz.',
        createdDate: '2026-08-21T16:45:00.000Z',
        emociones: [
          emotionById(7)!,
          emotionById(8)!,
          emotionById(11)!,
        ],
        notaciones:
            'Registró enojo y regulación. Pedirle que anote la frase que usó para poner un límite; es un recurso útil.',
      ),
      note(
        id: 104,
        title: 'Domingo en casa',
        texto:
            'Descansé, vi una película con mi hermana y organicé la mochila. Me sentí querida y un poco más ligera para la semana.',
        createdDate: '2026-08-23T19:00:00.000Z',
        emociones: [
          emotionById(12)!,
          emotionById(13)!,
          emotionById(1)!,
        ],
      ),
      note(
        id: 105,
        title: 'Examen de literatura',
        texto:
            'El examen estuvo más difícil de lo que esperaba. Salí con un nudo en el estómago, aunque respondí casi todo. No quiero adelantar el resultado.',
        createdDate: '2026-08-26T13:30:00.000Z',
        emociones: [
          emotionById(9)!,
          emotionById(4)!,
          emotionById(14)!,
        ],
        notaciones:
            'Ansiedad post-examen esperable. Trabajar con evidencia: qué sí alcanzó a responder y qué repasará con calma.',
      ),
      note(
        id: 106,
        title: 'Ensayo entregado',
        texto:
            'Terminé el ensayo a tiempo. Estoy cansada, pero también orgullosa porque no lo dejé para el último minuto como el semestre pasado.',
        createdDate: '2026-08-28T22:15:00.000Z',
        emociones: [
          emotionById(3)!,
          emotionById(6)!,
          emotionById(2)!,
        ],
      ),
      note(
        id: 107,
        title: 'Notas del parcial',
        texto:
            'Saqué 8.4. No es perfecto, pero es mejor que el primer intento del año pasado. Me sorprendió ver que el esfuerzo se notó.',
        createdDate: '2026-08-31T11:05:00.000Z',
        emociones: [
          emotionById(14)!,
          emotionById(1)!,
          emotionById(13)!,
        ],
      ),
      note(
        id: 108,
        title: 'Semana cargada',
        texto:
            'Tengo tres entregas juntas. Me siento saturada y un poco triste porque no he salido con mis amigas. Voy a armar un horario realista.',
        createdDate: '2026-09-02T20:40:00.000Z',
        emociones: [
          emotionById(4)!,
          emotionById(9)!,
          emotionById(6)!,
        ],
        notaciones:
            'Hay sobrecarga. Revisar priorización: una entrega a la vez y un bloque corto de descanso social.',
      ),
      note(
        id: 109,
        title: 'Tutoría de matemáticas',
        texto:
            'La tutoría me aclaró el tema de límites. Salí más segura y hasta expliqué un ejercicio a Mateo. Eso me hizo sentir útil.',
        createdDate: '2026-09-04T17:25:00.000Z',
        emociones: [
          emotionById(2)!,
          emotionById(3)!,
          emotionById(12)!,
        ],
      ),
      note(
        id: 110,
        title: 'Cierre de la semana',
        texto:
            'Hoy pude concentrarme dos horas seguidas. Todavía hay tareas, pero ya no siento que todo se me viene encima. Quiero repetir este ritmo el lunes.',
        createdDate: '2026-09-06T21:00:00.000Z',
        emociones: [
          emotionById(1)!,
          emotionById(2)!,
          emotionById(10)!,
        ],
        notaciones:
            'Buen cierre. Reforzar el bloque de dos horas como hábito y celebrar el progreso frente a la ansiedad inicial.',
      ),
    ];
  }

  List<Map<String, dynamic>> _mateoNotes() {
    return [
      note(
        id: 201,
        title: 'Entrenamiento y tarea',
        texto:
            'Llegué tarde a estudiar por el entrenamiento. Estoy irritado conmigo mismo, pero ya organicé mañana para no repetirlo.',
        createdDate: '2026-08-27T22:00:00.000Z',
        emociones: [
          emotionById(8)!,
          emotionById(10)!,
          emotionById(2)!,
        ],
        notaciones:
            'Hay autocrítica alta. Ayudarlo a separar el error del valor personal y a proteger un horario de estudio.',
      ),
      note(
        id: 202,
        title: 'Presentación oral',
        texto:
            'Hablé frente al grupo. Me temblaba la voz al inicio, después me solté. Varios compañeros me dijeron que se entendió bien.',
        createdDate: '2026-09-01T15:10:00.000Z',
        emociones: [
          emotionById(9)!,
          emotionById(1)!,
          emotionById(3)!,
        ],
      ),
      note(
        id: 203,
        title: 'Día pesado',
        texto:
            'No dormí bien y todo me salió lento. Me sentí triste y con ganas de no ir, pero sí asistí a las dos clases.',
        createdDate: '2026-09-03T23:20:00.000Z',
        emociones: [
          emotionById(4)!,
          emotionById(6)!,
          emotionById(11)!,
        ],
      ),
    ];
  }

  List<Map<String, dynamic>> _sofiaNotes() {
    return [
      note(
        id: 301,
        title: 'Nuevo club de lectura',
        texto:
            'Me inscribí al club. Estaba insegura de no conocer a nadie, pero la dinámica fue amable y ya tengo el primer libro.',
        createdDate: '2026-08-29T18:40:00.000Z',
        emociones: [
          emotionById(11)!,
          emotionById(15)!,
          emotionById(12)!,
        ],
      ),
      note(
        id: 302,
        title: 'Laboratorio de química',
        texto:
            'El experimento no salió como en la guía. Me disgustó el desorden, aunque el profesor dijo que el registro estaba bien hecho.',
        createdDate: '2026-09-05T14:50:00.000Z',
        emociones: [
          emotionById(16)!,
          emotionById(14)!,
          emotionById(3)!,
        ],
        notaciones:
            'Sofía tolera mejor el error cuando hay retroalimentación clara. Seguir validando el proceso, no solo el resultado.',
      ),
    ];
  }
}
