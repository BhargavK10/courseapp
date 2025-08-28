// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'addVideo.dart';
// import 'editVideo.dart';
// import 'videoPlayer.dart';
// import 'EditSubcoursePage.dart';

// class SubcourseManagePage extends StatefulWidget {
//   final Map<String, dynamic> subcourse;

//   const SubcourseManagePage({super.key, required this.subcourse});

//   @override
//   State<SubcourseManagePage> createState() => _SubcourseManagePageState();
// }

// class _SubcourseManagePageState extends State<SubcourseManagePage> {
//   late Map<String, dynamic> subcourse;
//   List<Map<String, dynamic>> videos = [];

//   @override
//   void initState() {
//     super.initState();
//     subcourse = widget.subcourse;
//     _fetchVideos();
//   }

//   Future<void> _fetchSubcourse() async {
//     final response = await Supabase.instance.client
//         .from("subcourses")
//         .select()
//         .eq("id", subcourse["id"]);

//     if (response.isNotEmpty) {
//       setState(() {
//         subcourse = response.first;
//       });
//     }
//   }

//   Future<void> _fetchVideos() async {
//     final response = await Supabase.instance.client
//         .from("Videos")
//         .select()
//         .eq("subcourse_id", subcourse["id"])
//         .order("index", ascending: true);

//     setState(() {
//       videos = List<Map<String, dynamic>>.from(response);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//   title: Text(subcourse["title"] ?? "Manage Subcourse"),
//   backgroundColor: Colors.blue,
//   foregroundColor: Colors.white,
//   actions: [
//     IconButton(
//       icon: const Icon(Icons.edit),
//       onPressed: () async {
//         final updated = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => EditSubcoursePage(subcourse: subcourse),
//           ),
//         );
//         if (updated == true) {
//           _fetchSubcourse(); // refresh details
//         }
//       },
//     ),
//   ],
// ),

//       body: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Subcourse Info Card
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
//                       subcourse["title"] ?? "Untitled Subcourse",
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       subcourse["description"] ?? "No description available",
//                       style: const TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Add Video Button
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final added = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => AddVideoPage(
//                       subcourseId: subcourse["id"],
//                       courseId: subcourse["course_id"],
//                     ),
//                   ),
//                 );
//                 if (added == true) {
//                   _fetchVideos(); // refresh list
//                 }
//               },
//               icon: const Icon(Icons.add, size: 22),
//               label: const Text(
//                 "Add New Video",
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
//               "🎬 Subcourse Videos",
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Video List
//             Expanded(
//               child: videos.isEmpty
//                   ? const Center(
//                       child: Text(
//                         "No videos added yet",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: videos.length,
//                       itemBuilder: (context, index) {
//                         final video = videos[index];
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
//                                   video["thumbnail"] != null &&
//                                       video["thumbnail"].toString().isNotEmpty
//                                   ? Image.network(
//                                       video["thumbnail"],
//                                       width: 70,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Container(
//                                       width: 70,
//                                       height: 50,
//                                       color: Colors.grey.shade200,
//                                       child: const Icon(
//                                         Icons.video_library,
//                                         size: 30,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                             ),
//                             title: Text(
//                               video["title"] ?? "Untitled",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               video["description"] ?? "No description",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(
//                                     Icons.edit,
//                                     color: Colors.blue,
//                                   ),
//                                   onPressed: () async {
//                                     final updated = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) =>
//                                             EditVideoPage(video: video),
//                                       ),
//                                     );
//                                     if (updated == true) {
//                                       _fetchVideos(); // refresh
//                                     }
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(
//                                     Icons.play_circle_fill,
//                                     color: Colors.green,
//                                     size: 32,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => VideoPlayerPage(
//                                           videoUrl: video["video_url"],
//                                           title: video["title"],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
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
import 'addVideo.dart';
import 'editVideo.dart';
import 'videoPlayer.dart';
import 'EditSubcoursePage.dart';

class SubcourseManagePage extends StatefulWidget {
  final Map<String, dynamic> subcourse;

  const SubcourseManagePage({super.key, required this.subcourse});

  @override
  State<SubcourseManagePage> createState() => _SubcourseManagePageState();
}

class _SubcourseManagePageState extends State<SubcourseManagePage> {
  late Map<String, dynamic> subcourse;
  List<Map<String, dynamic>> videos = [];

  @override
  void initState() {
    super.initState();
    subcourse = widget.subcourse;
    _fetchVideos();
  }

  Future<void> _fetchSubcourse() async {
    final response = await Supabase.instance.client
        .from("subcourses")
        .select()
        .eq("id", subcourse["id"]);

    if (response.isNotEmpty) {
      setState(() {
        subcourse = response.first;
      });
    }
  }

  Future<void> _fetchVideos() async {
    final response = await Supabase.instance.client
        .from("Videos")
        .select()
        .eq("subcourse_id", subcourse["id"])
        .order("index", ascending: true);

    setState(() {
      videos = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(subcourse["title"] ?? "Manage Subcourse"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditSubcoursePage(subcourse: subcourse),
                ),
              );
              if (updated == true) {
                _fetchSubcourse(); // refresh details
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
                      subcourse["title"] ?? "Untitled Subcourse",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subcourse["description"] ?? "No description available",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
                    builder: (_) => AddVideoPage(
                      subcourseId: subcourse["id"],
                      courseId: subcourse["course_id"],
                    ),
                  ),
                );
                if (added == true) {
                  _fetchVideos(); 
                }
              },
              icon: const Icon(Icons.add, size: 22),
              label: const Text(
                "Add New Video",
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
              "🎬 Subcourse Videos",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),

            // Video List
            Expanded(
              child: videos.isEmpty
                  ? Center(
                      child: Text(
                        "No videos added yet",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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
                              child: (video["thumbnail"] != null &&
                                      video["thumbnail"].toString().isNotEmpty)
                                  ? Image.network(
                                      video["thumbnail"],
                                      width: 70,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 70,
                                      height: 50,
                                      color: theme.colorScheme.surfaceVariant,
                                      child: Icon(
                                        Icons.video_library,
                                        size: 30,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                            ),
                            title: Text(
                              video["title"] ?? "Untitled",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              video["description"] ?? "No description",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: theme.colorScheme.primary,
                                  ),
                                  onPressed: () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditVideoPage(video: video),
                                      ),
                                    );
                                    if (updated == true) {
                                      _fetchVideos(); // refresh
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.play_circle_fill,
                                    color: theme.colorScheme.secondary,
                                    size: 32,
                                  ),
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
                              ],
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
