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

class BoardScreen extends StatefulWidget {

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<BoardScreen> {
  final _form = GlobalKey<FormState>();
  String _inputText = "";
  var _listData = [];
  TextEditingController _textEditingController = new TextEditingController();
  BoardViewController _boardViewController = new BoardViewController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  _validate(String cate, int index) {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      setState(() {
        cate == "List" ? addList(_inputText) : addItem(index, _inputText);
      });
      _textEditingController.clear();
    }
  }

  void delete(int index1, int index2) {
    Provider.of<TaskProvider>(context, listen: false)
        .deleteItem(index1, index2);
  }

  void addList(String text) {
    Provider.of<TaskProvider>(context, listen: false).addList(text);
  }

  void addItem(int listIndex, String text) {
    Provider.of<TaskProvider>(context, listen: false)
        .addListItem(listIndex, text);
  }

  ///------------------Bottom Sheet---------------------///
  displayBottomSheet(context, String cate, int index) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value?.trim() == "") {
                            return 'Field must not be empty';
                          }
                          return null;
                        },
                        controller: _textEditingController,
                        onSaved: (value) {
                          _inputText = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: cate + " Name",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _validate(cate, index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 40.0),
                          height: 40,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.greenAccent),
                          child: Text("ADD"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _listData = Provider.of<TaskProvider>(context, listen: false).boardList();
    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i], i) as BoardList);
    }
    return Scaffold(
      //--------------Adding List Button----------------
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          displayBottomSheet(context, "List", 1);
        },
      ),
      //-------------------App Bar-------------------
      appBar: AppBar(
        title: Text("Task"),
        centerTitle: true,
      ),
      //-----------------------------Body--------------------
      body: BoardView(
        middleWidget: _middleWidget(),
        itemInMiddleWidget: (check) {
          print(check);
        },
        onDropItemInMiddleWidget: (index1, index2, double) {
          delete(index1!, index2!);
        },
        lists: _lists,
        boardViewController: _boardViewController,
      ),
    );
  }

  //------------------------Board Item-------------------------
  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem:
            (int? listIndex, int? itemIndex, BoardItemState state) {},
        onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
            int? oldItemIndex, BoardItemState state) {
          //Used to update our local item data
          var item = _listData[oldListIndex!].items[oldItemIndex];
          _listData[oldListIndex].items.removeAt(oldItemIndex);
          _listData[listIndex!].items.insert(itemIndex, item);
        },
        onTapItem:
            (int? listIndex, int? itemIndex, BoardItemState state) async {},
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title),
          ),
        ));
  }

  //-------------------------Board List-------------------------
  Widget _createBoardList(BoardListObject list, int listIndex) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]) as BoardItem);
    }
    return BoardList(
      footer: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          displayBottomSheet(context, "Item", listIndex);
        },
      ),
      onStartDragList: (int? listIndex) {},
      onTapList: (int? listIndex) async {},
      onDropList: (int? listIndex, int? oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex!];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex!, list);
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

  //--------------Delete Widget--------------------
  Widget _middleWidget() {
    return Positioned(
      bottom: 0,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.red),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Delete",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              )
            ],
          )),
    );
  }
}
