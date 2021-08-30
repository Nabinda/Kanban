import 'package:mobx/mobx.dart';
part 'board_store_validation.g.dart';

class BoardStoreValidation = _BoardStoreValidation with _$BoardStoreValidation;

abstract class _BoardStoreValidation with Store {
  // store for handling form errors
  BoardErrorStore boardErrorStore = BoardErrorStore();

  _BoardStoreValidation() {
    _setupValidations();
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupValidations() {
    _disposers = [
      reaction((_) => title, validateTitle),
      reaction((_) => description, validateDescription),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  int selectedOrgId = 0;

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  bool success = false;

  @observable
  bool loading = false;

  @computed
  bool get canAdd =>
      !boardErrorStore.hasErrorsValidation &&
      title.isNotEmpty &&
      description.isNotEmpty;

  // actions:-------------------------------------------------------------------
  @action
  void validateTitle(String value) {
    if (value.isEmpty) {
      boardErrorStore.title = "Title can't be empty";
    } else if (value.length <= 3) {
      boardErrorStore.title = "Title is short";
    } else {
      boardErrorStore.title = null;
    }
  }

  @action
  void setSelectedOrgId(int value) {
    this.selectedOrgId = value;
  }

  @action
  void setTitle(String value) {
    this.title = value;
  }

  @action
  void setDescription(String value) {
    this.description = value;
  }

  @action
  void validateDescription(String value) {
    if (value.isEmpty) {
      boardErrorStore.description = "Description can't be empty";
    } else {
      boardErrorStore.description = null;
    }
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void reset() {
    setTitle("");
    setDescription("");
  }

  void validateAll() {
    validateTitle(title);
    validateDescription(description);
  }
}

class BoardErrorStore = _BoardErrorStore with _$BoardErrorStore;

abstract class _BoardErrorStore with Store {
  @observable
  String? title;

  @observable
  String? description;

  @computed
  bool get hasErrorsValidation => title != null || description != null;
}
