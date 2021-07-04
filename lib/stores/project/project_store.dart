import 'package:kanban/data/repository.dart';
import 'package:kanban/models/project/project_list.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'project_store.g.dart';

class ProjectStore = _ProjectStore with _$ProjectStore;

abstract class _ProjectStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _ProjectStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<ProjectList?> emptyBoardResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<ProjectList?> fetchBoardsFuture =
      ObservableFuture<ProjectList?>(emptyBoardResponse);

  @observable
  ProjectList? projectList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchBoardsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getProjects(int organizationId) async {
    final future = _repository.getProjects(organizationId);
    fetchBoardsFuture = ObservableFuture(future);

    future.then((projectList) {
      this.projectList = projectList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
