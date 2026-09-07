import 'package:flutter_test/flutter_test.dart';
import 'package:her_notes/Data/mocks/mock_credentials.dart';
import 'package:her_notes/Data/mocks/mock_store.dart';
import 'package:her_notes/Data/services/auth_service.dart';
import 'package:her_notes/Domain/models/login_model.dart';
import 'package:her_notes/Domain/models/model_for_control_usertype.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';

class FakeLocalStorage extends Fake implements LocalStorage {
  final Map<String, dynamic> items = {};

  @override
  Future<void> setItem(
    String key,
    value, [
    Object Function(Object nonEncodable)? toEncodable,
  ]) async {
    items[key] = value;
  }

  @override
  dynamic getItem(String key) => items[key];
}

void main() {
  setUp(() {
    MockStore.instance.reset();
  });

  group('AuthService Tests', () {
    test('Login - Success', () async {
      final authService = AuthService();
      final storage = FakeLocalStorage();
      final loginModel = Login(
        email: MockCredentials.studentEmail,
        password: MockCredentials.studentPassword,
      );

      final result = await authService.login(loginModel, storage);

      expect(result, isNotNull);
      expect(result!.user, isNotNull);
      expect(result, isA<ModelForControlUsertype>());
      expect(result.usertype, 'paciente');
    });

    test('GetStorage - User Not Found', () async {
      final authService = AuthService();
      final storage = FakeLocalStorage();

      final result = await authService.getStorage(storage);

      expect(result, isNull);
    });
  });
}
