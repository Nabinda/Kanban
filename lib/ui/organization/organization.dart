import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kanban/data/sharedpref/constants/preferences.dart';
import 'package:kanban/models/project/project.dart';
import 'package:kanban/stores/board/board_list_store.dart';
import 'package:kanban/stores/language/language_store.dart';
import 'package:kanban/stores/organization/organization_list_store.dart';
import 'package:kanban/stores/organization/organization_store.dart';
import 'package:kanban/stores/organization/organization_store_validation.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/utils/device/device_utils.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:kanban/utils/routes/routes.dart';
import 'package:kanban/widgets/action_button.dart';
import 'package:kanban/widgets/expandable_fab.dart';
import 'package:kanban/widgets/progress_indicator_widget.dart';
import 'package:kanban/widgets/textfield_widget.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizationScreen extends StatefulWidget {
  @override
  _OrganizationScreenState createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  //stores:---------------------------------------------------------------------
  late OrganizationListStore _organizationListStore;
  late OrganizationStoreValidation _organizationStoreValidation =
      new OrganizationStoreValidation();
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;

  late BoardListStore _boardListStore;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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
    _organizationListStore = Provider.of<OrganizationListStore>(context);
    _boardListStore = Provider.of<BoardListStore>(context);

    // check to see if already called api
    if (!_organizationListStore.loading) {
      _organizationListStore.getOrganizations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 70.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            textWidget:
                Text("Organization", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.home, color: Colors.white),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            textWidget: Text("Projects", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.file_copy_sharp, color: Colors.white),
          ),
        ],
      ),
      appBar: _buildAppBar(),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.black12)),
                ),
                child: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/100'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Positioned(
                      bottom: 12.0,
                      left: 16.0,
                      child: Text("John Doe",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500))),
                ])),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            _buildThemeButton(),
            _buildLanguageButton(),
            _buildLogoutButton(),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  void _showAction(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      index == 0
                          ? Text("Add New Organization")
                          : Text("Add New Project"),
                      SizedBox(width: 10.0),
                      OutlinedButton(
                        child: Icon(Icons.close),
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
                ),
                index == 0
                    ? _buildCreateOrganizationForm()
                    : _buildCreateProjectForm(),
              ]),
            );
          });
        });
  }

  Widget _buildCreateOrganizationForm() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Observer(builder: (context) {
              return TextFieldWidget(
                hint: AppLocalizations.of(context)
                    .translate('organization_tv_title'),
                inputType: TextInputType.emailAddress,
                icon: Icons.create,
                iconColor: _themeStore.darkMode
                    ? Colors.white70
                    : Colors.blue.shade200,
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
          ],
        ),
      ),
      SizedBox(
        height: 40.0,
      ),
      ElevatedButton(
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
              _organizationListStore.insertOrganizations(
                  _titleController.text, _descriptionController.text);
            } else {
              _showErrorMessage('Please fill in all fields');
            }
          }),
    ]);
  }

  Widget _buildCreateProjectForm() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.home,
                  color: _themeStore.darkMode
                      ? Colors.white70
                      : Colors.blue.shade200,
                ),
                SizedBox(
                  width: 17.0,
                ),
                DropdownButton<String>(
                  iconEnabledColor: Colors.black,
                  dropdownColor: Colors.white,
                  style: TextStyle(),
                  items: _organizationListStore.organizationList
                      .map((dropdownItem) {
                    return DropdownMenuItem<String>(
                      value: dropdownItem.id.toString(),
                      child: Text(dropdownItem.title!,
                          style: TextStyle(color: Colors.blue)),
                    );
                  }).toList(),
                  hint: Text("Please Select Organization"),
                  onChanged: (newVal) {
                    print(newVal);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 40.0,
      ),
      ElevatedButton(
          child:
              Text('Save New Project', style: TextStyle(color: Colors.white)),
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
              _organizationListStore.insertOrganizations(
                  _titleController.text, _descriptionController.text);
            } else {
              _showErrorMessage('Please fill in all fields');
            }
          }),
    ]);
  }

// app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        AppLocalizations.of(context).translate('organization_tv_organizations'),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return ListTile(
          onTap: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          title: Text("Toggle Theme"),
          trailing: Icon(
            _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      onTap: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      title: Text("Log Out"),
      trailing: Icon(Icons.logout),
    );
  }

  Widget _buildLanguageButton() {
    return ListTile(
      onTap: () {
        _buildLanguageDialog();
      },
      title: Text("Choose Language"),
      trailing: Icon(Icons.language),
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
      return _organizationListStore.loading
          ? CustomProgressIndicatorWidget()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(child: _buildProjectsExpansion()),
            );
    });
  }

  Widget _buildProjectsExpansion() {
    return _organizationListStore.organizationList.length != 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: _organizationListStore.organizationList.length,
            itemBuilder: (BuildContext context, int index) {
              return Observer(builder: (_) {
                return _buildOrganizationItem(
                    _organizationListStore.organizationList[index]);
              });
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context)
                  .translate('organization_tv_no_organization_found'),
            ),
          );
  }

  Widget _buildOrganizationItem(OrganizationStore organizationStore) {
    return Card(
      child: ExpansionTile(
          iconColor: _themeStore.darkMode ? Colors.white : Colors.black,
          initiallyExpanded: true,
          maintainState: true,
          title: Text(
            organizationStore.title!,
            style: TextStyle(
                color: _themeStore.darkMode ? Colors.white : Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            organizationStore.loading
                ? ListTile(title: Text("loading.."))
                : Observer(builder: (_) {
                    return _buildProjectItemList(organizationStore.projectList);
                  })
          ]),
    );
  }

  Widget _buildProjectItemList(ObservableList<Project>? projectList) {
    if (projectList != null && projectList.length != 0) {
      List<Widget> reasonList = [];
      for (Project p in projectList) {
        reasonList.add(ListTile(
            title: Text(p.title!,
                style: TextStyle(
                    fontSize: 14.0,
                    color: _themeStore.darkMode
                        ? Colors.white70
                        : Colors.black54)),
            onTap: () {
              _boardListStore.setProject(p);
              Navigator.pushNamed(context, Routes.board);
            }));
      }
      return Column(children: reasonList);
    }
    return Column(children: [
      ListTile(title: Text("No Projects!")),
    ]);
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_organizationListStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(
              _organizationListStore.errorStore.errorMessage);
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
          title:
              AppLocalizations.of(context).translate('organization_tv_error'),
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
