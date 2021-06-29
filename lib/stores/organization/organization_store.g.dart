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

  final _$fetchOrganizationsFutureAtom =
      Atom(name: '_OrganizationStore.fetchOrganizationsFuture');

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
      Atom(name: '_OrganizationStore.organizationList');

  @override
  OrganizationList? get organizationList {
    _$organizationListAtom.reportRead();
    return super.organizationList;
  }

  @override
  set organizationList(OrganizationList? value) {
    _$organizationListAtom.reportWrite(value, super.organizationList, () {
      super.organizationList = value;
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

  final _$getOrganizationsAsyncAction =
      AsyncAction('_OrganizationStore.getOrganizations');

  @override
  Future<dynamic> getOrganizations() {
    return _$getOrganizationsAsyncAction.run(() => super.getOrganizations());
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
