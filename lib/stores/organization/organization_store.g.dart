// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrganizationStore on _OrganizationStore, Store {
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

  final _$_OrganizationStoreActionController =
      ActionController(name: '_OrganizationStore');

  @override
  void addProject(Project project) {
    final _$actionInfo = _$_OrganizationStoreActionController.startAction(
        name: '_OrganizationStore.addProject');
    try {
      return super.addProject(project);
    } finally {
      _$_OrganizationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
projectList: ${projectList}
    ''';
  }
}
