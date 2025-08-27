import 'package:courseapp/profile.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget topBar(BuildContext context, String text){
  return AppBar(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    centerTitle: true,
    title: Text(text),
  );
}