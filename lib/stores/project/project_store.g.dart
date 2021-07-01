// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProjectStore on _ProjectStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_ProjectStore.loading'))
      .value;

  final _$fetchBoardsFutureAtom = Atom(name: '_ProjectStore.fetchBoardsFuture');

  @override
  ObservableFuture<ProjectList?> get fetchBoardsFuture {
    _$fetchBoardsFutureAtom.reportRead();
    return super.fetchBoardsFuture;
  }

  @override
  set fetchBoardsFuture(ObservableFuture<ProjectList?> value) {
    _$fetchBoardsFutureAtom.reportWrite(value, super.fetchBoardsFuture, () {
      super.fetchBoardsFuture = value;
    });
  }

  final _$projectListAtom = Atom(name: '_ProjectStore.projectList');

  @override
  ProjectList? get projectList {
    _$projectListAtom.reportRead();
    return super.projectList;
  }

  @override
  set projectList(ProjectList? value) {
    _$projectListAtom.reportWrite(value, super.projectList, () {
      super.projectList = value;
    });
  }

  final _$successAtom = Atom(name: '_ProjectStore.success');

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

  final _$getProjectsAsyncAction = AsyncAction('_ProjectStore.getProjects');

  @override
  Future<dynamic> getProjects(int organizationId) {
    return _$getProjectsAsyncAction
        .run(() => super.getProjects(organizationId));
  }

  @override
  String toString() {
    return '''
fetchBoardsFuture: ${fetchBoardsFuture},
projectList: ${projectList},
success: ${success},
loading: ${loading}
    ''';
  }
}
