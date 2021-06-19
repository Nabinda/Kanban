import 'package:flutter/material.dart';
import 'package:kanban/provider/task_provider.dart';
import 'package:kanban/screens/task_screen.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    return MaterialApp(
      title: 'KanBan',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        TaskScreen.routeName:(ctx)=>TaskScreen(),
      },
>>>>>>> f49079e46efbc10573f981cafb07babafa9f040b
    );
  }
}