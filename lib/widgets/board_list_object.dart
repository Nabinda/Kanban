import 'package:kanban/widgets/board_item_object.dart';

class BoardListObject{

  String title = "";
  List<BoardItemObject> items = [];

  BoardListObject({title,items}){
    this.title = title;
    this.items = items;
  }
}
