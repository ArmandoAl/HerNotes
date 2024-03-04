class TaskModel {
  final int? id;
  final String title;
  final String content;
  final String? date;
  final bool? isDone;

  TaskModel({
    required this.title,
    required this.content,
    this.date,
    this.isDone,
    this.id,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        content: json["description"],
        date: json["createdDate"],
        isDone: json["isDone"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": content,
      };

  Map<String, dynamic> toSend() => {
        "title": title,
        "description": content,
      };
}
