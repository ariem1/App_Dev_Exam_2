import 'package:flutter/material.dart';
import 'user.dart';
import 'db_helper.dart';
import 'package:sqflite/sqflite.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> register() async {
    final id = idController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (int.tryParse(id) != null &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        final dbHelper = DatabaseHelper();
        final idNumber = int.parse(id);

        final user = User(id: idNumber, password: password);
        await dbHelper.registerUser(user);

        // Fetch and print all users to verify insertion
        List<User> users = await dbHelper.fetchUsers();
        for (User u in users) {
          print("Fetched user: $u");
        }

        _showSnackBar(context, "Registered successfully");
        _clearController();
        _goToLoginScreen();

      } else {
        _showSnackBar(context, "Passwords do not match");
      }
    } else {
      _showSnackBar(context, "Please enter valid ID and passwords");
    }
  }

  void _clearController() {
    idController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black54,
    ));
  }

  void _goToLoginScreen() {
    Navigator.pushNamed(context, '/login');
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
              children: [
                SizedBox(height: 50),
                Text(
                  'Registration',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'User ID'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () => register(),
                    child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),),
                SizedBox(height: 100),
                Text('Already have an account? '),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () => _goToLoginScreen(),
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
