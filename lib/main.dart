import 'package:flutter/material.dart';
import 'package:kanban/provider/task_provider.dart';
import 'package:kanban/screens/task_screen.dart';
import 'package:provider/provider.dart';

import 'screens/homepage_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (_)=>TaskProvider())
      ],
      child: MaterialApp(
        title: 'KanBan',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          TaskScreen.routeName:(ctx)=>TaskScreen(),
        },
      ),
    );
  }
}
