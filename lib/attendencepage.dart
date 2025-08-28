// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AttendancePage extends StatefulWidget {
//   const AttendancePage({Key? key}) : super(key: key);

//   @override
//   State<AttendancePage> createState() => _AttendancePageState();
// }

// class _AttendancePageState extends State<AttendancePage> {
//   final supabase = Supabase.instance.client;

//   List<dynamic> students = [];
//   List<dynamic> batches = [];
//   bool isLoading = true;
//   String selectedBatch = "All";
//   final today = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _fetchBatches();
//     _fetchStudents(); // default fetch (all)
//   }

//   Future<void> _fetchBatches() async {
//     final response = await supabase.from('batches').select('batch');
//     setState(() {
//       batches = response.map((b) => b['batch']).toList();
//     });
//   }

//   Future<void> _fetchStudents({String? batch}) async {
//     var query = supabase.from('profiles').select();
//     if (batch != null && batch != "All") {
//       query = query.eq('batch', batch);
//     }
//     final response = await query;
//     setState(() {
//       students = response;
//       isLoading = false;
//     });
//   }

//   Future<void> _markAttendance(String studentId, String batchId, bool isPresent) async {
//     final todayDate = "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

//     // Check if entry exists
//     final existing = await supabase
//         .from('attendance')
//         .select()
//         .eq('student_id', studentId)
//         .eq('date', todayDate)
//         .maybeSingle();

//     if (existing != null) {
//       // Update
//       await supabase.from('attendance').update({
//         'present': isPresent,
//       }).match({
//         'student_id': studentId,
//         'date': todayDate,
//       });
//     } else {
//       // Insert
//       await supabase.from('attendance').insert({
//         'student_id': studentId,
//         'batch': batchId,
//         'date': todayDate,
//         'present': isPresent,
//       });
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Marked ${isPresent ? 'Present' : 'Absent'}")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Mark Attendance"),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: DropdownButton<String>(
//               value: selectedBatch,
//               isExpanded: true,
//               items: ["All", ...batches].map((batch) {
//                 return DropdownMenuItem<String>(
//                   value: batch,
//                   child: Text(batch),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value == null) return;
//                 setState(() {
//                   selectedBatch = value;
//                   isLoading = true;
//                 });
//                 _fetchStudents(batch: value);
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: students.length,
//               itemBuilder: (context, index) {
//                 final student = students[index];
//                 return ListTile(
//                   title: Text(student['name'] ?? 'Unknown'),
//                   subtitle: Text("Batch: ${student['batch'] ?? 'N/A'}"),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.check, color: Colors.green),
//                         onPressed: () => _markAttendance(student['user_id'], student['batch'], true),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.red),
//                         onPressed: () => _markAttendance(student['user_id'], student['batch'], false),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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
  List<dynamic> batches = [];
  bool isLoading = true;
  String selectedBatch = "All";
  final today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchBatches();
    _fetchStudents(); // default fetch (all)
  }

  Future<void> _fetchBatches() async {
    final response = await supabase.from('batches').select('batch');
    setState(() {
      batches = response.map((b) => b['batch']).toList();
    });
  }

  Future<void> _fetchStudents({String? batch}) async {
    var query = supabase.from('profiles').select();
    if (batch != null && batch != "All") {
      query = query.eq('batch', batch);
    }
    final response = await query;
    setState(() {
      students = response;
      isLoading = false;
    });
  }

  Future<void> _markAttendance(String studentId, String batchId, bool isPresent) async {
    final todayDate =
        "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final existing = await supabase
        .from('attendance')
        .select()
        .eq('student_id', studentId)
        .eq('date', todayDate)
        .maybeSingle();

    if (existing != null) {
      await supabase.from('attendance').update({
        'present': isPresent,
      }).match({
        'student_id': studentId,
        'date': todayDate,
      });
    } else {
      await supabase.from('attendance').insert({
        'student_id': studentId,
        'batch': batchId,
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
    final theme = Theme.of(context); // access theme colors

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedBatch,
              isExpanded: true,
              items: ["All", ...batches].map((batch) {
                return DropdownMenuItem<String>(
                  value: batch,
                  child: Text(batch),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  selectedBatch = value;
                  isLoading = true;
                });
                _fetchStudents(batch: value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student['name'] ?? 'Unknown'),
                  subtitle: Text("Batch: ${student['batch'] ?? 'N/A'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: theme.colorScheme.primary),
                        onPressed: () => _markAttendance(student['user_id'], student['batch'], true),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: theme.colorScheme.error),
                        onPressed: () => _markAttendance(student['user_id'], student['batch'], false),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
