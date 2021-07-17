import 'package:another_flushbar/flushbar_helper.dart';
import 'package:kanban/data/sharedpref/constants/preferences.dart';
import 'package:kanban/stores/form/signUp_form_store.dart';
import 'package:kanban/utils/routes/routes.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/utils/device/device_utils.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:kanban/widgets/progress_indicator_widget.dart';
import 'package:kanban/widgets/rounded_button_widget.dart';
import 'package:kanban/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
//focus node:-----------------------------------------------------------------
  late FocusNode _confirmPasswordFocusNode;
  //stores:---------------------------------------------------------------------
  final _signupStore = SignUpFormStore();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          AppLocalizations.of(context).translate('signup_btn_sign_in'),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          _buildRightSide(),
          Observer(
            builder: (context) {
              return _signupStore.success
                  ? navigate(context)
                  : _showErrorMessage(_signupStore.errorStore.errorMessage);
            },
          ),
          Observer(
            builder: (context) {
              return Visibility(
                visible: _signupStore.loading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 14.0),
            Container(
              margin: const EdgeInsets.only(top: 120),
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 8.0, bottom: 25.0),
              decoration: BoxDecoration(
                color: _themeStore.darkMode ? Colors.grey : Colors.white,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1.0),
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, -1.0),
                      blurRadius: 1.0),
                ],
              ),
              child: Column(
                children: [
                  _buildUserIdField(),
                  _buildPasswordField(),
                  _buildConfirmPasswordField(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          textColor: Theme.of(context).primaryTextTheme.bodyText2!.color,
          hint: AppLocalizations.of(context).translate('login_et_user_email'),
          inputType: TextInputType.emailAddress,
          icon: Icons.person,
          iconColor: _themeStore.darkMode ? Colors.black : Colors.blue,
          hintColor: _themeStore.darkMode ? Colors.black : Colors.blue,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          onChanged: (value) {
            _signupStore.setUserId(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: _signupStore.formErrorStore.userEmail,
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          textColor: Theme.of(context).primaryTextTheme.bodyText2!.color,
          hint:
              AppLocalizations.of(context).translate('signup_et_user_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.black : Colors.blue,
          hintColor: _themeStore.darkMode ? Colors.black : Colors.blue,
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: _signupStore.formErrorStore.password,
          onChanged: (value) {
            _signupStore.setPassword(_passwordController.text);
          },
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          textColor: Theme.of(context).primaryTextTheme.bodyText2!.color,
          hint: AppLocalizations.of(context)
              .translate('signup_et_user_confirm_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.black : Colors.blue,
          hintColor: _themeStore.darkMode ? Colors.black : Colors.blue,
          textController: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          errorText: _signupStore.formErrorStore.confirmPassword,
          onChanged: (value) {
            _signupStore.setConfirmPassword(_confirmPasswordController.text);
          },
        );
      },
    );
  }

  Widget _buildSignInButton() {
    return RoundedButtonWidget(
      buttonText: AppLocalizations.of(context).translate('signup_btn_sign_in'),
      buttonColor: Colors.blue,
      textColor: Colors.white,
      onPressed: () async {
        if (_signupStore.canRegister) {
          DeviceUtils.hideKeyboard(context);
          _signupStore.register();
          Navigator.pushNamed(context, Routes.login);
        } else {
          _showErrorMessage('Please fill in all fields');
        }
      },
    );
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.organizationList, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
