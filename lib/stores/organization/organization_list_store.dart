import 'package:kanban/data/repository.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/organization/organization_list.dart';
import 'package:kanban/models/project/project.dart';
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

  // store variables:-----------------------------------------------------------
  static ObservableFuture<Organization?> emptyOrganizationInsertResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<Organization?> fetchOrganizationInsertFuture =
  ObservableFuture<Organization?>(emptyOrganizationInsertResponse);

  @observable
  bool insertSuccess = false;

  @computed
  bool get insertLoading => fetchOrganizationInsertFuture.status == FutureStatus.pending;

  int getOrganizationIndex(orgId) =>
    this.organizationList.indexWhere((element) => element.id == orgId);

  // actions:-------------------------------------------------------------------
  @action
  Future getOrganizations() async {
    final future = _repository.getOrganizations();
    fetchOrganizationsFuture = ObservableFuture(future);
    organizationList.clear();
    future.then((organizationList) {
      if (organizationList.organizations != null) {
        for (Organization org in organizationList.organizations!) {
          OrganizationStore organizationStore = OrganizationStore(_repository,
              userId: org.userId,
              id: org.id,
              title: org.title,
              description: org.description);
          this.organizationList.add(organizationStore);
          organizationStore.getProjects(org.id!);
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<Organization> insertOrganizations(String title, String description) async {
    Future<Organization> future = _repository.insertOrganization(title, description);
    fetchOrganizationInsertFuture = ObservableFuture(future);
    future.then((org) {
      OrganizationStore organizationStore = OrganizationStore(_repository,
          userId: org.userId,
          id: org.id,
          title: org.title,
          description: org.description);
      this.organizationList.add(organizationStore);
      organizationStore.getProjects(org.id!);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  @action
  Future deleteOrganization(Organization org) async {
    final future = _repository.deleteOrganization(org);
    //deletePostFuture = ObservableFuture(future);
    future.then((item) {
      this.organizationList.removeWhere((orgItem) => orgItem.id==org.id);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future updateOrganization(Organization org) async {
    final future = _repository.updateOrganization(org);
    // fetchPostsFuture = ObservableFuture(future);
    future.then((orgItem) {
      Organization upOrg =
      this.organizationList.firstWhere((postItem) => postItem.id == org.id);
      int index = this.organizationList.indexOf(upOrg);
      // this.organizationList[index] = org;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<Project> insertProject(int orgId, String title, String description) async {
    OrganizationStore organizationStore = this.organizationList.firstWhere((element) => element.id == orgId);
    return organizationStore.insertProject(orgId, title, description);
  }
}
