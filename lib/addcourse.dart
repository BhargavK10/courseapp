import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({Key? key}) : super(key: key);

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _validityController = TextEditingController();

  bool _isLoading = false;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  /// Upload image to Supabase storage and return public URL
  Future<String?> _uploadImage(File image) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}";

      final storageResponse = await Supabase.instance.client.storage
          .from('course_thumbnails')
          .upload(fileName, image);

      if (storageResponse.isEmpty) throw "Upload failed";

      // Get public URL
      final publicUrl = Supabase.instance.client.storage
          .from('course_thumbnails')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed: $e")),
      );
      return null;
    }
  }

  Future<void> _addCourse() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a course thumbnail")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image to Supabase storage
      final imageUrl = await _uploadImage(_pickedImage!);
      if (imageUrl == null) return;

      await Supabase.instance.client.from('courses').insert({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'price': int.tryParse(_priceController.text.trim()) ?? 0,
        'host': _hostController.text.trim(),
        'validity_months': int.tryParse(_validityController.text.trim()) ?? 0,
        'Thumbnail': imageUrl, // ✅ Save uploaded URL
        'purchase_count': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Course added successfully!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _pickedImage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? hint,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(
          type == TextInputType.number ? Icons.numbers : Icons.text_fields,
          color: Colors.grey.shade600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF2C3137), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Add New Course"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    _titleController,
                    "Course Title",
                    hint: "Enter the name of the course",
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    _descController,
                    "Description",
                    hint: "Brief course description",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    _priceController,
                    "Price",
                    hint: "Enter price in ₹",
                    type: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    _hostController,
                    "Host Name",
                    hint: "Instructor / Teacher name",
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    _validityController,
                    "Validity (Months)",
                    hint: "Enter duration in months",
                    type: TextInputType.number,
                  ),
                  

                  

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _addCourse,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                        _isLoading ? "Saving..." : "Add Course",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
