import 'dart:convert';
import 'package:her_notes/Config/api_config.dart';
import 'package:her_notes/Domain/models/emocion_model.dart';
import 'package:her_notes/Data/http_client.dart';

class EmotionService {
  Future<List<EmocionModel>> getEmotions() async {
    try {
      final response = await ApiHttp.get(Uri.parse('$api/Emocion/GetAll'),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<EmocionModel> emotions =
            body.map((dynamic item) => EmocionModel.fromJson(item)).toList();
        return emotions;
      } else {
        throw "Can't get emotions.";
      }
    } catch (e) {
      throw "Can't get emotions.";
    }
  }
}
