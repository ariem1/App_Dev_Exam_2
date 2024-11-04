import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('Users').snapshots();
  String name = '';

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> addUser() {
    return users
        .add({'name': "Vanier"})
        .then((value) => print('User added'))
        .catchError((error) => print("Failed to add the user to firebase"));
  }

  Future<void> updateUser(String id, String newName) async {
    await users
        .doc(id)
        .update({'name': newName})
        .then((value) => print('User updated'))
        .catchError((error) => print("Failed to update the user in firebase"));
  }

  Future<void> deleteUser(String id) async {
    await users
        .doc(id)
        .delete()
        .then((value) => print('User deleted'))
        .catchError((error) => print("Failed to delete the user in firebase"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Demo'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter username',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: addUser, child: Text('Add Username')),
              SizedBox(height: 15),
              StreamBuilder<QuerySnapshot>(
                  stream: _userStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading to connect to server');
                    }
                    return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String docId = document.id;
                        return ListTile(
                          title: Text(data['name']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String newName = '';
                                      return AlertDialog(
                                        title: Text('Edit User'),
                                        content: TextField(
                                          onChanged: (value) {
                                            newName = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              updateUser(docId, newName);
                                            },
                                            child: Text('Update'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteUser(docId),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
