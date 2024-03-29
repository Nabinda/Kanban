import 'package:kanban/data/repository.dart';
import 'package:kanban/models/board/board.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/models/boardItem/boardItem_list.dart';
import 'package:kanban/stores/board/boardItem_store.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'board_store.g.dart';

class BoardStore = _BoardStore with _$BoardStore;

abstract class _BoardStore extends Board with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _BoardStore(
    Repository repository, {
    projectId,
    id,
    title,
    description,
  }) : super(
            projectId: projectId,
            id: id,
            title: title,
            description: description) {
    this._repository = repository;
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<BoardItemList?> emptyBoardResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<BoardItemList?> fetchBoardsFuture =
      ObservableFuture<BoardItemList?>(emptyBoardResponse);

  @observable
  ObservableList<BoardItemStore> boardItemList =
      ObservableList<BoardItemStore>();

  @observable
  bool success = false;

  @computed
  bool get loading => fetchBoardsFuture.status == FutureStatus.pending;

  int getBoardItemIndex(boardItemId) =>
      this.boardItemList.indexWhere((element) => element.id == boardItemId);

  // actions:-------------------------------------------------------------------
  @action
  Future getBoardItems(int boardId) async {
    final future = _repository.getBoardItems(boardId);
    fetchBoardsFuture = ObservableFuture(future);

    future.then((boardItemList) {
      if (boardItemList.boardItemList != null) {
        for (BoardItem boardItem in boardItemList.boardItemList!) {
          addBoardItemList(boardItem);
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void addBoardItemList(BoardItem boardItem) {
    BoardItemStore boardItemStore = BoardItemStore(_repository,
        boardId: boardItem.boardId,
        id: boardItem.id,
        title: boardItem.title,
        description: boardItem.description);
    boardItemList.add(boardItemStore);
  }

}
