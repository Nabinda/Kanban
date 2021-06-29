import 'dart:async';

import 'package:kanban/data/network/constants/endpoints.dart';
import 'package:kanban/data/network/dio_client.dart';
import 'package:kanban/data/network/rest_client.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/organization/organization_list.dart';

class OrganizationApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  OrganizationApi(this._dioClient, this._restClient);

  /// Returns list of organization in response
  Future<OrganizationList> getOrganizations() async {
    try {
      //final res = await _dioClient.get(Endpoints.getOrganizations);
      //return OrganizationList.fromJson(res);

      // Fake API
      List<Organization> organizations = [
        Organization(
          userId: 1,
          id: 2,
          title: "title 1",
          description: "desc 1",
        ),
        Organization(
          userId: 2,
          id: 3,
          title: "title 2",
          description: "desc 3",
        ),
        Organization(
          userId: 3,
          id: 4,
          title: "title 3",
          description: "desc 4",
        ),
      ];

      OrganizationList organizationList = OrganizationList(organizations: organizations);

      return await Future.delayed(Duration(seconds: 2), () => organizationList);

    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  /// sample api call with default rest client
//  Future<PostsList> getPosts() {
//
//    return _restClient
//        .get(Endpoints.getPosts)
//        .then((dynamic res) => PostsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
