import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddVideoPage extends StatefulWidget {
  final String courseId;

  const AddVideoPage({super.key, required this.courseId});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _indexController = TextEditingController();

  bool _isPaid = false; // default
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _videoUrlController.dispose();
    _thumbnailController.dispose();
    _indexController.dispose();
    super.dispose();
  }

  Future<void> _addVideo() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    // Get the current max index for this course
    final maxIndexResponse = await Supabase.instance.client
        .from('Videos')
        .select('index')
        .eq('course_id', widget.courseId)
        .order('index', ascending: false)
        .limit(1);

    int nextIndex = 1;
    if (maxIndexResponse.isNotEmpty) {
      nextIndex = (maxIndexResponse.first['index'] as int) + 1;
    }

    // Insert video
    await Supabase.instance.client.from('Videos').insert({
      'title': _titleController.text,
      'description': _descController.text,
      'video_url': _videoUrlController.text,
      'course_id': widget.courseId,
      'is_paid': _isPaid,
      'thumbnail': _thumbnailController.text,
      'index': nextIndex,
    });

    // Success
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Video Added Successfully!")),
      );
      Navigator.pop(context, true);
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Video"),
        backgroundColor: const Color(0xFF2C3137),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Video Title"),
                validator: (v) => v == null || v.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _videoUrlController,
                decoration: const InputDecoration(labelText: "Video URL"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter video URL" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(labelText: "Thumbnail URL"),
              ),
              const SizedBox(height: 16),

              

              SwitchListTile(
                title: const Text("Is Paid"),
                value: _isPaid,
                onChanged: (val) {
                  setState(() {
                    _isPaid = val;
                  });
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _addVideo,
                icon: const Icon(Icons.save),
                label: const Text("Save Video"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3137),
                  foregroundColor: Colors.white,
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
