import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String title;
  String content;
  String date;
  double mood;

  NotesModel({
    required this.title,
    required this.content,
    required this.date,
    required this.mood,
  });

  factory NotesModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotesModel(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      mood: data['mood'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'date': date,
      'mood': mood,
    };
  }
}
