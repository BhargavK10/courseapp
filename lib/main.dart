import 'package:courseapp/attendencepage.dart';
import 'package:courseapp/daywiseattendance.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      home: DayWiseAttendancePage(),
    );
  }
}
