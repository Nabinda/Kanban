import 'package:kanban/data/repository.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/models/boardItem/boardItem_list.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'boardItem_store.g.dart';

class BoardItemStore = _BoardItemStore with _$BoardItemStore;

abstract class _BoardItemStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _BoardItemStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<BoardItemList?> emptyBoardResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<BoardItemList?> fetchBoardsFuture =
  ObservableFuture<BoardItemList?>(emptyBoardResponse);

  @observable
  ObservableList<BoardItem>? boardList;

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
        this.boardList!.add(element);
      });
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
