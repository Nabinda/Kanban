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
          title: "Project 1 for Org 1",
          description: "desc lorem ipsum",
        ),
        Project(
          organizationId: 1,
          id: 2,
          title: "Project 2 for Org 1",
          description: "desc lorem",
        ),
        Project(
          organizationId: 2,
          id: 2,
          title: "Project 1 for Org 2",
          description: "desc lorem",
        ),
      ];

      List<Project> filteredProjects = organizations
          .where((item) => item.organizationId == organizationId)
          .toList();

      ProjectList organizationList =
          ProjectList(projects: filteredProjects);

      return await Future.delayed(Duration(seconds: 2), () => organizationList);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}