import 'package:first/models/add_note_model.dart';
import 'package:first/models/contenido_model.dart';
import 'package:first/models/notes_model.dart';
import 'package:first/services/notes_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('NoteService Tests', () {
    test('AddNote - Success', () async {
      // Arrange
      final noteService = NoteService();
      final addNoteModel = AddNoteModel(
        userId: 5,
        nota: NotesModel(
          title: 'test',
          content: ContenidoModel(
            texto: 'test',
          ),
        ),
        emocionesIds: [18, 19],
      );

      // Act
      final result = await noteService.addNote(addNoteModel);

      // Assert
      expect(result, isNotNull);
      expect(result, isA<int>());
    });

    test('GetNotes - Success', () async {
      // Arrange
      final noteService = NoteService();

      // Act
      final result = await noteService.getNotes(5);

      // Assert
      expect(result, isNotNull);
      // Se espera una lista de NotesModel o null si hay un error
      expect(result, isA<List<NotesModel>>());
    });
  });
}
