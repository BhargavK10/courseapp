

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class EditCoursePage extends StatefulWidget {
  final Map<String, dynamic> course;

  const EditCoursePage({super.key, required this.course});

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _hostController;
  late TextEditingController _validityController;

  bool _isLoading = false;
  File? _thumbnailImage;
  final ImagePicker _picker = ImagePicker();

  final supabase = Supabase.instance.client;

  // Internet Archive access keys
  final String accessKey = "wAXCfd5mHnqqL254";
  final String secretKey = "aPFJPWYfZrlHpnIA";

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.course["title"] ?? "",
    );
    _descController = TextEditingController(
      text: widget.course["description"] ?? "",
    );
    _priceController = TextEditingController(
      text: widget.course["price"]?.toString() ?? "",
    );
    _hostController = TextEditingController(text: widget.course["host"] ?? "");
    _validityController = TextEditingController(
      text: widget.course["validity_months"]?.toString() ?? "",
    );
  }

  Future<void> _pickThumbnail() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _thumbnailImage = File(pickedFile.path));
    }
  }

  Future<String?> _uploadToInternetArchive(File file) async {
    try {
      final identifier = "course_${DateTime.now().millisecondsSinceEpoch}";
      final fileName = file.uri.pathSegments.last;

      final url = Uri.parse("https://s3.us.archive.org/$identifier/$fileName");
      final bytes = await file.readAsBytes();

      final response = await http.put(
        url,
        headers: {
          "authorization": "LOW $accessKey:$secretKey",
          "x-archive-auto-make-bucket": "1",
          "Content-Type": "image/jpeg",
        },
        body: bytes,
      );

      if (response.statusCode == 200) {
        return "https://archive.org/download/$identifier/$fileName";
      } else {
        debugPrint(
          "❌ IA Upload failed: ${response.statusCode} ${response.body}",
        );
        return null;
      }
    } catch (e) {
      debugPrint("❌ IA Exception: $e");
      return null;
    }
  }

  Future<void> _updateCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? thumbnailUrl = widget.course["Thumbnail"];

      // Upload new thumbnail if picked
      if (_thumbnailImage != null) {
        final uploadedUrl = await _uploadToInternetArchive(_thumbnailImage!);
        if (uploadedUrl != null) {
          thumbnailUrl = uploadedUrl;
        }
      }

      // ⚡ FIX: Don't convert UUID to string
      final courseId = widget.course["id"];

      final response = await supabase
          .from("courses")
          .update({
            'title': _titleController.text.trim(),
            'description': _descController.text.trim(),
            'price': int.tryParse(_priceController.text.trim()) ?? 0,
            'host': _hostController.text.trim(),
            'validity_months': int.tryParse(_validityController.text) ?? 0,
            'Thumbnail': thumbnailUrl ?? "",
          })
          .eq("id", courseId)
          .select();

      setState(() => _isLoading = false);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No rows updated. Check UUID or RLS!")),
        );
      } else {
        widget.course["Thumbnail"] = thumbnailUrl;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Course updated successfully!")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _deleteCourse() async {
    final courseId = widget.course["id"];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Course"),
        content: const Text(
          "Are you sure you want to delete this course? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      setState(() => _isLoading = true);

      final response = await supabase
          .from("courses")
          .delete()
          .eq("id", courseId)
          .select(); // 👈 add .select() to get back deleted rows

      setState(() => _isLoading = false);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No course found or delete failed.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Course deleted successfully!")),
        );
        Navigator.pop(context, true); // return to previous page
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text("Edit Course"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickThumbnail,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.dividerColor),
                    color: theme.colorScheme.surfaceVariant,
                  ),
                  child: _thumbnailImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            _thumbnailImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.course["Thumbnail"] != null &&
                            widget.course["Thumbnail"].toString().isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            widget.course["Thumbnail"],
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tap to pick thumbnail",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Course Title",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter course title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: "Host",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _validityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Validity (months)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateCourse,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _deleteCourse,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  "Delete Course",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
