import 'package:kanban/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';
part 'post_store_validation.g.dart';

class PostStoreValidation = _PostStoreValidation with _$PostStoreValidation;

abstract class _PostStoreValidation with Store {
  // store for handling form errors
  final PostErrorStore organizationErrorStore = PostErrorStore();

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  _PostStoreValidation() {
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
  int id = 0;

  @observable
  int userId = 0;

  @observable
  String description = '';

  @observable
  bool success = false;

  @observable
  bool loading = false;

  @computed
  bool get canAdd =>
      !organizationErrorStore.hasErrorsValidation &&
      title.isNotEmpty &&
      description.isNotEmpty;

  // actions:-------------------------------------------------------------------
  @action
  void validateTitle(String value) {
    if (value.isEmpty) {
      organizationErrorStore.title = "Title can't be empty";
    } else if (value.length <= 10) {
      organizationErrorStore.title = "Title is short";
    } else {
      organizationErrorStore.title = null;
    }
  }

  @action
  void setTitle(String value) {
    this.title = value;
  }

  @action
  void setId(int value) {
    this.id = value;
  }

  @action
  void setUserId(int value) {
    this.userId = value;
  }

  @action
  void setDescription(String value) {
    this.description = value;
  }

  @action
  void validateDescription(String value) {
    if (value.isEmpty) {
      organizationErrorStore.description = "Description can't be empty";
    } else {
      organizationErrorStore.description = null;
    }
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validateTitle(title);
    validateDescription(description);
  }
}

class PostErrorStore = _PostErrorStore with _$PostErrorStore;

abstract class _PostErrorStore with Store {
  @observable
  String? title;

  @observable
  String? description;

  @computed
  bool get hasErrorsValidation => title != null || description != null;
}
