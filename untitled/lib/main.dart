import 'package:flutter/material.dart';
import 'package:untitled/customization.dart';
import 'user.dart';
import 'pizza.dart';
import 'register.dart';
import 'login.dart';
import 'home.dart';
import 'checkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Registration
          case "/register":
            return MaterialPageRoute(builder: (context) => RegisterScreen());

          // Login
          case "/login":
            return MaterialPageRoute(builder: (context) => LoginScreen());

          // Home
          case "/home":
            final user = settings.arguments as User;
            return MaterialPageRoute(
              builder: (context) => HomeScreen(user: user),
            );

          // Customize
          case "/customize":
            final args = settings.arguments as Map<String, dynamic>;
            final user = args['user'] as User;
            final pizza = args['pizza'] as Pizza;
            return MaterialPageRoute(
              builder: (context) =>
                  CustomizationScreen(user: user, pizza: pizza),
            );

          // Checkout
          case "/checkout":
            final args = settings.arguments as Map<String, dynamic>;
            final user = args['user'] as User;
            final totalPrice = args['totalPrice'] as double;

            return MaterialPageRoute(
              builder: (context) =>
                  CheckoutScreen(user: user, totalPrice: totalPrice),
            );

          default:
            return null;
        }
      },
    );
  }
}
