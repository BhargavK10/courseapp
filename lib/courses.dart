// import 'package:courseapp/drawermenu.dart';
// import 'package:courseapp/topbar.dart';
// import 'package:flutter/material.dart';

// class AllCoursesPage extends StatelessWidget {
//   final List<Map<String, String>> courses;

//   const AllCoursesPage({super.key, required this.courses});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: topBar(context, 'Courses'),
//       drawer: DrawerMenu(),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: courses.length,
//         itemBuilder: (context, index) {
//           final course = courses[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             elevation: 2,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             child: ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               title: Text(
//                 course["title"]!,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(course["description"]!),
//               trailing: ElevatedButton(
//                 onPressed: () {
//                   // Navigate to edit/manage this course
//                 },
//                 child: const Text("Manage"),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:courseapp/drawermenu.dart';
import 'package:courseapp/topbar.dart';
import 'package:flutter/material.dart';

class AllCoursesPage extends StatelessWidget {
  final List<Map<String, String>> courses;

  const AllCoursesPage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, 'Courses'),
      drawer: DrawerMenu(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                course[''] != null
                    ? Image.asset(
                        course['']!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50),
                      ),

                // Title & description
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course["title"] ?? "No title",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        course["description"] ?? "",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to edit/manage this course
                          },
                          child: const Text("Manage"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
