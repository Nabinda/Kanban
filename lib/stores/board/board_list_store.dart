import 'package:kanban/data/repository.dart';
import 'package:kanban/models/board/board.dart';
import 'package:kanban/models/board/board_list.dart';
import 'package:kanban/stores/board/board_store.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'board_list_store.g.dart';

class BoardListStore = _BoardListStore with _$BoardListStore;

abstract class _BoardListStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _BoardListStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<BoardList?> emptyBoardResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<BoardList?> fetchBoardsFuture =
  ObservableFuture<BoardList?>(emptyBoardResponse);

  @observable
  ObservableList<BoardStore> boardList = ObservableList<BoardStore>();

  @observable
  bool success = false;

  @computed
  bool get loading => fetchBoardsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getBoards(int projectId) async {
    final future = _repository.getBoards(projectId);
    fetchBoardsFuture = ObservableFuture(future);

    boardList.clear();

    future.then((boardList) {
      if (boardList.boards != null) {
        for (Board board in boardList.boards!) {
          addBoard(board);
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void addBoard(Board board) {
    BoardStore boardStore = BoardStore(_repository,
        projectId: board.projectId,
        id: board.id,
        title: board.title,
        description: board.description);
    boardList.add(boardStore);
    boardStore.getBoardItems(board.id!);
  }
}