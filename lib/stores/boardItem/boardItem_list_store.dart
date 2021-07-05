import 'package:kanban/data/repository.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/models/boardItem/boardItem_list.dart';
import 'package:kanban/stores/board/boardItem_store.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'boardItem_list_store.g.dart';

class BoardItemListStore = _BoardItemListStore with _$BoardItemListStore;

abstract class _BoardItemListStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _BoardItemListStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<BoardItemList?> emptyBoardResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<BoardItemList?> fetchBoardsFuture =
  ObservableFuture<BoardItemList?>(emptyBoardResponse);

  @observable
  ObservableList<BoardItemStore>? boardItemList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchBoardsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getBoardItems(int boardId) async {
    final future = _repository.getBoardItems(boardId);
    fetchBoardsFuture = ObservableFuture(future);

    future.then((boardList) {
      boardList.boardItemList!.forEach((element) {
        addBoardItem(element);
      });
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void addBoardItem(BoardItem boardItem) {
    BoardItemStore boardItemStore = BoardItemStore(_repository,
        boardId: boardItem.boardId,
        id: boardItem.id,
        title: boardItem.title,
        description: boardItem.description);
    boardItemList?.add(boardItemStore);
    // boardItemList.getProjects(boardItem.id!);
  }
}
