import 'package:mobx/mobx.dart';
part 'project_store_validation.g.dart';

class ProjectStoreValidation = _ProjectStoreValidation
    with _$ProjectStoreValidation;

abstract class _ProjectStoreValidation with Store {
  // store for handling form errors
  ProjectErrorStore projectErrorStore =
  ProjectErrorStore();

  _ProjectStoreValidation() {
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
  int? selectedOrgId;

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
      !projectErrorStore.hasErrorsValidation &&
          title.isNotEmpty &&
          description.isNotEmpty;

  // actions:-------------------------------------------------------------------
  @action
  void validateTitle(String value) {
    if (value.isEmpty) {
      projectErrorStore.title = "Title can't be empty";
    } else if (value.length <= 10) {
      projectErrorStore.title = "Title is short";
    } else {
      projectErrorStore.title = null;
    }
  }

  @action
  void setSelectedOrgId(int? value) {
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
      projectErrorStore.description = "Description can't be empty";
    } else {
      projectErrorStore.description = null;
    }
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void reset(){
    setTitle("");
    setDescription("");
  }

  void validateAll() {
    validateTitle(title);
    validateDescription(description);
  }
}

class ProjectErrorStore = _ProjectErrorStore
    with _$ProjectErrorStore;

abstract class _ProjectErrorStore with Store {
  @observable
  String? title;

  @observable
  String? description;

  @computed
  bool get hasErrorsValidation => title != null || description != null;
}
