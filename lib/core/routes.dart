import 'package:flutter/material.dart';
import 'package:ibc_app/screens/home/home_screen.dart';
import 'package:ibc_app/screens/login/login_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Página não encontrada: ${settings.name}')),
          ),
        );
    }
  }
}