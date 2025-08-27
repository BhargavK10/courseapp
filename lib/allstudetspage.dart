import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({Key? key}) : super(key: key);

  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchStudents() async {
    final response = await supabase.from('profiles').select('name, email, batch');
    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Students")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student['name'] ?? "Unnamed"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student['email'] ?? "", style: const TextStyle(fontSize: 14)),
                    Text("Batch: ${student['batch'] ?? ''}", style: const TextStyle(fontSize: 12)),
                  ],
                ),
                leading: const Icon(Icons.person, color: Colors.blue),
              );
            },
          );
        },
      ),
    );
  }
}
