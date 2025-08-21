import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DayWiseAttendancePage extends StatefulWidget {
  const DayWiseAttendancePage({Key? key}) : super(key: key);

  @override
  _DayWiseAttendancePageState createState() => _DayWiseAttendancePageState();
}

class _DayWiseAttendancePageState extends State<DayWiseAttendancePage> {
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  List<Map<String, dynamic>> _attendanceRecords = [];

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await supabase
          .from('attendance')
          .select('present, student_id, profiles(name)')
          .eq('date', _selectedDate.toIso8601String().split("T").first)
          .order('student_id');

      setState(() {
        _attendanceRecords = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching attendance: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchAttendance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Day-wise Attendance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _attendanceRecords.isEmpty
              ? const Center(child: Text("No attendance records found"))
              : ListView.builder(
                  itemCount: _attendanceRecords.length,
                  itemBuilder: (context, index) {
                    final record = _attendanceRecords[index];
                    final studentName = record['profiles']['name'];
                    final present = record['present'] as bool;

                    return ListTile(
                      title: Text(studentName ?? "Unknown"),
                      trailing: Icon(
                        present ? Icons.check : Icons.close,
                        color: present ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
    );
  }
}
