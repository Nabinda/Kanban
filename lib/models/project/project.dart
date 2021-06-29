class Project {
  int? organizationId;
  int? id;
  String? title;
  String? description;

  Project({
    this.organizationId,
    this.id,
    this.title,
    this.description,
  });

  factory Project.fromMap(Map<String, dynamic> json) => Project(
    organizationId: json["organizationId"],
    id: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "organizationId": organizationId,
    "id": id,
    "title": title,
    "description": description,
  };
}
