import 'dart:convert';

import 'package:her_notes/Data/mocks/mock_credentials.dart';
import 'package:her_notes/Data/mocks/mock_store.dart';
import 'package:http/http.dart' as http;

class MockApi {
  static final MockStore _store = MockStore.instance;

  static Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _handle('GET', url);
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _handle('POST', url, body: body);
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _handle('PUT', url, body: body);
  }

  static Future<http.Response> _handle(
    String method,
    Uri url, {
    Object? body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 280));
    final path = url.path;
    final payload = _decodeBody(body);

    try {
      if (method == 'POST' && path.endsWith('/Paciente/otherlogin')) {
        return _login(payload);
      }
      if (method == 'GET' && path.endsWith('/Emocion/GetAll')) {
        return _ok(_store.emotions);
      }
      if (method == 'POST' && path.endsWith('/Nota/addNotations') ||
          method == 'PUT' && path.endsWith('/Nota/addNotations')) {
        return _addNotations(payload);
      }
      if (method == 'POST' && path.endsWith('/Nota')) {
        return _addNote(payload);
      }
      if (method == 'POST' && path.endsWith('/Paciente')) {
        return _signUpPaciente(payload);
      }
      if (method == 'POST' && path.endsWith('/Doctor')) {
        return _signUpDoctor(payload);
      }

      final notasMatch =
          RegExp(r'/Paciente/(\d+)/notas$').firstMatch(path);
      if (method == 'GET' && notasMatch != null) {
        final userId = int.parse(notasMatch.group(1)!);
        return _ok({
          'notas': _store.notesByUser[userId] ?? [],
          'tareas': _store.tasksByUser[userId] ?? [],
        });
      }

      final completeTaskMatch =
          RegExp(r'/Paciente/(\d+)/completeTaskAndNotiDoctor$')
              .firstMatch(path);
      if (method == 'POST' && completeTaskMatch != null) {
        final userId = int.parse(completeTaskMatch.group(1)!);
        return _completeTask(userId, payload);
      }

      final relateMatch =
          RegExp(r'/Paciente/(\d+)/relate/([^/]+)$').firstMatch(path);
      if (method == 'POST' && relateMatch != null) {
        final userId = int.parse(relateMatch.group(1)!);
        final token = Uri.decodeComponent(relateMatch.group(2)!);
        return _relateDoctor(userId, token);
      }

      final patientsMatch =
          RegExp(r'/Doctor/(\d+)/GetAllUsers$').firstMatch(path);
      if (method == 'GET' && patientsMatch != null) {
        final doctorId = int.parse(patientsMatch.group(1)!);
        return _ok(_store.pacientesOfDoctor(doctorId));
      }

      final sendTaskMatch =
          RegExp(r'/Doctor/(\d+)/sendTaskToPatien/(\d+)$').firstMatch(path);
      if (method == 'POST' && sendTaskMatch != null) {
        final patientId = int.parse(sendTaskMatch.group(2)!);
        return _sendTask(patientId, payload);
      }

      return _error(404, 'Endpoint no mockeado: $method $path');
    } catch (e) {
      return _error(500, e.toString());
    }
  }

  static Map<String, dynamic> _decodeBody(Object? body) {
    if (body == null) return {};
    if (body is Map<String, dynamic>) return body;
    if (body is String && body.isNotEmpty) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    }
    return {};
  }

  static http.Response _login(Map<String, dynamic> payload) {
    final email = (payload['email'] ?? '').toString().trim();
    final password = (payload['password'] ?? '').toString();

    var user = _store.userByEmail(email);

    // Aliases usados en demos anteriores.
    if (user == null && email.toLowerCase() == 'paciente@gmail.com') {
      user = _store.users[1];
    }
    if (user == null && email.toLowerCase() == 'doctor@gmail.com') {
      user = _store.users[10];
    }

    if (user == null) {
      return _error(401, 'Usuario no encontrado');
    }

    final expectedPassword = user['password'] as String;
    final aliasesOk = (email.toLowerCase() == 'paciente@gmail.com' &&
            password == 'paciente') ||
        (email.toLowerCase() == 'doctor@gmail.com' && password == 'doctor');

    if (password != expectedPassword && !aliasesOk) {
      return _error(401, 'Contraseña incorrecta');
    }

    return _ok(_store.loginPayload(user));
  }

  static http.Response _addNote(Map<String, dynamic> payload) {
    final userId = payload['userId'] as int? ?? 0;
    final nota = payload['nota'] as Map<String, dynamic>? ?? {};
    final emotionIds = (payload['emotionsIds'] as List<dynamic>? ?? [])
        .map((id) => id as int)
        .toList();

    final noteId = _store.nextNoteId();
    final contenido = nota['Contenido'] as Map<String, dynamic>? ?? {};
    final created = DateTime.now().toUtc().toIso8601String();

    final note = {
      'id': noteId,
      'title': (nota['Title'] ?? 'Sin título').toString(),
      'contenido': {
        'id': _store.nextContentId(),
        'texto': contenido['texto'],
        'imagenUrl': contenido['imagenUrl'],
        'notaDeVozUrl': contenido['notaDeVozUrl'],
      },
      'notaciones': nota['Notaciones'],
      'emociones': emotionIds
          .map(_store.emotionById)
          .whereType<Map<String, dynamic>>()
          .toList(),
      'createdDate': created,
    };

    _store.notesByUser.putIfAbsent(userId, () => []);
    _store.notesByUser[userId]!.add(note);
    return _ok(noteId);
  }

  static http.Response _addNotations(Map<String, dynamic> payload) {
    final noteId = payload['noteId'] as int? ?? 0;
    final anotacion = (payload['anotacion'] ?? '').toString();

    for (final notes in _store.notesByUser.values) {
      for (final note in notes) {
        if (note['id'] == noteId) {
          note['notaciones'] = anotacion;
          return _ok(true);
        }
      }
    }
    return _error(404, 'Nota no encontrada');
  }

  static http.Response _completeTask(
      int userId, Map<String, dynamic> payload) {
    final taskId = payload['id'] as int?;
    final tasks = _store.tasksByUser[userId] ?? [];
    _store.tasksByUser[userId] =
        tasks.where((task) => task['id'] != taskId).toList();
    return _ok(true);
  }

  static http.Response _sendTask(int patientId, Map<String, dynamic> payload) {
    final task = {
      'id': _store.nextTaskId(),
      'title': (payload['title'] ?? 'Nueva tarea').toString(),
      'description': (payload['description'] ?? '').toString(),
      'createdDate': DateTime.now().toUtc().toIso8601String(),
      'isDone': false,
    };
    _store.tasksByUser.putIfAbsent(patientId, () => []);
    _store.tasksByUser[patientId]!.add(task);
    return _ok(true);
  }

  static http.Response _relateDoctor(int userId, String token) {
    final doctor = _store.users.values.firstWhere(
      (user) =>
          user['userType'] == 'doctor' && user['tokenForRelate'] == token,
      orElse: () => {},
    );
    if (doctor.isEmpty) {
      return _error(404, 'Código de vinculación inválido');
    }

    final patient = _store.users[userId];
    if (patient == null) {
      return _error(404, 'Paciente no encontrado');
    }

    patient['doctorId'] = doctor['id'];
    patient['doctorid'] = doctor['id'];
    return _ok(doctor['id']);
  }

  static http.Response _signUpPaciente(Map<String, dynamic> payload) {
    final id = _store.nextUserId();
    _store.users[id] = {
      'id': id,
      'name': payload['name'],
      'email': payload['email'],
      'password': payload['password'],
      'token': payload['token'] ?? 'mock-token-$id',
      'doctorId': null,
      'doctorid': null,
      'userType': 'paciente',
    };
    _store.notesByUser[id] = [];
    _store.tasksByUser[id] = [];
    return _ok(id);
  }

  static http.Response _signUpDoctor(Map<String, dynamic> payload) {
    final id = _store.nextUserId();
    _store.users[id] = {
      'id': id,
      'name': payload['name'],
      'email': payload['email'],
      'password': payload['password'],
      'token': payload['token'] ?? 'mock-token-$id',
      'tokenForRelate': MockCredentials.relateCode,
      'cedulaProfesional': payload['cedulaProfesional'] ?? '',
      'userType': 'doctor',
    };
    return _ok(id);
  }

  static http.Response _ok(Object body) {
    return http.Response(
      jsonEncode(body),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  static http.Response _error(int status, String message) {
    return http.Response(
      jsonEncode({'message': message}),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
}
