import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kanban/models/project/project.dart';
import 'package:kanban/stores/board/boardItem_store.dart';
import 'package:kanban/stores/board/board_list_store.dart';
import 'package:kanban/stores/board/board_store.dart';
import 'package:kanban/stores/organization/organization_list_store.dart';
import 'package:kanban/stores/organization/organization_store.dart';
import 'package:kanban/stores/organization/organization_store_validation.dart';
import 'package:kanban/stores/organization/project_store_validation.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/utils/device/device_utils.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:kanban/utils/routes/routes.dart';
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
  late OrganizationListStore _organizationListStore;
  late ThemeStore _themeStore;
  BoardViewController boardViewController = new BoardViewController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late OrganizationStoreValidation _organizationStoreValidation =
      new OrganizationStoreValidation();

  late ProjectStoreValidation _projectStoreValidation =
      new ProjectStoreValidation();
  TextEditingController _titleProjectController = TextEditingController();
  TextEditingController _descriptionProjectController = TextEditingController();

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
    _organizationListStore = Provider.of<OrganizationListStore>(context);

    // check to see if already called api
    if (!_boardListStore.loading) {
      _boardListStore.getBoards(_boardListStore.project!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

// app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case "Edit":
                Project project = _boardListStore.project!;

                int organizationIndex = _organizationListStore
                    .getOrganizationIndex(project.organizationId!);

                if (organizationIndex != -1) {
                  OrganizationStore orgStore = _organizationListStore
                      .organizationList[organizationIndex];

                  int projectIndex = orgStore.getProjectIndex(project.id!);

                  _projectStoreValidation
                      .setTitle(orgStore.projectList[projectIndex].title!);
                  _projectStoreValidation.setDescription(
                      orgStore.projectList[projectIndex].description!);

                  _showProjectEditBottomSheet(context);
                }
                break;
              case "Delete":
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text(
                        'Are you sure you wish to delete this item?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                      ),
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () async {
                          Project project = _boardListStore.project!;

                          int organizationIndex = _organizationListStore
                              .getOrganizationIndex(project.organizationId!);

                          if (organizationIndex != -1) {
                            OrganizationStore orgStore = _organizationListStore
                                .organizationList[organizationIndex];

                            await orgStore.deleteProject(project);
                            _boardListStore.project = null;


                            Navigator.pop(context, 'OK');
                            Navigator.pushNamedAndRemoveUntil(context,
                                Routes.organizationList, (route) => false);
                          }
                        },
                      ),
                    ],
                  ),
                );
                break;
            }
          },
          itemBuilder: (_) => <PopupMenuItem<String>>[
            PopupMenuItem<String>(
              value: "Edit",
              child: Row(
                children: [
                  Icon(Icons.edit,
                      color: _themeStore.darkMode
                          ? Colors.white
                          : Colors.blue.shade200),
                  SizedBox(width: 15.0),
                  Text("Edit"),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: "Delete",
              child: Row(
                children: [
                  Icon(Icons.delete,
                      color: _themeStore.darkMode
                          ? Colors.white
                          : Colors.blue.shade200),
                  SizedBox(width: 15.0),
                  Text("Delete"),
                ],
              ),
            ),
          ],
        ),
      ],
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Observer(builder: (context) {
        Project project = _boardListStore.project!;
        int organizationIndex = _organizationListStore
            .getOrganizationIndex(project.organizationId!);
        if (organizationIndex == -1) {
          return Text(
            "Deleted Project",
            style: TextStyle(color: Colors.white),
          );
        } else {
          OrganizationStore orgStore =
              _organizationListStore.organizationList[organizationIndex];

          return Text(
            orgStore.projectList[orgStore.getProjectIndex(project.id!)].title!,
            style: TextStyle(color: Colors.white),
          );
        }
      }),
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
          draggable: false,
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
                  _showBoardBottomSheet(context);
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
            onPressed: () => _showBoardItemBottomSheet(context, listIndex),
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

  //-------------------------Bottom Sheet-------------------------
  void _showProjectEditBottomSheet(BuildContext context) {
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
                      child: _buildEditProjectForm(),
                    ),
                  ]),
            );
          });
        });
  }

  Widget _buildEditProjectForm() {
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
                  Text("Edit Project"),
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
              hint: AppLocalizations.of(context).translate('project_tv_title'),
              inputType: TextInputType.emailAddress,
              icon: Icons.create,
              iconColor:
                  _themeStore.darkMode ? Colors.white70 : Colors.blue.shade200,
              initValue: _projectStoreValidation.title,
              inputAction: TextInputAction.next,
              autoFocus: false,
              onChanged: (value) {
                _projectStoreValidation.setTitle(value);
              },
              onFieldSubmitted: (value) {
                //  FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              errorText: _projectStoreValidation.projectErrorStore.title,
            );
          }),
          SizedBox(
            height: 20.0,
          ),
          Observer(
            builder: (context) {
              return TextFieldWidget(
                hint: AppLocalizations.of(context)
                    .translate('project_tv_description'),
                inputType: TextInputType.emailAddress,
                icon: Icons.wysiwyg_outlined,
                iconColor: _themeStore.darkMode
                    ? Colors.white70
                    : Colors.blue.shade200,
                initValue: _projectStoreValidation.description,
                inputAction: TextInputAction.next,
                autoFocus: false,
                onChanged: (value) {
                  _projectStoreValidation.setDescription(value);
                },
                onFieldSubmitted: (value) {
                  //  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                errorText:
                    _projectStoreValidation.projectErrorStore.description,
              );
            },
          ),
          SizedBox(
            height: 40.0,
          ),
          ElevatedButton(
              child:
                  Text('Update Project', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                  primary: Colors.blue,
                  onSurface: Colors.red,
                  minimumSize: Size(128, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
              onPressed: () {
                if (_projectStoreValidation.canAdd) {
                  Project pr = Project(
                      organizationId: _boardListStore.project?.organizationId,
                      id: _boardListStore.project?.id,
                      title: _projectStoreValidation.title,
                      description: _projectStoreValidation.description);

                  _organizationListStore.organizationList[
                          _organizationListStore.getOrganizationIndex(
                              _boardListStore.project?.organizationId)]
                      .updateProject(pr);

                  DeviceUtils.hideKeyboard(context);
                  Navigator.of(context).pop();
                  _titleProjectController.clear();
                  _descriptionProjectController.clear();
                  // TODO: update value in database
                } else {
                  _showErrorMessage('Please fill in all fields');
                }
              }),
        ],
      ),
    );
  }

  void _showBoardBottomSheet(BuildContext context) {
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
                      child: _buildCreateBoardForm(),
                    ),
                  ]),
            );
          });
        });
  }

  Widget _buildCreateBoardForm() {
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
                  Text("Add New Board"),
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
              hint: AppLocalizations.of(context).translate('board_tv_title'),
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
                    .translate('board_tv_description'),
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
                  child: Text('Create New Board',
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

  void _showBoardItemBottomSheet(BuildContext context, int listIndex) {
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
                      child: _buildCreateBoardItemForm(),
                    ),
                  ]),
            );
          });
        });
  }

  Widget _buildCreateBoardItemForm() {
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
                  Text("Add New Board Item"),
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
              hint:
                  AppLocalizations.of(context).translate('boardItem_tv_title'),
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
                    .translate('boardItem_tv_description'),
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
                  child: Text('Create New Board Item',
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

  // General Methods:-----------------------------------------------------------
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
