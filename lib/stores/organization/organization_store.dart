import 'package:kanban/data/repository.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/project/project.dart';
import 'package:kanban/models/project/project_list.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'organization_store.g.dart';

class OrganizationStore = _OrganizationStore with _$OrganizationStore;

abstract class _OrganizationStore extends Organization with Store {
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  _OrganizationStore(
    Repository repository, {
    userId,
    id,
    title,
    description,
  }) : super(userId: userId, id: id, title: title, description: description) {
    this._repository = repository;
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<ProjectList?> emptyProjectResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<ProjectList?> fetchProjectFuture =
      ObservableFuture<ProjectList?>(emptyProjectResponse);

  @observable
  bool success = false;

  @computed
  bool get loading => fetchProjectFuture.status == FutureStatus.pending;

  @observable
  ObservableList<Project> projectList = ObservableList<Project>();

  // insert status :-----------------------------------------------------------
  static ObservableFuture<Project?> emptyProjectInsertResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<Project?> fetchProjectInsertFuture =
  ObservableFuture<Project?>(emptyProjectInsertResponse);

  @computed
  bool get insertLoading => fetchProjectInsertFuture.status == FutureStatus.pending;

  int getProjectIndex(proId) =>
      this.projectList.indexWhere((element) => element.id == proId);

  @action
  Future getProjects(int orgId) async {
    final future = _repository.getProjects(orgId);
    fetchProjectFuture = ObservableFuture(future);

    projectList.clear();
    future.then((projectList) {
      if (projectList.projects != null) {
        for (Project project in projectList.projects!) {
          this.projectList.add(project);
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<Project> insertProject(int orgId, String title, String description) async {
    Future<Project> future = _repository.insertProject(orgId, title, description);
    fetchProjectInsertFuture = ObservableFuture(future);
    future.then((project) {
      this.projectList.add(project);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  @action
  Future updateProject(Project project) async {
    final future = _repository.updateProject(project);
    // fetchPostsFuture = ObservableFuture(future);
    future.then((projectItem) {
      Project upProject =
      this.projectList.firstWhere((postItem) => postItem.id == project.id);
      int index = this.projectList.indexOf(upProject);
      this.projectList[index] = project;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future deleteProject(Project project) async {
    final future = _repository.deleteProject(project);
    //deletePostFuture = ObservableFuture(future);
    future.then((item) {
      this.projectList.removeWhere((element) => element.id == project.id);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  @action
  Future deleteAll() async {
    _repository.deleteAll();
  }
}
