import 'package:flutter/material.dart';
import 'core/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IBC App',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}