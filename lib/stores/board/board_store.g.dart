// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BoardStore on _BoardStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_BoardStore.loading'))
      .value;

  final _$fetchBoardsFutureAtom = Atom(name: '_BoardStore.fetchBoardsFuture');

  @override
  ObservableFuture<BoardItemList?> get fetchBoardsFuture {
    _$fetchBoardsFutureAtom.reportRead();
    return super.fetchBoardsFuture;
  }

  @override
  set fetchBoardsFuture(ObservableFuture<BoardItemList?> value) {
    _$fetchBoardsFutureAtom.reportWrite(value, super.fetchBoardsFuture, () {
      super.fetchBoardsFuture = value;
    });
  }

  final _$boardItemListAtom = Atom(name: '_BoardStore.boardItemList');

  @override
  ObservableList<BoardItemStore> get boardItemList {
    _$boardItemListAtom.reportRead();
    return super.boardItemList;
  }

  @override
  set boardItemList(ObservableList<BoardItemStore> value) {
    _$boardItemListAtom.reportWrite(value, super.boardItemList, () {
      super.boardItemList = value;
    });
  }

  final _$successAtom = Atom(name: '_BoardStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$getBoardItemsAsyncAction = AsyncAction('_BoardStore.getBoardItems');

  @override
  Future<dynamic> getBoardItems(int boardId) {
    return _$getBoardItemsAsyncAction.run(() => super.getBoardItems(boardId));
  }

  final _$_BoardStoreActionController = ActionController(name: '_BoardStore');

  @override
  void addBoardItemList(BoardItem board) {
    final _$actionInfo = _$_BoardStoreActionController.startAction(
        name: '_BoardStore.addBoardItemList');
    try {
      return super.addBoardItemList(board);
    } finally {
      _$_BoardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchBoardsFuture: ${fetchBoardsFuture},
boardItemList: ${boardItemList},
success: ${success},
loading: ${loading}
    ''';
  }
}
