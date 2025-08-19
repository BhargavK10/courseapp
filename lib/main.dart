import 'package:courseapp/dashboard.dart';
import 'package:flutter/material.dart';
const Color primaryColor = Color(0xFFEFEFEF);
const Color secondaryColor = Color(0xFFD7D7D7);
const Color secondaryColor2 = Color(0xFF2C3137);
const Color accentCOlor = Color(0xFFDB3939);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Dashboard(),
    );
  }
}