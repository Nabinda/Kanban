import 'package:kanban/data/repository.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

part 'boardItem_store.g.dart';

class BoardItemStore = _BoardItemStore with _$BoardItemStore;

abstract class _BoardItemStore extends BoardItem with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _BoardItemStore(
      Repository repository, {
        boardId,
        id,
        title,
        description,
      }) : super(boardId: boardId, id: id, title: title, description: description) {
    this._repository = repository;
  }

  // store variables:-----------------------------------------------------------
  // actions:-------------------------------------------------------------------
}
