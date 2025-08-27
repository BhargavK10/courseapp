import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditCoursePage extends StatefulWidget {
  final Map<String, dynamic> course; // Pass the course object

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
  late TextEditingController _thumbnailController;

  bool _isLoading = false;
  final supabase = Supabase.instance.client;

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
    _thumbnailController = TextEditingController(
      text: widget.course["Thumbnail"] ?? "",
    );
  }

  Future<void> _updateCourse() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await supabase
          .from("courses")
          .update({
            'title': _titleController.text.trim(),
            'description': _descController.text.trim(),
            'price': int.tryParse(_priceController.text.trim()) ?? 0,
            'host': _hostController.text.trim(),
            'validity_months': int.tryParse(_validityController.text) ?? 0,
            'Thumbnail': _thumbnailController.text.trim(),
          })
          .eq("id", widget.course["id"].toString().trim())
          .select(); // ✅ This makes Supabase return the updated row(s)

      setState(() => _isLoading = false);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No rows updated. Check course ID!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Course updated successfully!")),
        );
        Navigator.pop(context, true); // send result back to refresh list
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Course"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
