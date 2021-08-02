
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'entities.dart';
import 'objectbox.g.dart';

class UserDataTable extends StatefulWidget {
  final Store? store;
  final List<User> users;
  final TextEditingController tcUserName, tcPassword;

  UserDataTable({
    required this.store,
    required this.users,
    required this.tcUserName,
    required this.tcPassword
  });

  @override
  UserDataTableState createState() => UserDataTableState();
}

class UserDataTableState extends State<UserDataTable> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('UserName')),
            DataColumn(label: Container()),
            DataColumn(label: Container()),
          ],
          rows: widget.users.map((user){
            return DataRow(
                cells: [
                  DataCell(
                      Text(user.id.toString())
                  ),
                  DataCell(
                      Text(user.userName)
                  ),
                  DataCell(
                      Icon(Icons.edit_rounded),
                      onTap: (){
                        user.userName = widget.tcUserName.text;
                        user.password = widget.tcPassword.text;
                        widget.store?.box<User>().put(user);
                      }
                  ),
                  DataCell(
                      Icon(Icons.delete),
                      onTap: (){
                        widget.store?.box<User>().remove(user.id);
                      }
                  ),
                ]
            );
          }).toList()
        ),
      )
    );
  }
}