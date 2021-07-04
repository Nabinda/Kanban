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

  _OrganizationStore(Repository repository, {
    userId,
    id,
    title,
    description,
  }) : super(userId: userId, id: id, title: title, description: description){
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

  @action
  Future getProjects(int orgId) async {
    final future = _repository.getProjects(orgId);
    fetchProjectFuture = ObservableFuture(future);

    future.then((projectList) {
      if(projectList.projects != null){
        for (Project project in projectList.projects!) {
          addProject(project);
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void addProject(Project project){
    projectList.add(project);
  }
}