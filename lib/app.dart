import 'package:flutter/material.dart';
import 'package:crud_flutter/screen/_import.dart';

class CrudPersonApp extends StatelessWidget {
  const CrudPersonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'Crud person',
      home: const LoginScreen(),
      routes: {
        '/page': (context) => const PageScreen()
      },
    );
  }
}
