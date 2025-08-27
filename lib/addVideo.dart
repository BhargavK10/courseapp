/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class AddVideoPage extends StatefulWidget {
  final String courseId;

  const AddVideoPage({super.key, required this.courseId});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  File? _videoFile;
  File? _thumbnailFile;
  bool _isPaid = false;
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  /// Pick video from gallery
  Future<void> _pickVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _videoFile = File(picked.path);
      });
    }
  }

  /// Pick image from gallery
  Future<void> _pickThumbnail() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _thumbnailFile = File(picked.path);
      });
    }
  }

  /// Upload file to Supabase storage and return public URL
  Future<String> _uploadFile(File file, String bucket) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}";

    await Supabase.instance.client.storage.from(bucket).upload(fileName, file);

    return Supabase.instance.client.storage.from(bucket).getPublicUrl(fileName);
  }

  Future<void> _addVideo() async {
    if (!_formKey.currentState!.validate()) return;
    if (_videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video")),
      );
      return;
    }

    try {
      setState(() => _isUploading = true);

      // Upload video
      final videoUrl = await _uploadFile(_videoFile!, "videos");

      // Upload thumbnail if selected
      String? thumbnailUrl;
      if (_thumbnailFile != null) {
        thumbnailUrl = await _uploadFile(_thumbnailFile!, "thumbnails");
      }

      // Get next index
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

      // Insert into table
      await Supabase.instance.client.from('Videos').insert({
        'title': _titleController.text,
        'description': _descController.text,
        'video_url': videoUrl,
        'course_id': widget.courseId,
        'is_paid': _isPaid,
        'thumbnail': thumbnailUrl,
        'index': nextIndex,
      });

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
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {String? hint, int maxLines = 1, bool required = true}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade700),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2C3137), width: 2),
        ),
      ),
      validator: required
          ? (v) => v == null || v.isEmpty ? "Please enter $label" : null
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Add Video"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    _titleController,
                    "Video Title",
                    Icons.title,
                    hint: "Enter video title",
                  ),
                  const SizedBox(height: 14),

                  _buildTextField(
                    _descController,
                    "Description",
                    Icons.description,
                    hint: "Enter short description",
                    maxLines: 2,
                    required: false,
                  ),
                  const SizedBox(height: 20),

                  // Pick video
                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: Text(
                        _videoFile == null ? "Pick Video" : path.basename(_videoFile!.path)),
                    trailing: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickVideo,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Pick thumbnail
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: Text(
                        _thumbnailFile == null ? "Pick Thumbnail" : path.basename(_thumbnailFile!.path)),
                    trailing: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickThumbnail,
                    ),
                  ),
                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text("Paid Video"),
                    value: _isPaid,
                    onChanged: (val) => setState(() => _isPaid = val),
                    activeColor: Colors.green,
                  ),
                  const SizedBox(height: 28),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isUploading ? null : _addVideo,
                      icon: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        _isUploading ? "Uploading..." : "Save Video",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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
}*/

