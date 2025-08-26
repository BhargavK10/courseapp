import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BatchWiseAttendancePage extends StatefulWidget {
  @override
  _BatchWiseAttendancePageState createState() => _BatchWiseAttendancePageState();
}

class _BatchWiseAttendancePageState extends State<BatchWiseAttendancePage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _batches = [];
  String? _selectedBatch;
  List<Map<String, dynamic>> _attendance = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchBatches();
  }

  Future<void> _fetchBatches() async {
    final response = await supabase.from('batches').select();
    setState(() {
      _batches = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _fetchAttendance(String batch) async {
    setState(() => _loading = true);

    final response = await supabase
        .from('attendance')
        .select('id, date, present, profiles!inner(name)')
        .eq('batch', batch);

    setState(() {
      _attendance = List<Map<String, dynamic>>.from(response);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Batch-wise Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting batch
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Select Batch"),
              value: _selectedBatch,
              items: _batches
                  .map((batch) => DropdownMenuItem<String>(
                        value: batch['batch'],
                        child: Text(batch['batch']),
                      )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBatch = value;
                  _attendance.clear();
                });
                if (value != null) {
                  _fetchAttendance(value);
                }
              },
            ),
            SizedBox(height: 20),

            _loading
                ? CircularProgressIndicator()
                : Expanded(
                    child: _attendance.isEmpty
                        ? Center(child: Text("No attendance records"))
                        : ListView.builder(
                            itemCount: _attendance.length,
                            itemBuilder: (context, index) {
                              final record = _attendance[index];
                              final studentName = record['profiles']['name'];
                              final date = record['date'];
                              final present = record['present'];

                              return Card(
                                child: ListTile(
                                  title: Text(studentName),
                                  subtitle: Text("Date: $date"),
                                  trailing: Icon(
                                    present ? Icons.check: Icons.close,
                                    color: present ? Colors.green : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
