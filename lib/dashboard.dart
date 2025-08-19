// import 'package:courseapp/main.dart';
// import 'package:courseapp/titlebar.dart';
// import 'package:flutter/material.dart';

// class Dashboard extends StatelessWidget {
//   const Dashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: titleBar(),
//       body: Center(
//         child: Column(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.95,
//               decoration: BoxDecoration(
//                 color: secondaryColor,
//                 borderRadius: BorderRadius.circular(10)
//               ),
//               child: Padding(
//                 padding: EdgeInsetsGeometry.only(top: 10, bottom: 10, left: 10),
//                 child: Text(
//                   'Welcome <user here>',
//                 ),
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:courseapp/createcourse.dart';
import 'package:courseapp/drawermenu.dart';
import 'package:courseapp/func.dart';
import 'package:courseapp/topbar.dart';
import 'package:courseapp/courses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final recentCourses = courses.take(3).toList(); // Show only the first 3 courses

    return Scaffold(
      appBar: topBar(context, 'Dashboard'),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome, $userName",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 10),
            Divider(height: 1,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Courses",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllCoursesPage(courses: courses)
                      ),
                    );
                  },
                  child: const Text("Show All"),
                ),
              ],
            ),

            ...recentCourses.map((course) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    course["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(course["description"]!),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigate to edit/manage this course
                    },
                    child: Icon(Icons.settings),
                  ),
                ),
              );
            }),

            Padding(
              padding: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateCourse()));
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width*0.92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(127),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    color: Colors.blue.shade50
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: const Color.fromARGB(255, 161, 161, 161)
                      ),
                    )
                  )
                  // Icon(CupertinoIcons.plus),
                ),
              )
            ),
            
            const SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                // Navigate to statistics page
              },
              child: Card(
                color: Colors.blue.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.bar_chart, size: 40, color: Colors.blue.shade700),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "View Statistics",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Total Students: $totalStudents",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,size: 18, color: Colors.blue.shade700),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}