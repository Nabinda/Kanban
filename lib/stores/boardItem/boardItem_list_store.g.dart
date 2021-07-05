// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boardItem_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BoardItemListStore on _BoardItemListStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: '_BoardItemListStore.loading'))
      .value;

  final _$fetchBoardsFutureAtom =
      Atom(name: '_BoardItemListStore.fetchBoardsFuture');

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

  final _$boardItemListAtom = Atom(name: '_BoardItemListStore.boardItemList');

  @override
  ObservableList<BoardItemStore>? get boardItemList {
    _$boardItemListAtom.reportRead();
    return super.boardItemList;
  }

  @override
  set boardItemList(ObservableList<BoardItemStore>? value) {
    _$boardItemListAtom.reportWrite(value, super.boardItemList, () {
      super.boardItemList = value;
    });
  }

  final _$successAtom = Atom(name: '_BoardItemListStore.success');

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

  final _$getBoardItemsAsyncAction =
      AsyncAction('_BoardItemListStore.getBoardItems');

  @override
  Future<dynamic> getBoardItems(int boardId) {
    return _$getBoardItemsAsyncAction.run(() => super.getBoardItems(boardId));
  }

  final _$_BoardItemListStoreActionController =
      ActionController(name: '_BoardItemListStore');

  @override
  void addBoardItem(BoardItem boardItem) {
    final _$actionInfo = _$_BoardItemListStoreActionController.startAction(
        name: '_BoardItemListStore.addBoardItem');
    try {
      return super.addBoardItem(boardItem);
    } finally {
      _$_BoardItemListStoreActionController.endAction(_$actionInfo);
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
