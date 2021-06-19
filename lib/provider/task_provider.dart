import 'package:flutter/cupertino.dart';
import 'package:kanban/widgets/board_item_object.dart';
import 'package:kanban/widgets/board_list_object.dart';
class TaskProvider extends ChangeNotifier{
  List<BoardListObject> _list = [
    BoardListObject(title: "TO DO",
        items:[
      BoardItemObject(title: "Item 1"),
      BoardItemObject(title: "Item 2"),
      BoardItemObject(title: "Item 3")
    ]),
    BoardListObject(title: "List title 2",items: []),
    BoardListObject(title: "List title 3",items: [])
  ];

  //Fetch all board list
  List<BoardListObject> boardList(){
    return _list;
  }

  void addList(String text){
    print("I am Here");
    _list.add(BoardListObject(title: text, items:[]));
    notifyListeners();
  }

  void addListItem(int listIndex, String text){
    _list[listIndex].items.add(BoardItemObject(title: text));
    notifyListeners();
  }
  void deleteItem(index1, index2){
    _list[index1].items.removeAt(index2);
    notifyListeners();
  }
}
