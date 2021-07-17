import 'package:kanban/data/local/constants/db_constants.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/organization/organization_list.dart';
import 'package:sembast/sembast.dart';

class OrganizationDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _organizationsStore =
      intMapStoreFactory.store(DBConstants.STORE_ORGANIZATION);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  OrganizationDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Organization organization) async {
    return await _organizationsStore.add(_db, organization.toMap());
  }

  Future<int> count() async {
    return await _organizationsStore.count(_db);
  }

  Future<List<Organization>> getAllSortedByFilter(
      {List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _organizationsStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Organization> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final organization = Organization.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      organization.id = snapshot.key;
      return organization;
    }).toList();
  }

  Future<OrganizationList> getOrganizationsFromDb() async {
    print('Loading from database');

    // organization list
    var organizationList;

    // fetching data
    final recordSnapshots = await _organizationsStore.find(
      _db,
    );

    // Making a List<Organization> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      organizationList = OrganizationList(
          organizations: recordSnapshots.map((snapshot) {
        final organization = Organization.fromMap(snapshot.value);
        // An ID is a key of a record from the database.
        organization.id = snapshot.key;
        return organization;
      }).toList());
    }

    return organizationList;
  }

  Future<int> update(Organization organization) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(organization.id));
    return await _organizationsStore.update(
      _db,
      organization.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Organization organization) async {
    final finder = Finder(filter: Filter.byKey(organization.id));
    return await _organizationsStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _organizationsStore.drop(
      _db,
    );
  }
}
