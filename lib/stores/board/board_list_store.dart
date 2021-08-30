import 'package:kanban/data/repository.dart';
import 'package:kanban/models/board/board.dart';
import 'package:kanban/models/board/board_list.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/models/project/project.dart';
import 'package:kanban/stores/board/board_store.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

import 'boardItem_store.dart';

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
  @observable
  Project? project;

  @observable
  ObservableList<BoardStore> boardList = ObservableList<BoardStore>();

  @observable
  bool success = false;

  static ObservableFuture<BoardList?> emptyBoardResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<BoardList?> fetchBoardsFuture =
      ObservableFuture<BoardList?>(emptyBoardResponse);

  @computed
  bool get loading => fetchBoardsFuture.status == FutureStatus.pending;

  // Insert Board Loading
  static ObservableFuture<Board?> emptyBoardInsertResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<Board?> fetchBoardInsertFuture =
      ObservableFuture<Board?>(emptyBoardInsertResponse);

  @computed
  bool get insertBoardLoading =>
      fetchBoardInsertFuture.status == FutureStatus.pending;

  // Delete Board Loading
  static ObservableFuture<int?> emptyBoardDeleteResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<int?> boardDeleteFuture =
  ObservableFuture<int?>(emptyBoardDeleteResponse);

  @computed
  bool get deleteBoardLoading =>
      boardDeleteFuture.status == FutureStatus.pending;

  // Insert BoardItem Loading
  static ObservableFuture<BoardItem?> emptyBoardItemInsertResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<BoardItem?> boardItemInsertFuture =
      ObservableFuture<BoardItem?>(emptyBoardItemInsertResponse);

  @computed
  bool get insertBoardItemLoading =>
      boardItemInsertFuture.status == FutureStatus.pending;

  // Delete BoardItem Loading
  static ObservableFuture<int?> emptyBoardItemDeleteResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<int?> boardItemDeleteFuture =
      ObservableFuture<int?>(emptyBoardItemDeleteResponse);

  @computed
  bool get deleteBoardItemLoading =>
      boardItemDeleteFuture.status == FutureStatus.pending;

  // helpers
  int getBoardIndex(boardId) =>
      this.boardList.indexWhere((element) => element.id == boardId);

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

  @action
  void setProject(Project project) {
    this.project = project;
  }

  @action
  Future<Board> insertBoard(int proId, String title, String description) async {
    Future<Board> future = _repository.insertBoard(proId, title, description);
    fetchBoardInsertFuture = ObservableFuture(future);
    future.then((brd) {
      BoardStore boardStore = BoardStore(_repository,
          projectId: brd.projectId,
          id: brd.id,
          title: brd.title,
          description: brd.description);
      this.boardList.add(boardStore);
      boardStore.getBoardItems(brd.id!);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  @action
  Future deleteBoard(Board board) async {
    final future = _repository.deleteBoard(board.id!);
    boardDeleteFuture = ObservableFuture(future);
    future.then((item) {
      this.boardList.removeWhere((element) => element.id == board.id);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  // BoardItem
  @action
  Future<BoardItem> insertBoardItem(
      int boardId, String title, String description) async {
    Future<BoardItem> future =
        _repository.insertBoardItem(boardId, title, description);
    boardItemInsertFuture = ObservableFuture(future);
    future.then((boardItem) {
      BoardItemStore boardItemStore = BoardItemStore(_repository,
          boardId: boardId,
          id: boardItem.id,
          title: boardItem.title,
          description: boardItem.description);

      this.boardList[getBoardIndex(boardId)].boardItemList.add(boardItemStore);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  @action
  Future<int> deleteBoardItem(int boardIndex, int boardItemIndex) async {
    BoardStore boardStore = this.boardList[boardIndex];
    BoardItemStore boardItemStore = boardStore.boardItemList[boardItemIndex];
    Future<int> future = _repository.deleteBoardItem(boardItemStore.id!);
    boardItemDeleteFuture = ObservableFuture(future);
    future.then((item) {
      this.boardList[boardIndex].boardItemList.remove(boardItemStore);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }
}
