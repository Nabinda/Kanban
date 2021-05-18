import 'package:flutter/material.dart';
import 'package:kanban/screens/task_screen.dart';

class WorkSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(title: Text("Personal WorkSpace"),
    children: [
      ListTile(
        onTap: (){
          Navigator.of(context).pushNamed(TaskScreen.routeName);
        },
        title: Text("Data 1"),
      ),
      ListTile(
        title: Text("Data 2"),
      ),
      ListTile(
        title: Text("Data 3"),
      ),
      ListTile(
        title: Text("Data 4"),
      ),
    ],);
  }
}
