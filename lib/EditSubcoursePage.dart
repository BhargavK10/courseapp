

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class EditSubcoursePage extends StatefulWidget {
  final Map<String, dynamic> subcourse;

  const EditSubcoursePage({super.key, required this.subcourse});

  @override
  State<EditSubcoursePage> createState() => _EditSubcoursePageState();
}

class _EditSubcoursePageState extends State<EditSubcoursePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController priceController;
  late TextEditingController hostController;
  late TextEditingController validityController;

  File? _thumbnailImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  // 🔑 Internet Archive Credentials
  final String accessKey = "wAXCfd5mHnqqL254";
  final String secretKey = "aPFJPWYfZrlHpnIA";

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.subcourse['title'] ?? '');
    descController = TextEditingController(text: widget.subcourse['description'] ?? '');
    priceController = TextEditingController(text: widget.subcourse['price']?.toString() ?? '');
    hostController = TextEditingController(text: widget.subcourse['host'] ?? '');
    validityController =
        TextEditingController(text: widget.subcourse['validity_months']?.toString() ?? '');
  }

  Future<void> _pickThumbnail() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _thumbnailImage = File(pickedFile.path));
    }
  }

  Future<String?> _uploadToInternetArchive(File file) async {
    try {
      final identifier = "subcourse_${DateTime.now().millisecondsSinceEpoch}";
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
        debugPrint("❌ IA Upload failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ IA Exception: $e");
      return null;
    }
  }

  Future<void> _updateSubcourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        String? uploadedUrl = widget.subcourse['Thumbnail'];

        if (_thumbnailImage != null) {
          uploadedUrl = await _uploadToInternetArchive(_thumbnailImage!);
          if (uploadedUrl == null) {
            throw Exception("Failed to upload thumbnail to Internet Archive");
          }
        }

        final subcourseId = widget.subcourse['id'];

        final response = await Supabase.instance.client
            .from("subcourses")
            .update({
              "title": titleController.text.trim(),
              "description": descController.text.trim(),
              "price": int.tryParse(priceController.text) ?? 0,
              "host": hostController.text.trim(),
              "validity_months": int.tryParse(validityController.text) ?? 0,
              "Thumbnail": uploadedUrl ?? "",
            })
            .eq("id", subcourseId)
            .select();

        if (mounted) {
          if (response == null || (response is List && response.isEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("⚠️ No rows updated. Wrong ID or blocked by RLS.")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Subcourse updated successfully!")),
            );
            Navigator.pop(context, true);
          }
        }
      } catch (e) {
        debugPrint("❌ Exception in update: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

 Future<void> _deleteSubcourse() async {
  final subcourseId = widget.subcourse['id'];

  if (subcourseId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Invalid subcourse ID")),
    );
    return;
  }

  try {
    debugPrint("🆔 Trying to delete subcourse with id: $subcourseId");

    final response = await Supabase.instance.client
        .from("subcourses")
        .delete()
        .eq("id", subcourseId)
        .select();

    if (response == null || (response is List && response.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Delete failed. Wrong ID or blocked by RLS."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🗑️ Subcourse deleted successfully!")),
      );
      Navigator.pop(context, true);
    }
  } catch (e) {
    debugPrint("❌ Exception in delete: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error: $e")),
    );
  }
}

Future<void> _confirmDelete() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm Delete"),
      content: const Text("Are you sure you want to delete this subcourse?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await _deleteSubcourse();
  }
}



  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
      validator: required ? (v) => v == null || v.isEmpty ? "Please enter $label" : null : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text("✏️ Edit Subcourse"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickThumbnail,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: _thumbnailImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(_thumbnailImage!, fit: BoxFit.cover),
                            )
                          : (widget.subcourse['Thumbnail'] != null &&
                                  widget.subcourse['Thumbnail'].toString().isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(widget.subcourse['Thumbnail'], fit: BoxFit.cover),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image,
                                          size: 50, color: theme.iconTheme.color?.withOpacity(0.6)),
                                      const SizedBox(height: 8),
                                      Text("Tap to change thumbnail", style: theme.textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(titleController, "Title", required: true),
                  const SizedBox(height: 14),
                  _buildTextField(descController, "Description", maxLines: 3),
                  const SizedBox(height: 14),
                  _buildTextField(priceController, "Price", type: TextInputType.number),
                  const SizedBox(height: 14),
                  _buildTextField(hostController, "Host"),
                  const SizedBox(height: 14),
                  _buildTextField(validityController, "Validity (months)", type: TextInputType.number),
                  const SizedBox(height: 20),

                  // ✅ Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateSubcourse,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Text("Update Subcourse",
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null :  _confirmDelete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text("Delete Subcourse",
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
