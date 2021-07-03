import 'package:kanban/data/repository.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/organization/organization_list.dart';
import 'package:kanban/models/project/project_list.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'organization_store.g.dart';

class OrganizationStore = _OrganizationStore with _$OrganizationStore;

abstract class _OrganizationStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _OrganizationStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<OrganizationList?> emptyOrganizationResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<OrganizationList?> fetchOrganizationsFuture =
      ObservableFuture<OrganizationList?>(emptyOrganizationResponse);

  @observable
  OrganizationList? organizationList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchOrganizationsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getOrganizations() async {
    final future = _repository.getOrganizations();
    fetchOrganizationsFuture = ObservableFuture(future);

    future.then((organizationList) {
      if (organizationList.organizations != null) {
        for (Organization org in organizationList.organizations!) {
          final futureProjects = _repository.getProjects(org.id!);
          futureProjects.then((projectList) {
            org.projectList = projectList;
          }).catchError((error) {
            errorStore.errorMessage = DioErrorUtil.handleError(error);
          });
        }
        this.organizationList = organizationList;
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void addProjectToOrganization(int? orgId, ProjectList projectList) {
    Organization orgX =
        organizationList!.organizations!.firstWhere((org) => org.id == orgId);
    orgX.projectList = projectList;
  }
}
