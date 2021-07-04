import 'package:kanban/models/project/project_list.dart';

class Organization {
  int? userId;
  int? id;
  String? title;
  String? description;

  Organization({
    this.userId,
    this.id,
    this.title,
    this.description,
  });

  factory Organization.fromMap(Map<String, dynamic> json) => Organization(
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
