import 'package:kanban/models/boardItem/boardItem.dart';

class BoardItemList {
  final List<BoardItem>? boardItemList;

  BoardItemList({
    this.boardItemList,
  });

  factory BoardItemList.fromJson(List<dynamic> json) {
    List<BoardItem> boardItemList = <BoardItem>[];
    boardItemList = json.map((post) => BoardItem.fromMap(post)).toList();

    return BoardItemList(
      boardItemList: boardItemList,
    );
  }
}
