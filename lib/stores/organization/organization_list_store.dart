import 'package:kanban/data/repository.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/organization/organization_list.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/stores/organization/organization_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'organization_list_store.g.dart';

class OrganizationListStore = _OrganizationListStore
    with _$OrganizationListStore;

abstract class _OrganizationListStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _OrganizationListStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<OrganizationList?> emptyOrganizationResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<OrganizationList?> fetchOrganizationsFuture =
      ObservableFuture<OrganizationList?>(emptyOrganizationResponse);

  @observable
  ObservableList<OrganizationStore> organizationList =
      ObservableList<OrganizationStore>();

  @observable
  bool success = false;

  @computed
  bool get loading => fetchOrganizationsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getOrganizations() async {
    final future = _repository.getOrganizations();
    fetchOrganizationsFuture = ObservableFuture(future);

    organizationList.clear();

    future.then((organizationList) {
      if (organizationList.organizations != null) {
        for (Organization organization in organizationList.organizations!) {
          addOrganization(organization);
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void addOrganization(Organization org) {
    OrganizationStore organizationStore = OrganizationStore(_repository,
        userId: org.userId,
        id: org.id,
        title: org.title,
        description: org.description);
    organizationList.add(organizationStore);
    organizationStore.getProjects(org.id!);
  }
}
