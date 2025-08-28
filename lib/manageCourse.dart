// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'AddSubcourse.dart';
// import 'editcourse.dart';
// import 'subcourseManagePage.dart';

// class CourseManagePage extends StatefulWidget {
//   final Map<String, dynamic> course;

//   const CourseManagePage({super.key, required this.course});

//   @override
//   State<CourseManagePage> createState() => _CourseManagePageState();
// }

// class _CourseManagePageState extends State<CourseManagePage> {
//   late Map<String, dynamic> course;
//   List<Map<String, dynamic>> subcourses = [];

//   @override
//   void initState() {
//     super.initState();
//     course = widget.course;
//     _fetchSubcourses();
//   }

//   Future<void> _fetchCourses() async {
//     final response = await Supabase.instance.client
//         .from("courses")
//         .select()
//         .eq("id", course["id"]);

//     if (response.isNotEmpty) {
//       setState(() {
//         course = response.first;
//       });
//     }
//   }

//   Future<void> _fetchSubcourses() async {
//     final response = await Supabase.instance.client
//         .from("subcourses")
//         .select()
//         .eq("course_id", course["id"]);

//     setState(() {
//       subcourses = List<Map<String, dynamic>>.from(response);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(course["title"] ?? "Manage Course"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             tooltip: "Edit Course",
//             onPressed: () async {
//               final updated = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => EditCoursePage(course: course),
//                 ),
//               );

//               if (updated == true) {
//                 await _fetchCourses();
//                 Navigator.pop(context, true);
//               }
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Course Info Card
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       course["title"] ?? "Untitled Course",
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       course["description"] ?? "No description available",
//                       style: const TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Add Subcourse Button
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final added = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => AddSubcoursePage(courseId: course["id"].toString()),

//                   ),
//                 );
//                 if (added == true) {
//                   _fetchSubcourses(); // refresh list
//                 }
//               },
//               icon: const Icon(Icons.add, size: 22),
//               label: const Text(
//                 "Add New Subcourse",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             Text(
//               "📚 Subcourses",
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Subcourse List
//             Expanded(
//               child: subcourses.isEmpty
//                   ? const Center(
//                       child: Text(
//                         "No subcourses added yet",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: subcourses.length,
//                       itemBuilder: (context, index) {
//                         final sub = subcourses[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(12),
//                             leading: ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child:
//                                   sub["Thumbnail"] != null &&
//                                           sub["Thumbnail"].toString().isNotEmpty
//                                       ? Image.network(
//                                           sub["Thumbnail"],
//                                           width: 70,
//                                           height: 50,
//                                           fit: BoxFit.cover,
//                                         )
//                                       : Container(
//                                           width: 70,
//                                           height: 50,
//                                           color: Colors.grey.shade200,
//                                           child: const Icon(
//                                             Icons.book,
//                                             size: 30,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                             ),
//                             title: Text(
//                               sub["title"] ?? "Untitled",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               sub["description"] ?? "No description",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.blue,
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       SubcourseManagePage(subcourse: sub),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AddSubcourse.dart';
import 'editcourse.dart';
import 'subcourseManagePage.dart';

class CourseManagePage extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseManagePage({super.key, required this.course});

  @override
  State<CourseManagePage> createState() => _CourseManagePageState();
}

class _CourseManagePageState extends State<CourseManagePage> {
  late Map<String, dynamic> course;
  List<Map<String, dynamic>> subcourses = [];

  @override
  void initState() {
    super.initState();
    course = widget.course;
    _fetchSubcourses();
  }

  Future<void> _fetchCourses() async {
    final response = await Supabase.instance.client
        .from("courses")
        .select()
        .eq("id", course["id"]);

    if (response.isNotEmpty) {
      setState(() {
        course = response.first;
      });
    }
  }

  Future<void> _fetchSubcourses() async {
    final response = await Supabase.instance.client
        .from("subcourses")
        .select()
        .eq("course_id", course["id"]);

    setState(() {
      subcourses = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // shortcut for colors & text styles

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(course["title"] ?? "Manage Course"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Course",
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCoursePage(course: course),
                ),
              );

              if (updated == true) {
                await _fetchCourses();
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Course Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["title"] ?? "Untitled Course",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      course["description"] ?? "No description available",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

           
            ElevatedButton.icon(
              onPressed: () async {
                final added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddSubcoursePage(courseId: course["id"].toString()),
                  ),
                );
                if (added == true) {
                  _fetchSubcourses(); 
                }
              },
              icon: const Icon(Icons.add, size: 22),
              label: const Text(
                "Add New Subcourse",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "📚 Subcourses",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),

           
            Expanded(
              child: subcourses.isEmpty
                  ? Center(
                      child: Text(
                        "No subcourses added yet",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: subcourses.length,
                      itemBuilder: (context, index) {
                        final sub = subcourses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: sub["Thumbnail"] != null &&
                                      sub["Thumbnail"].toString().isNotEmpty
                                  ? Image.network(
                                      sub["Thumbnail"],
                                      width: 70,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 70,
                                      height: 50,
                                      color: theme.colorScheme.surfaceVariant,
                                      child: Icon(
                                        Icons.book,
                                        size: 30,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                            ),
                            title: Text(
                              sub["title"] ?? "Untitled",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,

                              ),
                            ),
                            subtitle: Text(
                              sub["description"] ?? "No description",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: theme.colorScheme.primary,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SubcourseManagePage(subcourse: sub),
                                ),
                              );
                            },
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
