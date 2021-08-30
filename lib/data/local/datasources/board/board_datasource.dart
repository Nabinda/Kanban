import 'package:kanban/data/local/constants/db_constants.dart';
import 'package:kanban/models/board/board.dart';
import 'package:kanban/models/board/board_list.dart';
import 'package:sembast/sembast.dart';

class BoardDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _boardDataStore = intMapStoreFactory.store(DBConstants.STORE_BOARD);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  BoardDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Board board) async {
    final finder = Finder(filter: Filter.equals("id", board.id));
    var temp = await _boardDataStore.findFirst(
      _db,
      finder: finder,
    );

    if (temp == null) {
      return await _boardDataStore.add(_db, board.toMap());
    } else {
      return 0;
    }
  }

  Future<int> count() async {
    return await _boardDataStore.count(_db);
  }

  Future<List<Board>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _boardDataStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Board> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final board = Board.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      board.id = snapshot.key;
      return board;
    }).toList();
  }

  Future<BoardList> getBoardsFromDb(int projectId) async {
    // boardlist
    BoardList boardList = BoardList();

    // we use a Finder.
    final finder = Finder(filter: Filter.equals("projectId", projectId));

    // fetching data
    final recordSnapshots = await _boardDataStore.find(_db, finder: finder);

    // Making a List<Board> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      boardList = BoardList(
          boards: recordSnapshots.map((snapshot) {
        final board = Board.fromMap(snapshot.value);
        return board;
      }).toList());
    }

    return boardList;
  }

  Future<int> update(Board board) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", board.id));
    return await _boardDataStore.update(
      _db,
      board.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(int boardId) async {
    final finder = Finder(filter: Filter.equals("id", boardId));
    return await _boardDataStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _boardDataStore.drop(
      _db,
    );
  }

  Future<int> deleteByProjectId(int proId) async {
    var filter = Filter.equals('projectId', proId);
    var finder = Finder(filter: filter);
    return await _boardDataStore.delete(
      _db,
      finder: finder,
    );
  }
}
