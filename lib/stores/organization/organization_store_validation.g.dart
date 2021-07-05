// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_store_validation.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrganizationStoreValidation on _OrganizationStoreValidation, Store {
  Computed<bool>? _$canAddComputed;

  @override
  bool get canAdd => (_$canAddComputed ??= Computed<bool>(() => super.canAdd,
          name: '_OrganizationStoreValidation.canAdd'))
      .value;

  final _$titleAtom = Atom(name: '_OrganizationStoreValidation.title');

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$descriptionAtom =
      Atom(name: '_OrganizationStoreValidation.description');

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$successAtom = Atom(name: '_OrganizationStoreValidation.success');

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

  final _$loadingAtom = Atom(name: '_OrganizationStoreValidation.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$_OrganizationStoreValidationActionController =
      ActionController(name: '_OrganizationStoreValidation');

  @override
  void validateTitle(String value) {
    final _$actionInfo = _$_OrganizationStoreValidationActionController
        .startAction(name: '_OrganizationStoreValidation.validateTitle');
    try {
      return super.validateTitle(value);
    } finally {
      _$_OrganizationStoreValidationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitle(String value) {
    final _$actionInfo = _$_OrganizationStoreValidationActionController
        .startAction(name: '_OrganizationStoreValidation.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$_OrganizationStoreValidationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_OrganizationStoreValidationActionController
        .startAction(name: '_OrganizationStoreValidation.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$_OrganizationStoreValidationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateDescription(String value) {
    final _$actionInfo = _$_OrganizationStoreValidationActionController
        .startAction(name: '_OrganizationStoreValidation.validateDescription');
    try {
      return super.validateDescription(value);
    } finally {
      _$_OrganizationStoreValidationActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
description: ${description},
success: ${success},
loading: ${loading},
canAdd: ${canAdd}
    ''';
  }
}

mixin _$OrganizationErrorStore on _OrganizationErrorStore, Store {
  Computed<bool>? _$hasErrorsValidationComputed;

  @override
  bool get hasErrorsValidation => (_$hasErrorsValidationComputed ??=
          Computed<bool>(() => super.hasErrorsValidation,
              name: '_OrganizationErrorStore.hasErrorsValidation'))
      .value;

  final _$titleAtom = Atom(name: '_OrganizationErrorStore.title');

  @override
  String? get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String? value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$descriptionAtom = Atom(name: '_OrganizationErrorStore.description');

  @override
  String? get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String? value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  @override
  String toString() {
    return '''
title: ${title},
description: ${description},
hasErrorsValidation: ${hasErrorsValidation}
    ''';
  }
}
