import 'package:kanban/models/board/board.dart';

class BoardList {
  final List<Board>? boards;

  BoardList({
    this.boards,
  });

  factory BoardList.fromJson(List<dynamic> json) {
    List<Board> boards = <Board>[];
    boards = json.map((post) => Board.fromMap(post)).toList();

    return BoardList(
      boards: boards,
    );
  }
}
