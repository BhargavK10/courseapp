// import 'package:courseapp/profile.dart';
// import 'package:flutter/material.dart';

// PreferredSizeWidget topBar(BuildContext context, String text){
//   return AppBar(
//     backgroundColor: Colors.blue,
//     foregroundColor: Colors.white,
//     centerTitle: true,
//     title: Text(text),
//   );
// }

//import 'package:courseapp/profile.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget topBar(BuildContext context, String text) {
  final theme = Theme.of(context);

  return AppBar(
    backgroundColor: theme.colorScheme.primary,   // ✅ theme-based color
    foregroundColor: theme.colorScheme.onPrimary, // ✅ auto-contrasting text/icons
    centerTitle: true,
    title: Text(text),
  );
}
