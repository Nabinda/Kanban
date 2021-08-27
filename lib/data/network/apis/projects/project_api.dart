import 'dart:async';

import 'package:kanban/data/network/dio_client.dart';
import 'package:kanban/models/project/project.dart';
import 'package:kanban/models/project/project_list.dart';

class ProjectApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  ProjectApi(this._dioClient);

  /// Returns list of organization in response
  Future<ProjectList> getProjects(int organizationId) async {
    try {
      //final res = await _dioClient.get(Endpoints.getProjects);
      //return ProjectList.fromJson(res);

      // Fake API
      List<Project> organizations = [
        Project(
          organizationId: 1,
          id: 1,
          title: "Summer Project",
          description: "desc lorem ipsum",
        ),
        Project(
          organizationId: 1,
          id: 2,
          title: "Todo",
          description: "desc lorem",
        ),
        Project(
          organizationId: 2,
          id: 2,
          title: "Daily Tasks",
          description: "desc lorem",
        ),
      ];

      List<Project> filteredProjects = organizations
          .where((item) => item.organizationId == organizationId)
          .toList();

      ProjectList organizationList = ProjectList(projects: filteredProjects);

      return await Future.delayed(Duration(seconds: 2), () => organizationList);
    } catch (e) {
      throw e;
    }
  }

  Future<Project> insertProject(
      int orgId, String title, String description) async {
    try {
      Project project = new Project(
          id: DateTime.now().millisecond,
          title: title,
          description: description,
          organizationId: orgId);

      return await Future.delayed(Duration(seconds: 2), () => project);
    } catch (e) {
      throw e;
    }
  }
}
