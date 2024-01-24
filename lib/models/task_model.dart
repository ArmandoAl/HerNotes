class TaskModel {
  final String title;
  final String content;
  final String? date;
  final bool isDone;

  TaskModel({
    required this.title,
    required this.content,
    this.date,
    required this.isDone,
  });


  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        title: json["title"],
        content: json["content"],
        date: json["date"],
        isDone: json["isDone"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "date": date,
        "isDone": isDone,
      };
}
