// import 'package:courseapp/allstudetspage.dart';
// import 'package:courseapp/attendencepage.dart';
// import 'package:courseapp/batchwiseattendance.dart';
// import 'package:courseapp/daywiseattendance.dart';
// import 'package:flutter/material.dart';

// class AttendanceDashboard extends StatelessWidget {
//   const AttendanceDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Attendance"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildCard(
//               context,
//               title: "All Students",
//               icon: Icons.people,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => AllStudentsPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildCard(
//               context,
//               title: "Mark Attendance",
//               icon: Icons.check_circle,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => AttendancePage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildCard(
//               context,
//               title: "Day Wise Attendance",
//               icon: Icons.calendar_today,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => DayWiseAttendancePage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildCard(
//               context,
//               title: "Batch Wise Attendance",
//               icon: Icons.class_,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => BatchWiseAttendancePage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context,
//       {required String title,
//       required IconData icon,
//       required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 48, color: Colors.blueGrey),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:courseapp/allstudetspage.dart';
import 'package:courseapp/attendencepage.dart';
import 'package:courseapp/batchwiseattendance.dart';
import 'package:courseapp/daywiseattendance.dart';
import 'package:flutter/material.dart';

class AttendanceDashboard extends StatelessWidget {
  const AttendanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              context,
              title: "All Students",
              icon: Icons.people,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllStudentsPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: "Mark Attendance",
              icon: Icons.check_circle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AttendancePage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: "Day Wise Attendance",
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DayWiseAttendancePage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: "Batch Wise Attendance",
              icon: Icons.class_,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BatchWiseAttendancePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.primary), // ✅ theme-based color
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
