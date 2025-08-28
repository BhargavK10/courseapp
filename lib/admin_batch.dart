
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AdminBatchPage extends StatefulWidget {
//   const AdminBatchPage({super.key});

//   @override
//   State<AdminBatchPage> createState() => _AdminBatchPageState();
// }

// class _AdminBatchPageState extends State<AdminBatchPage> {
//   final supabase = Supabase.instance.client;

//   List<Map<String, dynamic>> batches = [];
//   List<Map<String, dynamic>> users = [];
//   Set<String> selectedUsers = {}; // store selected user IDs
//   String? selectedBatch; // store batch name (S1, S2 etc.)

//   @override
//   void initState() {
//     super.initState();
//     _fetchBatches();
//     _fetchUsers();
//   }

//   Future<void> _fetchBatches() async {
//     try {
//       final res = await supabase.from('batches').select();
//       setState(() {
//         batches = List<Map<String, dynamic>>.from(res);
//       });
//     } catch (e) {
//       _showSnack("❌ Failed to fetch batches: $e");
//     }
//   }

//   Future<void> _fetchUsers() async {
//     try {
//       final res = await supabase.from('profiles').select('user_id, name, batch');
//       setState(() {
//         users = List<Map<String, dynamic>>.from(res);
//       });
//     } catch (e) {
//       _showSnack("❌ Failed to fetch users: $e");
//     }
//   }

//   Future<void> _addBatch(String batchName) async {
//     if (batchName.trim().isEmpty) {
//       _showSnack("⚠️ Batch name cannot be empty");
//       return;
//     }
//     try {
//       final res = await supabase.from('batches').insert({'batch': batchName}).select();
//       if (res.isNotEmpty) {
//         setState(() {
//           batches.add(Map<String, dynamic>.from(res.first));
//         });
//         _showSnack("✅ Batch '$batchName' added successfully");
//       }
//     } catch (e) {
//       _showSnack("❌ Failed to add batch: $e");
//     }
//   }

//   Future<void> _assignBatchToSelectedUsers() async {
//     if (selectedBatch == null || selectedUsers.isEmpty) {
//       _showSnack("⚠️ Please select a batch and at least one user");
//       return;
//     }

//     try {
//       for (var userId in selectedUsers) {
//         final updated = await supabase
//             .from('profiles')
//             .update({'batch': selectedBatch})
//             .eq('user_id', userId)
//             .select();
//         print(updated);
//       }

//       _showSnack("✅ Batch assigned to selected users");

//       setState(() {
//         selectedUsers.clear();
//       });

//       _fetchUsers();
//     } catch (e) {
//       _showSnack("❌ Failed to assign batch: $e");
//     }
//   }

//   void _showAddBatchDialog() {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         final theme = Theme.of(ctx);
//         return AlertDialog(
//           backgroundColor: theme.colorScheme.surface,
//           title: Text("Add Batch", style: TextStyle(color: theme.colorScheme.onSurface)),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: "Enter batch name",
//               filled: true,
//               fillColor: theme.colorScheme.surfaceVariant,
//               enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: theme.colorScheme.onSurfaceVariant)),
//               focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: theme.colorScheme.primary)),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: Text("Cancel", style: TextStyle(color: theme.colorScheme.primary)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _addBatch(controller.text.trim());
//                 Navigator.pop(ctx);
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: theme.colorScheme.primary),
//               child: Text("Add",style: TextStyle(color:theme.colorScheme.onPrimary ),),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Admin - Manage Batches", style: TextStyle(color: colorScheme.onPrimary)),
//         backgroundColor: colorScheme.primary,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton.icon(
//               onPressed: _showAddBatchDialog,
//               icon: Icon(Icons.add, color: colorScheme.onPrimary),
//               label: Text("Add Batch",style: TextStyle(color:colorScheme.onPrimary ),),
//               style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedBatch,
//               hint: Text("Select batch to assign", style: TextStyle(color: colorScheme.onSurface)),
//               items: batches
//                   .map((b) => DropdownMenuItem<String>(
//                         value: b['batch'],
//                         child: Text(b['batch'], style: TextStyle(color: colorScheme.onSurface)),
//                       ))
//                   .toList(),
//               onChanged: (val) {
//                 setState(() {
//                   selectedBatch = val;
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton.icon(
//               onPressed: _assignBatchToSelectedUsers,
//               icon: Icon(Icons.check, color: colorScheme.onPrimary),
//               label: Text("Assign to Selected Users",style: TextStyle(color:colorScheme.onPrimary ),),
//               style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
//             ),
//           ),
//           const Divider(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (ctx, i) {
//                 final user = users[i];
//                 final isSelected = selectedUsers.contains(user['user_id']);
//                 return CheckboxListTile(
//                   title: Text(user['name'] ?? 'Unknown', style: TextStyle(color: colorScheme.onSurface)),
//                   subtitle: Text(
//                     "Batch: ${user['batch'] ?? 'Not assigned'}",
//                     style: TextStyle(color: colorScheme.onSurfaceVariant),
//                   ),
//                   value: isSelected,
//                   onChanged: (val) {
//                     setState(() {
//                       if (val == true) {
//                         selectedUsers.add(user['user_id']);
//                       } else {
//                         selectedUsers.remove(user['user_id']);
//                       }
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminBatchPage extends StatefulWidget {
  const AdminBatchPage({super.key});

  @override
  State<AdminBatchPage> createState() => _AdminBatchPageState();
}

class _AdminBatchPageState extends State<AdminBatchPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> batches = [];
  List<Map<String, dynamic>> users = [];
  Set<String> selectedUsers = {}; // store selected user IDs
  String? selectedBatch; // store batch name (S1, S2 etc.)

  @override
  void initState() {
    super.initState();
    _fetchBatches();
    _fetchUsers();
  }

  Future<void> _fetchBatches() async {
    try {
      final res = await supabase.from('batches').select();
      setState(() {
        batches = List<Map<String, dynamic>>.from(res);
      });
    } catch (e) {
      _showSnack("❌ Failed to fetch batches: $e");
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final res =
          await supabase.from('profiles').select('user_id, name, batch');
      setState(() {
        users = List<Map<String, dynamic>>.from(res);
      });
    } catch (e) {
      _showSnack("❌ Failed to fetch users: $e");
    }
  }

  Future<void> _addBatch(String batchName) async {
    if (batchName.trim().isEmpty) {
      _showSnack("⚠️ Batch name cannot be empty");
      return;
    }
    try {
      final res =
          await supabase.from('batches').insert({'batch': batchName}).select();
      if (res.isNotEmpty) {
        setState(() {
          batches.add(Map<String, dynamic>.from(res.first));
        });
        _showSnack("✅ Batch '$batchName' added successfully");
      }
    } catch (e) {
      _showSnack("❌ Failed to add batch: $e");
    }
  }

  Future<void> _assignBatchToSelectedUsers() async {
    if (selectedBatch == null || selectedUsers.isEmpty) {
      _showSnack("⚠️ Please select a batch and at least one user");
      return;
    }

    try {
      for (var userId in selectedUsers) {
        final updated = await supabase
            .from('profiles')
            .update({'batch': selectedBatch})
            .eq('user_id', userId)
            .select();
        print(updated);
      }

      _showSnack("✅ Batch assigned to selected users");

      setState(() {
        selectedUsers.clear();
      });

      _fetchUsers();
    } catch (e) {
      _showSnack("❌ Failed to assign batch: $e");
    }
  }

  void _showAddBatchDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final colors = theme.colorScheme;
        return AlertDialog(
          backgroundColor: colors.surface,
          title: Text("Add Batch", style: TextStyle(color: colors.onSurface)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter batch name",
              filled: true,
              fillColor: colors.surfaceVariant,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.outline)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.primary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel", style: TextStyle(color: colors.primary)),
            ),
            ElevatedButton(
              onPressed: () {
                _addBatch(controller.text.trim());
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary),
              child: Text("Add", style: TextStyle(color: colors.onPrimary)),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String msg) {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: colors.onInverseSurface),
        ),
        backgroundColor: colors.inverseSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin - Manage Batches",
          style: TextStyle(color: colors.onPrimary),
        ),
        backgroundColor: colors.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddBatchDialog,
              icon: Icon(Icons.add, color: colors.onPrimary),
              label: Text("Add Batch", style: TextStyle(color: colors.onPrimary)),
              style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedBatch,
              hint: Text("Select batch to assign",
                  style: TextStyle(color: colors.onSurface)),
              items: batches
                  .map((b) => DropdownMenuItem<String>(
                        value: b['batch'],
                        child: Text(b['batch'],
                            style: TextStyle(color: colors.onSurface)),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedBatch = val;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _assignBatchToSelectedUsers,
              icon: Icon(Icons.check, color: colors.onPrimary),
              label: Text("Assign to Selected Users",
                  style: TextStyle(color: colors.onPrimary)),
              style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
            ),
          ),
          Divider(color: colors.outline),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, i) {
                final user = users[i];
                final isSelected = selectedUsers.contains(user['user_id']);
                return CheckboxListTile(
                  title: Text(user['name'] ?? 'Unknown',
                      style: TextStyle(color: colors.onSurface)),
                  subtitle: Text(
                    "Batch: ${user['batch'] ?? 'Not assigned'}",
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                  value: isSelected,
                  activeColor: colors.primary,
                  checkColor: colors.onPrimary,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedUsers.add(user['user_id']);
                      } else {
                        selectedUsers.remove(user['user_id']);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
