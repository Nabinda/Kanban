import 'package:mobx/mobx.dart';
part 'boardItem_store_validation.g.dart';

class BoardItemStoreValidation = _BoardItemStoreValidation with _$BoardItemStoreValidation;

abstract class _BoardItemStoreValidation with Store {
  // store for handling form errors
  BoardItemErrorStore boardItemErrorStore = BoardItemErrorStore();

  _BoardItemStoreValidation() {
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
  String title = '';

  @observable
  String description = '';

  @observable
  bool success = false;

  @observable
  bool loading = false;

  @computed
  bool get canAdd =>
      !boardItemErrorStore.hasErrorsValidation &&
          title.isNotEmpty &&
          description.isNotEmpty;

  // actions:-------------------------------------------------------------------
  @action
  void validateTitle(String value) {
    if (value.isEmpty) {
      boardItemErrorStore.title = "Title can't be empty";
    } else if (value.length <= 3) {
      boardItemErrorStore.title = "Title is short";
    } else {
      boardItemErrorStore.title = null;
    }
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
      boardItemErrorStore.description = "Description can't be empty";
    } else {
      boardItemErrorStore.description = null;
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

class BoardItemErrorStore = _BoardItemErrorStore with _$BoardItemErrorStore;

abstract class _BoardItemErrorStore with Store {
  @observable
  String? title;

  @observable
  String? description;

  @computed
  bool get hasErrorsValidation => title != null || description != null;
}
