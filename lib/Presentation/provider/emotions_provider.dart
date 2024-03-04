import 'package:her_notes/Domain/models/emocion_model.dart';
import 'package:her_notes/Data/services/emotions_service.dart';
import 'package:flutter/material.dart';

class EmotionProvider extends ChangeNotifier {
  List<EmocionModel> _emotions = [];
  List<EmocionModel> get emotions => _emotions;
  final EmotionService _emotionService = EmotionService();

  Future<void> getEmotions() async {
    final res = await _emotionService.getEmotions();
    _emotions = res;
    notifyListeners();
  }

  void toggleEmotionSelection(int id, List<EmocionModel> emotions) {
    final emotion = _emotions.firstWhere((e) => e.id == id);
    if (emotion.selected) {
      emotion.selected = false;
      emotions.remove(emotion);
    } else {
      emotion.selected = true;
      emotions.add(emotion);
    }
    notifyListeners();
  }

  void clearEmotions() {
    for (var e in _emotions) {
      e.selected = false;
    }
    notifyListeners();
  }
}