/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class AddVideoPage extends StatefulWidget {
  final String courseId;

  const AddVideoPage({super.key, required this.courseId});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  File? _videoFile;
  File? _thumbnailFile;
  bool _isPaid = false;
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  // 🔑 Replace with your Cloudinary details
  final String cloudName = "dijogveap";
  final String uploadPreset = "flutter_unsigned";

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _videoFile = File(picked.path));
    }
  }

  Future<void> _pickThumbnail() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _thumbnailFile = File(picked.path));
    }
  }

  Future<String?> _uploadToCloudinary(File file, {bool isVideo = false}) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/${isVideo ? "video" : "image"}/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields["upload_preset"] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resData = await response.stream.bytesToString();
      final data = json.decode(resData);
      return data["secure_url"]; // ✅ Cloudinary URL
    } else {
      return null;
    }
  }

  Future<void> _addVideo() async {
    if (!_formKey.currentState!.validate() || _videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Upload video & thumbnail
      final videoUrl = await _uploadToCloudinary(_videoFile!, isVideo: true);
      final thumbUrl = _thumbnailFile != null
          ? await _uploadToCloudinary(_thumbnailFile!)
          : null;

      if (videoUrl == null) throw "Video upload failed";

      // Get next index
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

      // Save to Supabase
      await Supabase.instance.client.from('Videos').insert({
        'title': _titleController.text,
        'description': _descController.text,
        'video_url': videoUrl,
        'course_id': widget.courseId,
        'is_paid': _isPaid,
        'thumbnail': thumbUrl,
        'index': nextIndex,
      });

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
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("🎬 Add Video"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Video Title",
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter video title" : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),

                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: Text(_videoFile == null
                        ? "Pick a Video"
                        : "Video Selected"),
                    trailing: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickVideo,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ListTile(
                    leading: const Icon(Icons.image),
                    title: Text(_thumbnailFile == null
                        ? "Pick Thumbnail"
                        : "Thumbnail Selected"),
                    trailing: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickThumbnail,
                    ),
                  ),
                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text("Paid Video"),
                    subtitle: Text(
                      _isPaid
                          ? "Users must purchase to watch"
                          : "Free to watch",
                    ),
                    value: _isPaid,
                    onChanged: (val) => setState(() => _isPaid = val),
                    activeColor: Colors.green,
                  ),
                  const SizedBox(height: 28),

                  _isUploading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addVideo,
                            icon: const Icon(Icons.save),
                            label: const Text(
                              "Save Video",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
}*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class AddVideoPage extends StatefulWidget {
  final String subcourseId;  
  final String courseId;     

  const AddVideoPage({
    Key? key,
    required this.subcourseId,
    required this.courseId,
  }) : super(key: key);

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}


class _AddVideoPageState extends State<AddVideoPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  File? _videoFile;
  File? _thumbnailFile;
  bool _isPaid = false;
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  
  final String accessKey = "wAXCfd5mHnqqL254";
  final String secretKey = "aPFJPWYfZrlHpnIA";

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _videoFile = File(picked.path));
    }
  }

  Future<void> _pickThumbnail() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _thumbnailFile = File(picked.path));
    }
  }

  Future<String?> _uploadToInternetArchive(
    File file, {
    bool isVideo = false,
  }) async {
    try {
      final identifier = "flutter_${DateTime.now().millisecondsSinceEpoch}";
      final fileName = file.uri.pathSegments.last;

      final url = Uri.parse("https://s3.us.archive.org/$identifier/$fileName");

      final bytes = await file.readAsBytes();

      final response = await http.put(
        url,
        headers: {
          "authorization": "LOW $accessKey:$secretKey",
          "x-archive-auto-make-bucket": "1",
          "Content-Type": isVideo ? "video/mp4" : "image/jpeg",
        },
        body: bytes,
      );

      if (response.statusCode == 200) {
        return "https://archive.org/download/$identifier/$fileName";
      } else {
        debugPrint("IA Upload failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("IA Exception: $e");
      return null;
    }
  }

  Future<void> _addVideo() async {
    if (!_formKey.currentState!.validate() || _videoFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a video")));
      return;
    }

    setState(() => _isUploading = true);

    try {
      
      final videoUrl = await _uploadToInternetArchive(
        _videoFile!,
        isVideo: true,
      );
      final thumbUrl = _thumbnailFile != null
          ? await _uploadToInternetArchive(_thumbnailFile!)
          : null;

      if (videoUrl == null) throw "Video upload failed";

     
      final maxIndexResponse = await Supabase.instance.client
          .from('Videos')
          .select('index')
          .eq('subcourse_id', widget.subcourseId) 
          .order('index', ascending: false)
          .limit(1);

      int nextIndex = 1;
      if (maxIndexResponse.isNotEmpty) {
        nextIndex = (maxIndexResponse.first['index'] as int) + 1;
      }

      // Save video metadata in Supabase
      await Supabase.instance.client.from('Videos').insert({
        'title': _titleController.text,
        'description': _descController.text,
        'video_url': videoUrl,
        'subcourse_id': widget.subcourseId, 
        'is_paid': _isPaid,
        'thumbnail': thumbUrl,
        'index': nextIndex,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Video Added Successfully!")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("🎬 Add Video"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Video Title",
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter video title" : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),

                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: Text(
                      _videoFile == null ? "Pick a Video" : "Video Selected",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickVideo,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ListTile(
                    leading: const Icon(Icons.image),
                    title: Text(
                      _thumbnailFile == null
                          ? "Pick Thumbnail"
                          : "Thumbnail Selected",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickThumbnail,
                    ),
                  ),
                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text("Paid Video"),
                    subtitle: Text(
                      _isPaid
                          ? "Users must purchase to watch"
                          : "Free to watch",
                    ),
                    value: _isPaid,
                    onChanged: (val) => setState(() => _isPaid = val),
                    activeColor: Colors.green,
                  ),
                  const SizedBox(height: 28),

                  _isUploading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addVideo,
                            icon: const Icon(Icons.save),
                            label: const Text(
                              "Save Video",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
