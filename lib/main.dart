import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/FindFavor/login.dart';
import 'FindFavor/Maps_Page.dart';
import 'FindFavor/Register_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const MapsView(
              userName: '',
              registeredUsers: [],
            ),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
            systemOverlayStyle: SystemUiOverlayStyle.dark),
      ),
      home: const LoginPage(),
    );
  }
}
