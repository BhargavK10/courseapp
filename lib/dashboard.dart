import 'package:courseapp/addcourse.dart';
import 'package:courseapp/drawermenu.dart';
import 'package:courseapp/topbar.dart';
import 'package:courseapp/manageCourse.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() => _isLoading = true);

    try {
      final response = await supabase
          .from('courses')
          .select()
          .order('id', ascending: false)
          .limit(3);

      setState(() {
        courses = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error loading courses: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, 'Dashboard'),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Admin",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Courses",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // ✅ Show Courses from Supabase
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (courses.isEmpty)
              const Text("No courses available yet.")
            else
              ...courses.map((course) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      course["title"] ?? "Untitled",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(course["description"] ?? ""),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseManagePage(course: course)
                          ),
                        );

                        if (updated == true) {
                          await _fetchCourses(); // refresh from DB
                        }
                      },
                      child: const Icon(Icons.settings),
                    ),
                  ),
                );
              }),

            // ✅ Add New Course button
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCoursePage()),
                  );
                  _fetchCourses();
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(127),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    color: Colors.blue.shade50,
                  ),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Color.fromARGB(255, 161, 161, 161),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Statistics Card (dummy for now)
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
                      Icon(
                        Icons.bar_chart,
                        size: 40,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "View Statistics",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Total Students: 120", // can fetch from Supabase too
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
