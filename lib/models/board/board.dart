import 'package:kanban/models/boardItem/boardItem.dart';

class Board {
  int? projectId;
  int? id;
  String? title;
  String? description;
  List<BoardItem>? boardItems;

  Board({
    this.projectId,
    this.id,
    this.title,
    this.description,
  });

  factory Board.fromMap(Map<String, dynamic> json) => Board(
        projectId: json["projectId"],
        id: json["id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "projectId": projectId,
        "id": id,
        "title": title,
        "description": description,
      };
}
