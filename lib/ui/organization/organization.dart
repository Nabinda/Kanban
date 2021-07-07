import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kanban/data/sharedpref/constants/preferences.dart';
import 'package:kanban/models/project/project.dart';
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

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _showAction(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTitleField(),
                  _buildDescriptionField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      index == 1
                          ?
                          // DropdownButton<String>(
                          //   iconEnabledColor: style.CustomTheme.themeColor,
                          //   dropdownColor: style.CustomTheme.themeColor,
                          //   items: bloodGroupCategories.map((dropdownItem){
                          //     return DropdownMenuItem<String>(
                          //       value: dropdownItem,
                          //       child: Text(dropdownItem),
                          //     );
                          //   }).toList(),
                          //   value: selectedBloodGroup,
                          //   onChanged: (value){
                          //     stateSetter((){
                          //       selectedBloodGroup = value;
                          //     });
                          //   },
                          // )
                          Container(
                              //TODO: Dropdown
                              )
                          : Container(),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_organizationStoreValidation.canAdd) {
                        DeviceUtils.hideKeyboard(context);
                        _organizationListStore.insertOrganizations(
                            _titleController.text, _descriptionController.text);
                      } else {
                        _showErrorMessage('Please fill in all fields');
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 10),
                      height: 50,
                      // decoration: style.CustomTheme.buttonDecoration,
                      child: Text(
                        'Submit',
                        // style: style.CustomTheme.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

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

    // check to see if already called api
    if (!_organizationListStore.loading) {
      _organizationListStore.getOrganizations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            text: "Organization",
            icon: Icon(Icons.home),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            text: "Projects",
            icon: Icon(Icons.file_copy_sharp),
          ),
        ],
      ),
      appBar: _buildAppBar(),

      drawer:Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
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
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildTitleField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('login_et_user_email'),
          inputType: TextInputType.emailAddress,
          icon: Icons.person,
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
          errorText: _organizationStoreValidation.organizationErrorStore.title,
        );
      },
    );
  }

  Widget _buildDescriptionField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('login_et_user_email'),
          inputType: TextInputType.emailAddress,
          icon: Icons.person,
          iconColor:
              _themeStore.darkMode ? Colors.white70 : Colors.blue.shade200,
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
          errorText:
              _organizationStoreValidation.organizationErrorStore.description,
        );
      },
    );
  }

// app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)
          .translate('organization_tv_organizations')),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),

      _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return ListTile(
          title: Text("Change Theme"),
          trailing: IconButton(
            onPressed: () {
              _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
            },
            icon: Icon(
              _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
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
      return _organizationListStore.loading
          ? CustomProgressIndicatorWidget()
          : Material(child: _buildProjectsExpansion());
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
                return _buildProjectItem(
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

  Widget _buildProjectItem(OrganizationStore organizationStore) {
    return Card(
      child: ExpansionTile(
          title: Text(
            organizationStore.title!,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
            title: Text(p.title!),
            onTap: () {
              Navigator.pushNamed(context, Routes.board);
            }));
      }
      return Column(children: reasonList);
    }
    return ListTile(title: Text("No Projects!"));
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
