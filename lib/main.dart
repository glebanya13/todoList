import 'package:flutter/material.dart';
import 'package:firebase/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.deepOrangeAccent,
        ),
        home: const Home(),
      )
  );
}