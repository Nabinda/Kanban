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
  ObservableFuture<BoardList?> get fetchBoardsFuture {
    _$fetchBoardsFutureAtom.reportRead();
    return super.fetchBoardsFuture;
  }

  @override
  set fetchBoardsFuture(ObservableFuture<BoardList?> value) {
    _$fetchBoardsFutureAtom.reportWrite(value, super.fetchBoardsFuture, () {
      super.fetchBoardsFuture = value;
    });
  }

  final _$boardListAtom = Atom(name: '_BoardStore.boardList');

  @override
  BoardList? get boardList {
    _$boardListAtom.reportRead();
    return super.boardList;
  }

  @override
  set boardList(BoardList? value) {
    _$boardListAtom.reportWrite(value, super.boardList, () {
      super.boardList = value;
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

  final _$getBoardsAsyncAction = AsyncAction('_BoardStore.getBoards');

  @override
  Future<dynamic> getBoards(int projectId) {
    return _$getBoardsAsyncAction.run(() => super.getBoards(projectId));
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
