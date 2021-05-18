import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class PersonalBoard extends StatefulWidget {
  @override
  _PersonalBoardState createState() => _PersonalBoardState();
}

class _PersonalBoardState extends State<PersonalBoard> {
  ExpandableController _controller = new ExpandableController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Personal Board"),
      children: [
        ListTile(
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
