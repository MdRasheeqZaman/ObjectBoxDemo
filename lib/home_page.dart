import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_box_demo/user_data_table.dart';
import 'package:objectbox/objectbox.dart';
import 'entities.dart';
import 'objectbox.g.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Store? store;
  final tcUserName = TextEditingController();
  final tcPassword = TextEditingController();
  Stream<List<User>>? userStream;

  @override
  void initState() {
    super.initState();

    openStore().then((Store store){
      this.store = store;
      print('C4: Store Initialized');
      userStream = store.box<User>().query().watch(triggerImmediately: true).map((q) => q.find());
    });

  }

  @override
  void dispose() {
    tcUserName.dispose();
    tcPassword.dispose();
    store?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ObjectBox Demo'),
        actions: [
          IconButton(
              onPressed: (){addNewUser();},
              icon: Icon(Icons.add)
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: tcUserName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter User Name'
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: tcPassword,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Password'
              ),
            ),
          ),
          (userStream == null) ?
          Text('Data not loaded yet!') :
          StreamBuilder<List<User>>(
              stream: userStream,
              builder: (context, snapshot) {
                print('C8: Enter StreamBuilder');
                if (!snapshot.hasData) {
                  print('C7: in progress');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return UserDataTable(
                    store: store,
                    users: snapshot.data!,
                    tcUserName: tcUserName,
                    tcPassword: tcPassword);
              },
          ),
        ],
      )
    );
  }

  void addNewUser() {
    User user = User(userName: tcUserName.text, password: tcPassword.text);
    store?.box<User>().put(user);

    Query<User>? query = store?.box<User>().query().build();
    print('C1: Add User = ${tcUserName.text} ${query?.count()}');
  }
}