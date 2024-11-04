import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationBarDemo(),
    );
  }
}
class NavigationBarDemo extends StatefulWidget {
  const NavigationBarDemo({super.key});

  @override
  State<NavigationBarDemo> createState() => _NavigationBarDemoState();
}

class _NavigationBarDemoState extends State<NavigationBarDemo> {
  int _selectIndex=0;
  static const List<Widget> _widgetOptions=[
    Text('Home page',style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
    Text('Search page',style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
    Text('Profile page',style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),

  ];

  void _onItemTapped(int index){
    setState(() {
      _selectIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Navigation example"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home),
        label:"Home",
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search),
          label:"Search",
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person),
          label:"Profile",
          backgroundColor: Colors.blue,
        )
      ],
      type: BottomNavigationBarType.shifting,
        currentIndex: _selectIndex,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
