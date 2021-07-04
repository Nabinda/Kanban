import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/project/project.dart';
import 'package:mobx/mobx.dart';

part 'organization_store.g.dart';

class OrganizationStore = _OrganizationStore with _$OrganizationStore;

abstract class _OrganizationStore extends Organization with Store {

  _OrganizationStore({
    userId,
    id,
    title,
    description,
  }) : super(userId: userId, id: id, title: title, description: description);


  @observable
  ObservableList<Project> projectList = ObservableList<Project>();

  @action
  void addProject(Project project){
      projectList.add(project);
  }

}
