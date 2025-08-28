// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AddCoursePage extends StatefulWidget {
//   const AddCoursePage({Key? key}) : super(key: key);

//   @override
//   State<AddCoursePage> createState() => _AddCoursePageState();
// }

// class _AddCoursePageState extends State<AddCoursePage> {
//   final _formKey = GlobalKey<FormState>();

//   final titleController = TextEditingController();
//   final descController = TextEditingController();
//   final priceController = TextEditingController();
//   final hostController = TextEditingController();
//   final validityController = TextEditingController();

//   File? _thumbnailImage;
//   final ImagePicker _picker = ImagePicker();

//   bool _isLoading = false;

//   // 🔑 Internet Archive credentials
//   final String accessKey = "wAXCfd5mHnqqL254";
//   final String secretKey = "aPFJPWYfZrlHpnIA";

//   Future<void> _pickThumbnail() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _thumbnailImage = File(pickedFile.path));
//     }
//   }

//   /// Upload image to Internet Archive
//   Future<String?> _uploadToInternetArchive(File file) async {
//     try {
//       final identifier = "course_${DateTime.now().millisecondsSinceEpoch}";
//       final fileName = file.uri.pathSegments.last;

//       final url = Uri.parse("https://s3.us.archive.org/$identifier/$fileName");
//       final bytes = await file.readAsBytes();

//       final response = await http.put(
//         url,
//         headers: {
//           "authorization": "LOW $accessKey:$secretKey",
//           "x-archive-auto-make-bucket": "1",
//           "Content-Type": "image/jpeg",
//         },
//         body: bytes,
//       );

//       if (response.statusCode == 200) {
//         return "https://archive.org/download/$identifier/$fileName";
//       } else {
//         debugPrint("❌ IA Upload failed: ${response.statusCode} ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       debugPrint("❌ IA Exception: $e");
//       return null;
//     }
//   }

//   Future<void> _saveCourse() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         String? uploadedUrl;

//         if (_thumbnailImage != null) {
//           uploadedUrl = await _uploadToInternetArchive(_thumbnailImage!);
//           if (uploadedUrl == null) {
//             throw Exception("Failed to upload thumbnail to Internet Archive");
//           }
//         }

//         await Supabase.instance.client.from("courses").insert({
//           "title": titleController.text.trim(),
//           "description": descController.text.trim(),
//           "price": int.tryParse(priceController.text) ?? 0,
//           "host": hostController.text.trim(),
//           "validity_months": int.tryParse(validityController.text) ?? 0,
//           "Thumbnail": uploadedUrl ?? "",
//           "purchase_count": 0,
//         });

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("✅ Course saved successfully!")),
//           );
//           Navigator.pop(context, true);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("❌ Error: $e")),
//           );
//         }
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     }
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     TextInputType type = TextInputType.text,
//     int maxLines = 1,
//     bool required = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: type,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Colors.blue, width: 2),
//         ),
//       ),
//       validator: required
//           ? (v) => v == null || v.isEmpty ? "Please enter $label" : null
//           : null,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("➕ Add Course"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(18),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//           elevation: 4,
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Thumbnail picker
//                   GestureDetector(
//                     onTap: _pickThumbnail,
//                     child: Container(
//                       height: 150,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(color: Colors.grey.shade400),
//                         color: Colors.grey.shade200,
//                       ),
//                       child: _thumbnailImage != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(14),
//                               child: Image.file(_thumbnailImage!,
//                                   fit: BoxFit.cover),
//                             )
//                           : const Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.image,
//                                       size: 50, color: Colors.grey),
//                                   SizedBox(height: 8),
//                                   Text("Tap to pick thumbnail"),
//                                 ],
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   _buildTextField(titleController, "Title", required: true),
//                   const SizedBox(height: 14),
//                   _buildTextField(descController, "Description", maxLines: 3),
//                   const SizedBox(height: 14),
//                   _buildTextField(priceController, "Price",
//                       type: TextInputType.number),
//                   const SizedBox(height: 14),
//                   _buildTextField(hostController, "Host"),
//                   const SizedBox(height: 14),
//                   _buildTextField(validityController, "Validity (months)",
//                       type: TextInputType.number),
//                   const SizedBox(height: 20),

//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _saveCourse,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               height: 22,
//                               width: 22,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.save),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   "Save Course",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({Key? key}) : super(key: key);

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final hostController = TextEditingController();
  final validityController = TextEditingController();

  File? _thumbnailImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;


  final String accessKey = "wAXCfd5mHnqqL254";
  final String secretKey = "aPFJPWYfZrlHpnIA";

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
        debugPrint("❌ IA Upload failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ IA Exception: $e");
      return null;
    }
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        String? uploadedUrl;

        if (_thumbnailImage != null) {
          uploadedUrl = await _uploadToInternetArchive(_thumbnailImage!);
          if (uploadedUrl == null) {
            throw Exception("Failed to upload thumbnail to Internet Archive");
          }
        }

        await Supabase.instance.client.from("courses").insert({
          "title": titleController.text.trim(),
          "description": descController.text.trim(),
          "price": int.tryParse(priceController.text) ?? 0,
          "host": hostController.text.trim(),
          "validity_months": int.tryParse(validityController.text) ?? 0,
          "Thumbnail": uploadedUrl ?? "",
          "purchase_count": 0,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("✅ Course saved successfully!"),
              backgroundColor: Theme.of(context).colorScheme.inverseSurface,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("❌ Error: $e"),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      validator: required
          ? (v) => v == null || v.isEmpty ? "Please enter $label" : null
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text("➕ Add Course"),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
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
                
                  GestureDetector(
                    onTap: _pickThumbnail,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.outline),
                        color: colors.surfaceVariant,
                      ),
                      child: _thumbnailImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                _thumbnailImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image,
                                    size: 50, color: colors.onSurfaceVariant),
                                const SizedBox(height: 8),
                                Text("Tap to pick thumbnail",
                                    style: TextStyle(
                                        color: colors.onSurfaceVariant)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(titleController, "Title", required: true),
                  const SizedBox(height: 14),
                  _buildTextField(descController, "Description", maxLines: 3),
                  const SizedBox(height: 14),
                  _buildTextField(priceController, "Price",
                      type: TextInputType.number),
                  const SizedBox(height: 14),
                  _buildTextField(hostController, "Host"),
                  const SizedBox(height: 14),
                  _buildTextField(validityController, "Validity (months)",
                      type: TextInputType.number),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: colors.onPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, color: colors.onPrimary),
                                const SizedBox(width: 8),
                                Text(
                                  "Save Course",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.onPrimary,
                                  ),
                                ),
                              ],
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
