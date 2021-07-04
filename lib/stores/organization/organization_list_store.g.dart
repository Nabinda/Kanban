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

  final _$getOrganizationsAsyncAction =
      AsyncAction('_OrganizationListStore.getOrganizations');

  @override
  Future<dynamic> getOrganizations() {
    return _$getOrganizationsAsyncAction.run(() => super.getOrganizations());
  }

  final _$_OrganizationListStoreActionController =
      ActionController(name: '_OrganizationListStore');

  @override
  void addOrganization(Organization org) {
    final _$actionInfo = _$_OrganizationListStoreActionController.startAction(
        name: '_OrganizationListStore.addOrganization');
    try {
      return super.addOrganization(org);
    } finally {
      _$_OrganizationListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchOrganizationsFuture: ${fetchOrganizationsFuture},
organizationList: ${organizationList},
success: ${success},
loading: ${loading}
    ''';
  }
}
