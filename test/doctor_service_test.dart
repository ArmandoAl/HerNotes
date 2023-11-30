import 'package:first/models/paciente_model.dart';
import 'package:first/services/doctor_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('DoctorService Tests', () {
    test('GetPacientes - Success', () async {
      // Arrange
      final doctorService = DoctorService();
      // Act
      final result = await doctorService.getPacientes(3);
      // Assert
      expect(result, isNotNull);
      //se espera una liata de PacienteModel
      expect(result, isA<List<PacienteModel>>());
    });
  });
}
