import 'dart:async';

import 'package:kanban/data/network/dio_client.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/models/boardItem/boardItem_list.dart';

class BoardItemApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  BoardItemApi(this._dioClient);

  /// Returns list of organization in response
  Future<BoardItemList> getBoardItems(int boardId) async {
    try {
      //final res = await _dioClient.get(Endpoints.getBoards);
      //return BoardList.fromJson(res);

      // Fake API
      List<BoardItem> boardItems = [
        BoardItem(
          boardId: 1,
          id: 2,
          title: "title 1",
          description: "desc 1",
        ),
        BoardItem(
          boardId: 2,
          id: 3,
          title: "title 2",
          description: "desc 3",
        ),
        BoardItem(
          boardId: 3,
          id: 4,
          title: "title 3",
          description: "desc 4",
        ),
      ];

      List<BoardItem> filteredItems =
          boardItems.where((item) => item.boardId == boardId).toList();

      BoardItemList boardItemList = BoardItemList(boardItemList: filteredItems);

      return await Future.delayed(Duration(seconds: 2), () => boardItemList);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
