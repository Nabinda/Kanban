import 'package:kanban/models/organization/organization.dart';

class OrganizationList {
  final List<Organization>? organizations;

  OrganizationList({
    this.organizations,
  });

  factory OrganizationList.fromJson(List<dynamic> json) {
    List<Organization> organizations = <Organization>[];
    organizations = json.map((organization) => Organization.fromMap(organization)).toList();

    return OrganizationList(
      organizations: organizations,
    );
  }
}
