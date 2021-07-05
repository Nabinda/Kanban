import 'dart:async';

import 'package:kanban/data/network/dio_client.dart';
import 'package:kanban/models/board/board.dart';
import 'package:kanban/models/board/board_list.dart';

class BoardApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  BoardApi(this._dioClient);

  /// Returns list of organization in response
  Future<BoardList> getBoards(int projectId) async {
    try {
      //final res = await _dioClient.get(Endpoints.getBoards);
      //return BoardList.fromJson(res);

      // Fake API
      List<Board> boards = [
        Board(
          projectId: 1,
          id: 1,
          title: "Project 1 Board 1",
          description: "desc 1",
        ),
        Board(
          projectId: 1,
          id: 2,
          title: "Project 1 Board 2",
          description: "desc 3",
        ),
        Board(
          projectId: 1,
          id: 3,
          title: "Project 1 Board 3",
          description: "desc 3",
        ),
        Board(
          projectId: 2,
          id: 2,
          title: "Project 2 Board 1",
          description: "desc 4",
        ),
      ];

      List<Board> filteredBoards =
          boards.where((item) => item.projectId == projectId).toList();

      BoardList boardList = BoardList(boards: filteredBoards);

      return await Future.delayed(Duration(seconds: 1), () => boardList);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
