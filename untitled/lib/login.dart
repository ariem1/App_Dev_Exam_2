import 'package:flutter/material.dart';
import 'user.dart';
import 'db_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final id = idController.text;
    final password = passwordController.text;

    if (int.tryParse(id) != null && password.isNotEmpty) {
      final dbService = DatabaseHelper();

      User? user = await dbService.loginUser(int.parse(id), password);

      if (user != null) {
        // Successful login
        _showSnackBar(context, "Login successful");
        Navigator.pushNamed(
          context,
          '/home',
          arguments: user,
        );
        _clear();
      } else {
        _showSnackBar(context, "Invalid ID or password");
      }
    } else {
      _showSnackBar(context, "Please enter user ID and password");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black54,
    ));
  }

  void _goToRegisterScreen() {
    Navigator.pushNamed(context, '/register');
  }

  void _clear() {
    idController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 238, 219, 204),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 153, 107, 71),
          title: const Text(
            'Pizza Heaven',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(50),

              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(labelText: 'User ID'),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => login(),
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 100),
                  Text("Don't have an account? "),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () => _goToRegisterScreen(),
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
