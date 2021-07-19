// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrganizationStore on _OrganizationStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: '_OrganizationStore.loading'))
      .value;
  Computed<bool>? _$insertLoadingComputed;

  @override
  bool get insertLoading =>
      (_$insertLoadingComputed ??= Computed<bool>(() => super.insertLoading,
              name: '_OrganizationStore.insertLoading'))
          .value;

  final _$fetchProjectFutureAtom =
      Atom(name: '_OrganizationStore.fetchProjectFuture');

  @override
  ObservableFuture<ProjectList?> get fetchProjectFuture {
    _$fetchProjectFutureAtom.reportRead();
    return super.fetchProjectFuture;
  }

  @override
  set fetchProjectFuture(ObservableFuture<ProjectList?> value) {
    _$fetchProjectFutureAtom.reportWrite(value, super.fetchProjectFuture, () {
      super.fetchProjectFuture = value;
    });
  }

  final _$successAtom = Atom(name: '_OrganizationStore.success');

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

  final _$projectListAtom = Atom(name: '_OrganizationStore.projectList');

  @override
  ObservableList<Project> get projectList {
    _$projectListAtom.reportRead();
    return super.projectList;
  }

  @override
  set projectList(ObservableList<Project> value) {
    _$projectListAtom.reportWrite(value, super.projectList, () {
      super.projectList = value;
    });
  }

  final _$fetchProjectInsertFutureAtom =
      Atom(name: '_OrganizationStore.fetchProjectInsertFuture');

  @override
  ObservableFuture<Project?> get fetchProjectInsertFuture {
    _$fetchProjectInsertFutureAtom.reportRead();
    return super.fetchProjectInsertFuture;
  }

  @override
  set fetchProjectInsertFuture(ObservableFuture<Project?> value) {
    _$fetchProjectInsertFutureAtom
        .reportWrite(value, super.fetchProjectInsertFuture, () {
      super.fetchProjectInsertFuture = value;
    });
  }

  final _$insertSuccessAtom = Atom(name: '_OrganizationStore.insertSuccess');

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

  final _$getProjectsAsyncAction =
      AsyncAction('_OrganizationStore.getProjects');

  @override
  Future<dynamic> getProjects(int orgId) {
    return _$getProjectsAsyncAction.run(() => super.getProjects(orgId));
  }

  final _$insertProjectAsyncAction =
      AsyncAction('_OrganizationStore.insertProject');

  @override
  Future<Project> insertProject(int orgId, String title, String description) {
    return _$insertProjectAsyncAction
        .run(() => super.insertProject(orgId, title, description));
  }

  @override
  String toString() {
    return '''
fetchProjectFuture: ${fetchProjectFuture},
success: ${success},
projectList: ${projectList},
fetchProjectInsertFuture: ${fetchProjectInsertFuture},
insertSuccess: ${insertSuccess},
loading: ${loading},
insertLoading: ${insertLoading}
    ''';
  }
}
