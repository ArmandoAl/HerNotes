import 'dart:convert';

import 'package:her_notes/Data/mocks/mock_api.dart';
import 'package:her_notes/Data/mocks/mock_credentials.dart';
import 'package:her_notes/Data/mocks/mock_store.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    MockStore.instance.reset();
  });

  test('login as student returns paciente payload', () async {
    final response = await MockApi.post(
      Uri.parse('https://webapihernotes.azurewebsites.net/Api/Paciente/otherlogin'),
      body: jsonEncode({
        'email': MockCredentials.studentEmail,
        'password': MockCredentials.studentPassword,
      }),
    );

    expect(response.statusCode, 200);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    expect(body['userType'], 'paciente');
    expect(body['user']['name'], 'Lucía Martínez');
    expect(body['user']['doctorid'], 10);
  });

  test('login as teacher returns doctor payload', () async {
    final response = await MockApi.post(
      Uri.parse('https://webapihernotes.azurewebsites.net/Api/Paciente/otherlogin'),
      body: jsonEncode({
        'email': MockCredentials.teacherEmail,
        'password': MockCredentials.teacherPassword,
      }),
    );

    expect(response.statusCode, 200);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    expect(body['userType'], 'doctor');
    expect(body['user']['tokenForRelate'], MockCredentials.relateCode);
  });

  test('student notes include several weeks of emotions', () async {
    final response = await MockApi.get(
      Uri.parse('https://webapihernotes.azurewebsites.net/Api/Paciente/1/notas'),
    );

    expect(response.statusCode, 200);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    expect((body['notas'] as List).length, greaterThanOrEqualTo(8));
    expect((body['tareas'] as List), isNotEmpty);
    expect(body['notas'][0]['emociones'], isNotEmpty);
  });

  test('teacher can list linked students', () async {
    final response = await MockApi.get(
      Uri.parse('https://webapihernotes.azurewebsites.net/Api/Doctor/10/GetAllUsers'),
    );

    expect(response.statusCode, 200);
    final body = jsonDecode(response.body) as List<dynamic>;
    expect(body.length, 3);
    expect(body.map((item) => item['name']), contains('Lucía Martínez'));
  });
}
