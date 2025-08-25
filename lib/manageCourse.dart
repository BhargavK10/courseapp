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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(course["title"] ?? "Manage Course"),
        backgroundColor: Colors.blue,
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
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      course["description"] ?? "No description available",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
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
              icon: const Icon(Icons.add, size: 22),
              label: const Text(
                "Add New Video",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "🎬 Course Videos",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 10),

            // Video List
            Expanded(
              child: videos.isEmpty
                  ? const Center(
                      child: Text(
                        "No videos added yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
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
                              child: video["thumbnail"] != null &&
                                      video["thumbnail"]
                                          .toString()
                                          .isNotEmpty
                                  ? Image.network(
                                      video["thumbnail"],
                                      width: 70,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 70,
                                      height: 50,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.video_library,
                                          size: 30, color: Colors.grey),
                                    ),
                            ),
                            title: Text(
                              video["title"] ?? "Untitled",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              video["description"] ?? "No description",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.play_circle_fill,
                                  color: Colors.green, size: 32),
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
