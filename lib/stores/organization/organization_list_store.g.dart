// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrganizationListStore on _OrganizationListStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: '_OrganizationListStore.loading'))
      .value;
  Computed<bool>? _$insertLoadingComputed;

  @override
  bool get insertLoading =>
      (_$insertLoadingComputed ??= Computed<bool>(() => super.insertLoading,
              name: '_OrganizationListStore.insertLoading'))
          .value;

  final _$fetchOrganizationsFutureAtom =
      Atom(name: '_OrganizationListStore.fetchOrganizationsFuture');

  @override
  ObservableFuture<OrganizationList?> get fetchOrganizationsFuture {
    _$fetchOrganizationsFutureAtom.reportRead();
    return super.fetchOrganizationsFuture;
  }

  @override
  set fetchOrganizationsFuture(ObservableFuture<OrganizationList?> value) {
    _$fetchOrganizationsFutureAtom
        .reportWrite(value, super.fetchOrganizationsFuture, () {
      super.fetchOrganizationsFuture = value;
    });
  }

  final _$organizationListAtom =
      Atom(name: '_OrganizationListStore.organizationList');

  @override
  ObservableList<OrganizationStore> get organizationList {
    _$organizationListAtom.reportRead();
    return super.organizationList;
  }

  @override
  set organizationList(ObservableList<OrganizationStore> value) {
    _$organizationListAtom.reportWrite(value, super.organizationList, () {
      super.organizationList = value;
    });
  }

  final _$successAtom = Atom(name: '_OrganizationListStore.success');

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

  final _$fetchOrganizationInsertFutureAtom =
      Atom(name: '_OrganizationListStore.fetchOrganizationInsertFuture');

  @override
  ObservableFuture<Organization?> get fetchOrganizationInsertFuture {
    _$fetchOrganizationInsertFutureAtom.reportRead();
    return super.fetchOrganizationInsertFuture;
  }

  @override
  set fetchOrganizationInsertFuture(ObservableFuture<Organization?> value) {
    _$fetchOrganizationInsertFutureAtom
        .reportWrite(value, super.fetchOrganizationInsertFuture, () {
      super.fetchOrganizationInsertFuture = value;
    });
  }

  final _$insertSuccessAtom =
      Atom(name: '_OrganizationListStore.insertSuccess');

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

  final _$getOrganizationsAsyncAction =
      AsyncAction('_OrganizationListStore.getOrganizations');

  @override
  Future<dynamic> getOrganizations() {
    return _$getOrganizationsAsyncAction.run(() => super.getOrganizations());
  }

  final _$insertOrganizationsAsyncAction =
      AsyncAction('_OrganizationListStore.insertOrganizations');

  @override
  Future<Organization> insertOrganizations(String title, String description) {
    return _$insertOrganizationsAsyncAction
        .run(() => super.insertOrganizations(title, description));
  }

  final _$deleteOrganizationAsyncAction =
      AsyncAction('_OrganizationListStore.deleteOrganization');

  @override
  Future<dynamic> deleteOrganization(Organization org) {
    return _$deleteOrganizationAsyncAction
        .run(() => super.deleteOrganization(org));
  }

  final _$updateOrganizationAsyncAction =
      AsyncAction('_OrganizationListStore.updateOrganization');

  @override
  Future<dynamic> updateOrganization(Organization org) {
    return _$updateOrganizationAsyncAction
        .run(() => super.updateOrganization(org));
  }

  final _$insertProjectAsyncAction =
      AsyncAction('_OrganizationListStore.insertProject');

  @override
  Future<Project> insertProject(int orgId, String title, String description) {
    return _$insertProjectAsyncAction
        .run(() => super.insertProject(orgId, title, description));
  }

  @override
  String toString() {
    return '''
fetchOrganizationsFuture: ${fetchOrganizationsFuture},
organizationList: ${organizationList},
success: ${success},
fetchOrganizationInsertFuture: ${fetchOrganizationInsertFuture},
insertSuccess: ${insertSuccess},
loading: ${loading},
insertLoading: ${insertLoading}
    ''';
  }
}
