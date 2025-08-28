// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class EditVideoPage extends StatefulWidget {
//   final Map<String, dynamic> video;

//   const EditVideoPage({super.key, required this.video});

//   @override
//   State<EditVideoPage> createState() => _EditVideoPageState();
// }

// class _EditVideoPageState extends State<EditVideoPage> {
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   bool isPaid = false;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.video["title"]);
//     _descriptionController =
//         TextEditingController(text: widget.video["description"]);
//     isPaid = widget.video["is_paid"] ?? false;
//   }

//   /// Update video in Supabase
//   Future<void> _updateVideo() async {
//     setState(() => isLoading = true);
//     try {
//       final response = await Supabase.instance.client
//           .from("Videos")
//           .update({
//             "title": _titleController.text.trim(),
//             "description": _descriptionController.text.trim(),
//             "is_paid": isPaid,
//           })
//           .eq("id", widget.video["id"])
//           .select();

//       if (response.isEmpty) {
//         throw "Update failed. No row updated.";
//       }

//       if (mounted) Navigator.pop(context, true); // return success
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error updating video: $e")),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   /// Delete video
//   Future<void> _deleteVideo() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Video"),
//         content: const Text(
//             "Are you sure you want to delete this video? This cannot be undone."),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text("Cancel")),
//           TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text("Delete",
//                   style: TextStyle(color: Colors.red))),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       try {
//         await Supabase.instance.client
//             .from("Videos")
//             .delete()
//             .eq("id", widget.video["id"]);
//         if (mounted) Navigator.pop(context, true); // return success
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error deleting video: $e")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Video"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: "Video Title"),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _descriptionController,
//               maxLines: 3,
//               decoration: const InputDecoration(labelText: "Description"),
//             ),
//             const SizedBox(height: 12),
//             SwitchListTile(
//               title: const Text("Is this video Paid?"),
//               value: isPaid,
//               onChanged: (val) => setState(() => isPaid = val),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: isLoading ? null : _updateVideo,
//               icon: const Icon(Icons.save),
//               label: const Text("Update Video"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//             ),
//             const SizedBox(height: 20),
//             OutlinedButton.icon(
//               onPressed: isLoading ? null : _deleteVideo,
//               icon: const Icon(Icons.delete, color: Colors.red),
//               label: const Text("Delete Video",
//                   style: TextStyle(color: Colors.red)),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 side: const BorderSide(color: Colors.red),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditVideoPage extends StatefulWidget {
  final Map<String, dynamic> video;

  const EditVideoPage({super.key, required this.video});

  @override
  State<EditVideoPage> createState() => _EditVideoPageState();
}

class _EditVideoPageState extends State<EditVideoPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool isPaid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.video["title"]);
    _descriptionController =
        TextEditingController(text: widget.video["description"]);
    isPaid = widget.video["is_paid"] ?? false;
  }

  
  Future<void> _updateVideo() async {
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from("Videos")
          .update({
            "title": _titleController.text.trim(),
            "description": _descriptionController.text.trim(),
            "is_paid": isPaid,
          })
          .eq("id", widget.video["id"])
          .select();

      if (response.isEmpty) {
        throw "Update failed. No row updated.";
      }

      if (mounted) Navigator.pop(context, true); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating video: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Delete video
  Future<void> _deleteVideo() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Video"),
        content: const Text(
            "Are you sure you want to delete this video? This cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Delete",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client
            .from("Videos")
            .delete()
            .eq("id", widget.video["id"]);
        if (mounted) Navigator.pop(context, true); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting video: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Video"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Video Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text("Is this video Paid?"),
              value: isPaid,
              onChanged: (val) => setState(() => isPaid = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _updateVideo,
              icon: const Icon(Icons.save),
              label: const Text("Update Video"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: isLoading ? null : _deleteVideo,
              icon: Icon(Icons.delete, color: colorScheme.error),
              label: Text(
                "Delete Video",
                style: TextStyle(color: colorScheme.error),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
