class BoardItem {
  int? boardId;
  int? id;
  String? title;
  String? description;

  BoardItem({
    this.boardId,
    this.id,
    this.title,
    this.description,
  });

  factory BoardItem.fromMap(Map<String, dynamic> json) => BoardItem(
    boardId: json["boardId"],
    id: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "boardId": boardId,
    "id": id,
    "title": title,
    "description": description,
  };
}
