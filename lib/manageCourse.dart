import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'addVideo.dart';
import 'editcourse.dart';
import 'videoPlayer.dart';

class CourseManagePage extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseManagePage({super.key, required this.course});

  @override
  State<CourseManagePage> createState() => _CourseManagePageState();
}

class _CourseManagePageState extends State<CourseManagePage> {
  late Map<String, dynamic> course;
  List<Map<String, dynamic>> videos = [];

  @override
  void initState() {
    super.initState();
    course = widget.course;
    _fetchVideos();
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

  Future<void> _fetchVideos() async {
    final response = await Supabase.instance.client
        .from("Videos")
        .select()
        .eq("course_id", course["id"])
        .order("index", ascending: true);

    setState(() {
      videos = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course["title"] ?? "Manage Course"),
        backgroundColor: const Color(0xFF2C3137),
        foregroundColor: Colors.white,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Course: ${course["title"] ?? "Untitled"}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              course["description"] ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Add Video Button
            ElevatedButton.icon(
              onPressed: () async {
                final added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddVideoPage(courseId: course["id"]),
                  ),
                );
                if (added == true) {
                  _fetchVideos(); // refresh list
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Video"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF2C3137),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Videos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: videos.isEmpty
                  ? const Center(child: Text("No videos yet"))
                  : ListView.builder(
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return Card(
                          child: ListTile(
                            leading: video["thumbnail"] != null &&
                                    video["thumbnail"].toString().isNotEmpty
                                ? Image.network(video["thumbnail"],
                                    width: 60, fit: BoxFit.cover)
                                : const Icon(Icons.video_library, size: 40),
                            title: Text(video["title"] ?? "Untitled"),
                            subtitle:
                                Text(video["description"] ?? "No description"),
                            trailing: IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoPlayerPage(
                                      videoUrl: video["video_url"],
                                      title: video["title"],
                                    ),
                                  ),
                                );
                              },
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
