import 'package:kanban/ui/board/board.dart';
import 'package:kanban/ui/home/home.dart';
import 'package:kanban/ui/login/login.dart';
import 'package:kanban/ui/organization/organization.dart';
import 'package:kanban/ui/project/project.dart';
import 'package:kanban/ui/signup/signup.dart';
import 'package:kanban/ui/splash/splash.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String organizationList = '/organizationList';
  static const String projectList = '/projectList';
  static const String board = '/board';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    signup: (BuildContext context) => SignupScreen(),
    home: (BuildContext context) => HomeScreen(),
    organizationList: (BuildContext context) => OrganizationScreen(),
    projectList: (BuildContext context) => ProjectScreen(),
    board: (BuildContext context) => BoardScreen(),
  };
}