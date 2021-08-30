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
          title: "Todo",
          description: "desc 1",
        ),
        Board(
          projectId: 1,
          id: 2,
          title: "Doing",
          description: "desc 3",
        ),
        Board(
          projectId: 1,
          id: 3,
          title: "Done",
          description: "desc 3",
        ),
        Board(
          projectId: 2,
          id: 2,
          title: "Todo",
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

  Future<Board> insertBoard(int proId, String title, String description) async {
    try {
      //final res = await _dioClient.post(Endpoints.getOrganization + organization.id.toString());
      //return OrganizationList.fromJson(res);

      Board brd = new Board(
          id: DateTime.now().millisecond,
          title: title,
          description: description,
          projectId: proId);

      return await Future.delayed(Duration(seconds: 2), () => brd);
    } catch (e) {
      throw e;
    }
  }
}
