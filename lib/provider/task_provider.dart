import 'package:kanban/widgets/board_item_object.dart';
import 'package:kanban/widgets/board_list_object.dart';
import 'package:get/get.dart';
class TaskProvider{
  List<BoardListObject> list = [
    BoardListObject(title: "TO DO",items:[
      BoardItemObject(title: "Item 1"),
      BoardItemObject(title: "Item 2"),
      BoardItemObject(title: "Item 3")
    ]),
    BoardListObject(title: "List title 2"),
    BoardListObject(title: "List title 3")
  ].obs;

  void add(String text){
    print("I am here");
    list[0].items.add(BoardItemObject(title: "Item4"));
    obs();
  }
}
