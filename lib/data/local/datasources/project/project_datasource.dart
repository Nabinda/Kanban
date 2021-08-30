import 'package:kanban/data/local/constants/db_constants.dart';
import 'package:kanban/models/project/project.dart';
import 'package:kanban/models/project/project_list.dart';
import 'package:sembast/sembast.dart';

class ProjectDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _projectDataStore =
  intMapStoreFactory.store(DBConstants.STORE_PROJECT);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  ProjectDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Project project) async {
    final finder = Finder(filter: Filter.equals("id", project.id));
    var temp = await _projectDataStore.findFirst(
      _db,
      finder: finder,
    );

    if (temp == null) {
      return await _projectDataStore.add(_db, project.toMap());
    } else {
      return 0;
    }
  }

  Future<int> count() async {
    return await _projectDataStore.count(_db);
  }

  Future<List<Project>> getAllSortedByFilter(
      {List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _projectDataStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Project> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final project = Project.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      project.id = snapshot.key;
      return project;
    }).toList();
  }

  Future<ProjectList> getProjectsFromDb(int orgId) async {
    // project list
    ProjectList projectList = ProjectList();

    // we use a Finder.
    final finder = Finder(filter: Filter.equals("organizationId", orgId));

    // fetching data
    final recordSnapshots = await _projectDataStore.find(
      _db,
      finder: finder
    );

    // Making a List<Project> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      projectList = ProjectList(
          projects: recordSnapshots.map((snapshot) {
            final project = Project.fromMap(snapshot.value);
            return project;
          }).toList());
    }

    return projectList;
  }

  Future<int> update(Project project) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", project.id));
    return await _projectDataStore.update(
      _db,
      project.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Project project) async {
    final finder = Finder(filter: Filter.equals("id", project.id));
    return await _projectDataStore.delete(
      _db,
      finder: finder,
    );
  }

  Future<int> deleteByOrganizationId(int orgId) async {
    var filter = Filter.equals('organizationId', orgId);
    var finder = Finder(filter: filter);
    return await _projectDataStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _projectDataStore.drop(
      _db,
    );
  }
}
