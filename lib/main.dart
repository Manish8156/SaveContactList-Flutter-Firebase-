import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'screens/HomePage.dart';
import 'package:flutter/material.dart';
void main()
async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        primarySwatch: Colors.red
      ),
      title: "My Contacts",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
