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
import 'package:kanban/stores/language/language_store.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:kanban/widgets/progress_indicator_widget.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  //stores:---------------------------------------------------------------------
  late BoardListStore _boardListStore;
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;
  BoardViewController boardViewController = new BoardViewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _boardListStore = Provider.of<BoardListStore>(context);

    // check to see if already called api
    if (!_boardListStore.loading) {
      _boardListStore.getBoards(1);
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
        AppLocalizations.of(context).translate('board_tv_boards'),
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
        _lists.add(BoardList(
          // headerBackgroundColor: _themeStore.darkMode
          //     ? Colors.red
          //     : Color.fromARGB(255, 235, 236, 240),
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
            child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: BoardView(
            lists: _lists,
            boardViewController: boardViewController,
          ),
        ));
      }
    });
  }

  //-------------------------Board List-------------------------
  Widget _createBoardList(BoardStore boardStore, int listIndex) {
    if (boardStore.loading) {
      List<BoardItem> items = [];
      items.add(BoardItem(
          item: Card(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("loading.."),
      ))));
      return BoardList(
        items: items,
        headerBackgroundColor: _themeStore.darkMode
            ? Colors.red
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
      List<BoardItem> items = [];
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
        List<BoardItem> items = [];
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

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language!,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale!);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
