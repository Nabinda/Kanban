// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boardItem_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BoardItemStore on _BoardItemStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_BoardItemStore.loading'))
      .value;

  final _$fetchBoardsFutureAtom =
      Atom(name: '_BoardItemStore.fetchBoardsFuture');

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

  final _$boardListAtom = Atom(name: '_BoardItemStore.boardList');

  @override
  ObservableList<BoardItem>? get boardList {
    _$boardListAtom.reportRead();
    return super.boardList;
  }

  @override
  set boardList(ObservableList<BoardItem>? value) {
    _$boardListAtom.reportWrite(value, super.boardList, () {
      super.boardList = value;
    });
  }

  final _$successAtom = Atom(name: '_BoardItemStore.success');

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
      AsyncAction('_BoardItemStore.getBoardItems');

  @override
  Future<dynamic> getBoardItems(int boardId) {
    return _$getBoardItemsAsyncAction.run(() => super.getBoardItems(boardId));
  }

  @override
  String toString() {
    return '''
fetchBoardsFuture: ${fetchBoardsFuture},
boardList: ${boardList},
success: ${success},
loading: ${loading}
    ''';
  }
}
