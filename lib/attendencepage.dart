import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final supabase = Supabase.instance.client;

  List<dynamic> students = [];
  bool isLoading = true;
  final today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final response = await supabase.from('profiles').select();
    setState(() {
      students = response;
      isLoading = false;
    });
  }

  Future<void> _markAttendance(String studentId, bool isPresent) async {
    final todayDate = "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // Check if entry exists
    final existing = await supabase
        .from('attendance')
        .select()
        .eq('student_id', studentId)
        .eq('date', todayDate)
        .maybeSingle();

    if (existing != null) {
      // Update
      await supabase.from('attendance').update({
        'present': isPresent,
      }).match({
        'student_id': studentId,
        'date': todayDate,
      });
    } else {
      // Insert
      await supabase.from('attendance').insert({
        'student_id': studentId,
        'date': todayDate,
        'present': isPresent,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Marked ${isPresent ? 'Present' : 'Absent'}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            title: Text(student['name'] ?? 'Unknown'),
            subtitle: Text("ID: ${student['user_id']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => _markAttendance(student['user_id'], true),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _markAttendance(student['user_id'], false),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
