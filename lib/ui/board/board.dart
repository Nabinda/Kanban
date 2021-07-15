import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kanban/stores/board/boardItem_store.dart';
import 'package:kanban/stores/board/board_list_store.dart';
import 'package:kanban/stores/board/board_store.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:kanban/widgets/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  //stores:---------------------------------------------------------------------
  late BoardListStore _boardListStore;
  late ThemeStore _themeStore;
  BoardViewController boardViewController = new BoardViewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _themeStore = Provider.of<ThemeStore>(context);
    _boardListStore = Provider.of<BoardListStore>(context);

    // check to see if already called api
    if (!_boardListStore.loading) {
      _boardListStore.getBoards(_boardListStore.project!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

// app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        _boardListStore.project!.title!,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildProjectsContent(),
      ],
    );
  }

  Widget _buildProjectsContent() {
    return Observer(builder: (context) {
      if (_boardListStore.loading) {
        return CustomProgressIndicatorWidget();
      } else {
        List<BoardList> _lists = [];

        for (int i = 0; i < _boardListStore.boardList.length; i++) {
          _lists.add(
              _createBoardList(_boardListStore.boardList[i], i) as BoardList);
        }
        // Add empty BoardList with "Add Board" button at the end
        _lists.add(BoardList(
          backgroundColor: _themeStore.darkMode
              ? Colors.white70
              : Color.fromARGB(255, 235, 236, 240),
          footer: SizedBox(
              width: double.infinity,
              height: 36.0,
              child: new TextButton(
                child: Text("Add Board",
                    style: TextStyle(
                        color: _themeStore.darkMode
                            ? Colors.white70
                            : Colors.black)),
                onPressed: () {
                  // displayBottomSheet(context, "Item", listIndex);
                },
              )),
        ));

        return Material(
          child: BoardView(
            lists: _lists,
            boardViewController: boardViewController,
          ),
        );
      }
    });
  }

  //-------------------------Board List-------------------------
  Widget _createBoardList(BoardStore boardStore, int listIndex) {
    List<BoardItem> items = [];

    if (boardStore.loading) {
      items.add(BoardItem(
        item: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                        height: 20.0,
                        width: 20.0))),
          ],
        ),
      ));

      return BoardList(
        items: items,
        headerBackgroundColor: _themeStore.darkMode
            ? Colors.black12
            : Color.fromARGB(255, 235, 236, 240),
        backgroundColor: _themeStore.darkMode
            ? Colors.white70
            : Color.fromARGB(255, 235, 236, 240),
        header: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    boardStore.title!,
                    style: TextStyle(
                        fontSize: 18,
                        color: _themeStore.darkMode
                            ? Colors.black38
                            : Colors.black),
                  ))),
        ],
      );
    } else {
      for (int i = 0; i < boardStore.boardItemList.length; i++) {
        items.add(buildBoardItem(boardStore.boardItemList[i]) as BoardItem);
      }
      if (items.length > 0) {
        return BoardList(
          items: items,
          footer: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // displayBottomSheet(context, "Item", listIndex);
            },
          ),
          onStartDragList: (int? listIndex) {},
          onTapList: (int? listIndex) async {},
          onDropList: (int? listIndex, int? oldListIndex) {
            //Update our local list data
            // var list = _listData[oldListIndex!];
            // _listData.removeAt(oldListIndex);
            // _listData.insert(listIndex!, list);
          },
          headerBackgroundColor: _themeStore.darkMode
              ? Colors.white70
              : Color.fromARGB(255, 235, 236, 240),
          backgroundColor: _themeStore.darkMode
              ? Colors.white70
              : Color.fromARGB(255, 235, 236, 240),
          header: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      boardStore.title!,
                      style: TextStyle(
                          fontSize: 18,
                          color: _themeStore.darkMode
                              ? Colors.black38
                              : Colors.black),
                    ))),
          ],
        );
      } else {
        items.add(BoardItem(
            draggable: false,
            item: Card(
              color: Colors.transparent,
            )));
        return BoardList(
          items: items,
          headerBackgroundColor: _themeStore.darkMode
              ? Colors.white70
              : Color.fromARGB(255, 235, 236, 240),
          backgroundColor: _themeStore.darkMode
              ? Colors.white70
              : Color.fromARGB(255, 235, 236, 240),
          footer: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // displayBottomSheet(context, "Item", listIndex);
            },
          ),
          header: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      boardStore.title!,
                      style: TextStyle(
                          fontSize: 18,
                          color: _themeStore.darkMode
                              ? Colors.black38
                              : Colors.black),
                    ))),
          ],
        );
      }
    }
  }

  //------------------------Board Item-------------------------
  Widget buildBoardItem(BoardItemStore itemStore) {
    return BoardItem(
        onStartDragItem:
            (int? listIndex, int? itemIndex, BoardItemState state) {},
        onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
            int? oldItemIndex, BoardItemState state) {
          //Used to update our local item data
          // var item = _listData[oldListIndex!].items[oldItemIndex];
          // _listData[oldListIndex].items.removeAt(oldItemIndex);
          // _listData[listIndex!].items.insert(itemIndex, item);
        },
        onTapItem:
            (int? listIndex, int? itemIndex, BoardItemState state) async {},
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemStore.title!),
          ),
        ));
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_boardListStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_boardListStore.errorStore.errorMessage);
        }
        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('board_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }
}
