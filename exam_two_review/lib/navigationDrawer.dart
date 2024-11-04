import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationDrawer(),
    );
  }
}
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" A drawer is an invisble save screen"),
      ),
      body: Center(
        child: Text("Demo of navigation drawer",
        style: TextStyle(fontSize: 20.0),
        ),

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("Student 1"),
                accountEmail: Text("abc@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text("Deez nuts", style: TextStyle(fontSize: 15),
              ),
            ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title:Text("Home Page"),
              onTap: (){
                Navigator.pop(context);
              },

            ),
            ListTile(
              leading: Icon(Icons.settings),
              title:Text("Settings"),
              onTap: (){
                Navigator.pop(context);
              },

            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title:Text("Contact us"),
              onTap: (){
                Navigator.pop(context);
              },

            ),
          ],
        ),
      ),
    );
  }
}
