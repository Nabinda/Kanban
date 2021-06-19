import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:kanban/provider/task_provider.dart';
import 'package:kanban/widgets/board_item_object.dart';
import 'package:kanban/widgets/board_list_object.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  static const routeName = "/task_screen";

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  var _listData = [];
  BoardViewController _boardViewController = new BoardViewController();
  void delete(int index1, int index2){
    Provider.of<TaskProvider>(context,listen: false).deleteItem(index1, index2);
  }
  @override
  Widget build(BuildContext context) {
      _listData = Provider.of<TaskProvider>(context,listen: false).boardList();
    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]) as BoardList);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Task"),
        centerTitle: true,
      ),
    body:  BoardView(
      middleWidget: _middleWidget(),
      itemInMiddleWidget: (check){
        print(check);
      },
      onDropItemInMiddleWidget: (index1, index2, double){
        delete(index1 , index2);},
      lists: _lists,
      boardViewController: _boardViewController,
    ),
    );
  }

  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {

        },
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {
          //Used to update our local item data
          var item = _listData[oldListIndex].items[oldItemIndex];
          _listData[oldListIndex].items.removeAt(oldItemIndex);
          _listData[listIndex].items.insert(itemIndex, item);
        },
        onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {

        },
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title),
          ),
        ));
  }

  Widget _createBoardList(BoardListObject list) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]) as BoardItem);
    }
    return BoardList(
      footer: IconButton(icon:Icon(Icons.add),onPressed: (){

        setState(() {
          Provider.of<TaskProvider>(context,listen: false).add("Test");
        });

      },),
      onStartDragList: (int listIndex) {

      },
      onTapList: (int listIndex) async {

      },
      onDropList: (int listIndex, int oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex, list);
      },
      headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
      backgroundColor: Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title,
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }

  Widget _middleWidget(){
    return Positioned(bottom: 0,child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.red
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Delete",style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500
            ),),
            Icon(Icons.delete,color: Colors.white,size: 20,)
          ],
        )),);
  }
}
