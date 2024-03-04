import 'package:her_notes/Domain/models/emocion_model.dart';
import 'package:her_notes/Data/services/emotions_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('EmotionService Tests', () {
    test('GetEmotions - Success', () async {
      // Arrange
      final emotionService = EmotionService();

      // Act
      final result = await emotionService.getEmotions();

      // Assert
      expect(result, isNotNull);
      // Se espera una lista de EmocionModel o null si hay un error
      expect(result, isA<List<EmocionModel>>());
    });
  });
}
