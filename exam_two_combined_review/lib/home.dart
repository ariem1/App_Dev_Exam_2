import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "Welcome to the Home Page, this is in another class file",
            style: TextStyle(fontSize: 20.0),
          ),
          FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('FAB clicked!')),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
