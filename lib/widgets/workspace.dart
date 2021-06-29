import 'package:flutter/material.dart';
import 'package:kanban/utils/routes/routes.dart';

class WorkSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Personal WorkSpace"),
      children: [
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.board);
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
      ],
    );
  }
}
