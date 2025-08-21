import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:courseapp/dashboard.dart';

const Color primaryColor = Color(0xFFEFEFEF);
const Color secondaryColor = Color(0xFFD7D7D7);
const Color secondaryColor2 = Color(0xFF2C3137);
const Color accentCOlor = Color(0xFFDB3939);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://mpzkujenrcynrcijvmam.supabase.co',   
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wemt1amVucmN5bnJjaWp2bWFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjA3MzIsImV4cCI6MjA3MDYzNjczMn0.18L4anczZxldOjlxLCCEnnWi3x11Hd4OMi6sMy4zbx8',         
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course App',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryColor,
      ),
      home: const Dashboard(),
    );
  }
}
