import 'dart:async';

import 'package:kanban/data/network/dio_client.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/organization/organization_list.dart';

class OrganizationApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  OrganizationApi(this._dioClient);

  /// Returns list of organization in response
  Future<OrganizationList> getOrganizations() async {
    try {
      //final res = await _dioClient.get(Endpoints.getOrganizations);
      //return OrganizationList.fromJson(res);

      // Fake API
      List<Organization> organizations = [
        Organization(
          userId: 1,
          id: 1,
          title: "Organization 1",
          description: "desc lorem",
        ),
        Organization(
          userId: 1,
          id: 2,
          title: "Organization 2",
          description: "lorem ipsum doret",
        ),
        Organization(
          userId: 1,
          id: 3,
          title: "Organization 3",
          description: "lorem ipsum doret",
        ),
      ];

      OrganizationList organizationList =
          OrganizationList(organizations: organizations);

      return await Future.delayed(Duration(seconds: 1), () => organizationList);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Organization> insertOrganizations(String title, String description) async {
    try {
      //final res = await _dioClient.post(Endpoints.getOrganization + organization.id.toString());
      //return OrganizationList.fromJson(res);

      Organization org = new Organization(
          id: DateTime.now().millisecond,
          title: title,
          description: description,
          userId: 1);

      return await Future.delayed(Duration(seconds: 1), () => org);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
