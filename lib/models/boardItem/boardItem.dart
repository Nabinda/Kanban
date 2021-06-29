class BoardItem {
  int? id;
  String? title;
  String? description;

  BoardItem({
    this.id,
    this.title,
    this.description,
  });

  factory BoardItem.fromMap(Map<String, dynamic> json) => BoardItem(
    id: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
  };
}
