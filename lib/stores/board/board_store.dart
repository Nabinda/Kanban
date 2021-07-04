import 'package:kanban/data/repository.dart';
import 'package:kanban/models/board/board.dart';
import 'package:kanban/models/board/board_list.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'board_store.g.dart';

class BoardStore = _BoardStore with _$BoardStore;

abstract class _BoardStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _BoardStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<BoardList?> emptyBoardResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<BoardList?> fetchBoardsFuture =
  ObservableFuture<BoardList?>(emptyBoardResponse);

  @observable
  ObservableList<Board>? boardList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchBoardsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getBoards(int projectId) async {
    final future = _repository.getBoards(projectId);
    fetchBoardsFuture = ObservableFuture(future);

    future.then((boardList) {
      boardList.boards!.forEach((element) {
        this.boardList!.add(element);
      });
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
