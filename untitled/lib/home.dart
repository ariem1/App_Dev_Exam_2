import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'user.dart';
import 'customization.dart';
import 'pizza.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pizza> _pizzaData = [];

  @override
  void initState() {
    super.initState();
    loadPizzaData();
  }

  Future<void> loadPizzaData() async {
    try {
      final String response = await rootBundle.loadString('assets/pizza.json');
      final List<dynamic> data = jsonDecode(response);

      setState(() {
        _pizzaData = data.map((json) => Pizza.fromJson(json)).toList();
      });
    } catch (e) {
      print("Error loading pizza data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 219, 204),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 107, 71),
        title: const Text('Pizza Heaven', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white,),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
              print("Sign out");
            },
          ),
        ],
      ),
      body: _pizzaData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome, ${widget.user.id}!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Our Pizza Selection',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: _pizzaData.map((pizza) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/customize',
                      arguments: {
                        'user': widget.user,
                        'pizza': pizza,
                      },
                    );
                  },
                  child: Card(
                    elevation: 3.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/${pizza.imageName}.jpg',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          pizza.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            pizza.ingredients,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
