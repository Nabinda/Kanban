// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BoardListStore on _BoardListStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_BoardListStore.loading'))
      .value;
  Computed<bool>? _$insertLoadingComputed;

  @override
  bool get insertLoading =>
      (_$insertLoadingComputed ??= Computed<bool>(() => super.insertLoading,
              name: '_BoardListStore.insertLoading'))
          .value;

  final _$fetchBoardsFutureAtom =
      Atom(name: '_BoardListStore.fetchBoardsFuture');

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

  final _$boardListAtom = Atom(name: '_BoardListStore.boardList');

  @override
  ObservableList<BoardStore> get boardList {
    _$boardListAtom.reportRead();
    return super.boardList;
  }

  @override
  set boardList(ObservableList<BoardStore> value) {
    _$boardListAtom.reportWrite(value, super.boardList, () {
      super.boardList = value;
    });
  }

  final _$successAtom = Atom(name: '_BoardListStore.success');

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

  final _$fetchBoardInsertFutureAtom =
      Atom(name: '_BoardListStore.fetchBoardInsertFuture');

  @override
  ObservableFuture<Board?> get fetchBoardInsertFuture {
    _$fetchBoardInsertFutureAtom.reportRead();
    return super.fetchBoardInsertFuture;
  }

  @override
  set fetchBoardInsertFuture(ObservableFuture<Board?> value) {
    _$fetchBoardInsertFutureAtom
        .reportWrite(value, super.fetchBoardInsertFuture, () {
      super.fetchBoardInsertFuture = value;
    });
  }

  final _$insertSuccessAtom = Atom(name: '_BoardListStore.insertSuccess');

  @override
  bool get insertSuccess {
    _$insertSuccessAtom.reportRead();
    return super.insertSuccess;
  }

  @override
  set insertSuccess(bool value) {
    _$insertSuccessAtom.reportWrite(value, super.insertSuccess, () {
      super.insertSuccess = value;
    });
  }

  final _$projectAtom = Atom(name: '_BoardListStore.project');

  @override
  Project? get project {
    _$projectAtom.reportRead();
    return super.project;
  }

  @override
  set project(Project? value) {
    _$projectAtom.reportWrite(value, super.project, () {
      super.project = value;
    });
  }

  final _$getBoardsAsyncAction = AsyncAction('_BoardListStore.getBoards');

  @override
  Future<dynamic> getBoards(int projectId) {
    return _$getBoardsAsyncAction.run(() => super.getBoards(projectId));
  }

  final _$insertBoardAsyncAction = AsyncAction('_BoardListStore.insertBoard');

  @override
  Future<Board> insertBoard(int proId, String title, String description) {
    return _$insertBoardAsyncAction
        .run(() => super.insertBoard(proId, title, description));
  }

  final _$deleteBoardAsyncAction = AsyncAction('_BoardListStore.deleteBoard');

  @override
  Future<dynamic> deleteBoard(Board board) {
    return _$deleteBoardAsyncAction.run(() => super.deleteBoard(board));
  }

  final _$_BoardListStoreActionController =
      ActionController(name: '_BoardListStore');

  @override
  void addBoard(Board board) {
    final _$actionInfo = _$_BoardListStoreActionController.startAction(
        name: '_BoardListStore.addBoard');
    try {
      return super.addBoard(board);
    } finally {
      _$_BoardListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProject(Project project) {
    final _$actionInfo = _$_BoardListStoreActionController.startAction(
        name: '_BoardListStore.setProject');
    try {
      return super.setProject(project);
    } finally {
      _$_BoardListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchBoardsFuture: ${fetchBoardsFuture},
boardList: ${boardList},
success: ${success},
fetchBoardInsertFuture: ${fetchBoardInsertFuture},
insertSuccess: ${insertSuccess},
project: ${project},
loading: ${loading},
insertLoading: ${insertLoading}
    ''';
  }
}
