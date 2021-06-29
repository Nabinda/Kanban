class Board {
  int? userId;
  int? id;
  String? title;
  String? description;

  Board({
    this.userId,
    this.id,
    this.title,
    this.description,
  });

  factory Board.fromMap(Map<String, dynamic> json) => Board(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "id": id,
    "title": title,
    "description": description,
  };
}
