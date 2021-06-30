import 'package:kanban/models/project/project.dart';

class ProjectList {
  final List<Project>? projects;

  ProjectList({
    this.projects,
  });

  factory ProjectList.fromJson(List<dynamic> json) {
    List<Project> projects = <Project>[];
    projects = json.map((organization) => Project.fromMap(organization)).toList();

    return ProjectList(
      projects: projects,
    );
  }
}
