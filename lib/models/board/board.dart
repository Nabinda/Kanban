class Board {
  int? projectId;
  int? id;
  String? title;
  String? description;

  Board({
    this.projectId,
    this.id,
    this.title,
    this.description,
  });

  factory Board.fromMap(Map<String, dynamic> json) => Board(
    projectId: json["userId"],
    id: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "userId": projectId,
    "id": id,
    "title": title,
    "description": description,
  };
}
