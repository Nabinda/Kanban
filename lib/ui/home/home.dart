import 'package:another_flushbar/flushbar_helper.dart';
import 'package:kanban/data/sharedpref/constants/preferences.dart';
import 'package:kanban/models/post/post.dart';
import 'package:kanban/stores/post/post_store_validation.dart';
import 'package:kanban/utils/device/device_utils.dart';
import 'package:kanban/utils/routes/routes.dart';
import 'package:kanban/stores/language/language_store.dart';
import 'package:kanban/stores/post/post_store.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:kanban/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kanban/widgets/textfield_widget.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late PostStore _postStore;
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;
  late PostStoreValidation _postStoreValidation = new PostStoreValidation();

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
    _postStore = Provider.of<PostStore>(context);

    // check to see if already called api
    if (!_postStore.loading) {
      _postStore.getPosts();
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
      title: Text(AppLocalizations.of(context).translate('home_tv_posts')),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
      _buildThemeButton(),
      _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: Icon(
            _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
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
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _postStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    return _postStore.postList.length > 0
        ? ListView.separated(
            itemCount: _postStore.postList.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItem(_postStore.postList[position]);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(Post post) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
              actions: <Widget>[
                GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (DismissDirection direction) {
        //TODO: Delete from API and Local Database
        _postStore.deletePost(post);
      },
      child: ListTile(
        dense: true,
        leading: Icon(Icons.cloud_circle),
        title: Text(
          '${post.title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          '${post.body}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _postStoreValidation.setTitle(post.title!);
            _postStoreValidation.setDescription(post.body!);
            _postStoreValidation.setId(post.id!);
            _postStoreValidation.setUserId(post.userId!);
            _showBottomSheet(context);
          },
        ),
      ),
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_postStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_postStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
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
                      child: _buildCreateOrganizationForm(),
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
                  Text("Edit Blog"),
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
              initValue: _postStoreValidation.title,
              onChanged: (value) {
                _postStoreValidation.setTitle(value);
              },
              onFieldSubmitted: (value) {
                //  FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              errorText: _postStoreValidation.organizationErrorStore.title,
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
                inputAction: TextInputAction.next,
                initValue: _postStoreValidation.description,
                onChanged: (value) {
                  _postStoreValidation.setDescription(value);
                },
                onFieldSubmitted: (value) {
                  //  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                errorText:
                    _postStoreValidation.organizationErrorStore.description,
              );
            },
          ),
          SizedBox(
            height: 40.0,
          ),
          Observer(
            builder: (context) {
              return ElevatedButton(
                  child: Text('Update Blog',
                      style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                      primary: Colors.blue,
                      onSurface: Colors.red,
                      minimumSize: Size(128, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  onPressed: () {
                    if (_postStoreValidation.canAdd) {
                      _postStore.updatePost(Post(
                          id: _postStoreValidation.id,
                          title: _postStoreValidation.title,
                          userId: _postStoreValidation.userId,
                          body: _postStoreValidation.description));
                      DeviceUtils.hideKeyboard(context);
                      Navigator.of(context).pop();
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
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
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
