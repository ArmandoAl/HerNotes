import 'package:her_notes/Domain/models/notes_&_task_model.dart';
import 'package:her_notes/Data/mocks/mock_store.dart';
import 'package:her_notes/Data/services/notes_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    MockStore.instance.reset();
  });

  group('NoteService Tests', () {
    test('GetNotes - Success', () async {
      final noteService = NoteService();
      final result = await noteService.getNotes(1);

      expect(result, isNotNull);
      expect(result, isA<NotesAndTaskModel>());
      expect(result!.notes, isNotEmpty);
      expect(result.tasks, isNotEmpty);
    });
  });
}
