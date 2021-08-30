import 'package:kanban/data/local/constants/db_constants.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/models/boardItem/boardItem_list.dart';
import 'package:sembast/sembast.dart';

class BoardItemDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _boardItemDataSource =
  intMapStoreFactory.store(DBConstants.STORE_BOARD_ITEM);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  BoardItemDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(BoardItem boardItem) async {
    final finder = Finder(filter: Filter.equals("id", boardItem.id));
    var temp = await _boardItemDataSource.findFirst(
      _db,
      finder: finder,
    );

    if (temp == null) {
      return await _boardItemDataSource.add(_db, boardItem.toMap());
    } else {
      return 0;
    }
  }

  Future<int> count() async {
    return await _boardItemDataSource.count(_db);
  }

  Future<List<BoardItem>> getAllSortedByFilter(
      {List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _boardItemDataSource.find(
      _db,
      finder: finder,
    );

    // Making a List<BoardItem> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final boardItem= BoardItem.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      boardItem.id = snapshot.key;
      return boardItem;
    }).toList();
  }

  Future<BoardItemList> getBoardItemsFromDb(int boardId) async {
    // boardlist
    BoardItemList boardItemList = BoardItemList();

    // we use a Finder.
    final finder = Finder(filter: Filter.equals("boardId", boardId));

    // fetching data
    final recordSnapshots = await _boardItemDataSource.find(
        _db,
        finder: finder
    );

    // Making a List<BoardItem> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      boardItemList = BoardItemList(
          boardItemList: recordSnapshots.map((snapshot) {
            final boardItem= BoardItem.fromMap(snapshot.value);
            return boardItem;
          }).toList());
    }

    return boardItemList;
  }

  Future<int> update(BoardItem boardItem) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", boardItem.id));
    return await _boardItemDataSource.update(
      _db,
      boardItem.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(BoardItem boardItem) async {
    final finder = Finder(filter: Filter.equals("id", boardItem.id));
    return await _boardItemDataSource.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _boardItemDataSource.drop(
      _db,
    );
  }

  Future<int> deleteByBoardId(int boardId) async {
    var filter = Filter.equals('boardId', boardId);
    var finder = Finder(filter: filter);
    return await _boardItemDataSource.delete(
      _db,
      finder: finder,
    );
  }
}
