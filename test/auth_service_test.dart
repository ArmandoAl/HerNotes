import 'package:flutter_test/flutter_test.dart';
import 'package:first/services/auth_service.dart';
import 'package:first/models/login_model.dart';
import 'package:first/models/model_for_control_usertype.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  group('AuthService Tests', () {
    test('Login - Success', () async {
      // Arrange
      final authService = AuthService();
      final storage = MockLocalStorage();
      final loginModel =
          Login(email: "laura@gmail.com", password: "laurapassword");

      // Go to authService.dart line 73 and coment the storage.setItem line
      final result = await authService.login(loginModel, storage);

      // Assert
      expect(result, isNotNull);
      expect(result!.user, isNotNull);
      //deberia ser un model_for_control_usertype
      expect(result, isA<ModelForControlUsertype>());
    });

    test('GetStorage - User Not Found', () async {
      // Arrange
      final authService = AuthService();
      final storage = MockLocalStorage();
      when(storage.getItem('userStorage')).thenReturn(null);

      // Act
      final result = await authService.getStorage(storage);

      // Assert
      expect(result, isNull);
    });
  });
}
