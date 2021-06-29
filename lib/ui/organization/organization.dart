import 'package:flutter/material.dart';
import 'package:kanban/widgets/personal_board.dart';
import 'package:kanban/widgets/workspace.dart';

class OrganizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KanBan"),centerTitle: true,),
      body: Column(
        children: [
          PersonalBoard(),
          WorkSpace()
        ],
      ),
    );
  }
}
