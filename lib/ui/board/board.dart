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
import 'package:kanban/stores/organization/organization_store_validation.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/utils/device/device_utils.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:kanban/widgets/progress_indicator_widget.dart';
import 'package:kanban/widgets/textfield_widget.dart';
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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late OrganizationStoreValidation _organizationStoreValidation =
      new OrganizationStoreValidation();

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
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case 'Logout':
                break;
              case 'Settings':
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Edit', 'Delete'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Row(
                  children: [
                    Icon(choice == 'Edit' ? Icons.edit : Icons.delete,
                        color: _themeStore.darkMode
                            ? Colors.white
                            : Colors.blue.shade200),
                    SizedBox(width: 15.0),
                    choice == 'Edit' ? Text("Edit") : Text('Delete'),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
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

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                      child: index == 0
                          ? _buildCreateOrganizationForm()
                          : Column(),
                    ),
                  ]),
            );
          });
        });
  }

  Widget _buildCreateOrganizationForm() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.supervised_user_circle_outlined,
                      color: _themeStore.darkMode
                          ? Colors.white
                          : Colors.blue.shade200),
                  SizedBox(width: 15.0),
                  Text("Add New Organization"),
                ],
              ),
              SizedBox(width: 10.0),
              OutlinedButton(
                child: Icon(Icons.close,
                    color:
                        _themeStore.darkMode ? Colors.white : Colors.black45),
                style: TextButton.styleFrom(
                    primary: Colors.black45,
                    onSurface: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(255.0),
                    )),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Observer(builder: (context) {
            return TextFieldWidget(
              hint: AppLocalizations.of(context)
                  .translate('organization_tv_title'),
              inputType: TextInputType.emailAddress,
              icon: Icons.create,
              iconColor:
                  _themeStore.darkMode ? Colors.white70 : Colors.blue.shade200,
              textController: _titleController,
              inputAction: TextInputAction.next,
              autoFocus: false,
              onChanged: (value) {
                _organizationStoreValidation.setTitle(_titleController.text);
              },
              onFieldSubmitted: (value) {
                //  FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              errorText:
                  _organizationStoreValidation.organizationErrorStore.title,
            );
          }),
          SizedBox(
            height: 20.0,
          ),
          Observer(
            builder: (context) {
              return TextFieldWidget(
                hint: AppLocalizations.of(context)
                    .translate('organization_tv_description'),
                inputType: TextInputType.emailAddress,
                icon: Icons.wysiwyg_outlined,
                iconColor: _themeStore.darkMode
                    ? Colors.white70
                    : Colors.blue.shade200,
                textController: _descriptionController,
                inputAction: TextInputAction.next,
                autoFocus: false,
                onChanged: (value) {
                  _organizationStoreValidation
                      .setDescription(_descriptionController.text);
                },
                onFieldSubmitted: (value) {
                  //  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                errorText: _organizationStoreValidation
                    .organizationErrorStore.description,
              );
            },
          ),
          SizedBox(
            height: 40.0,
          ),
          Observer(
            builder: (context) {
              return ElevatedButton(
                  child: Text('Save New Organization',
                      style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                      primary: Colors.blue,
                      onSurface: Colors.red,
                      minimumSize: Size(128, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  onPressed: () {
                    if (_organizationStoreValidation.canAdd) {
                      DeviceUtils.hideKeyboard(context);
                      Navigator.of(context).pop();
                      _titleController.clear();
                      _descriptionController.clear();
                    } else {
                      _showErrorMessage('Please fill in all fields');
                    }
                  });
            },
          )
        ],
      ),
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
            onPressed: () => _showBottomSheet(context, 0),
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
