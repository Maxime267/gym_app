import 'package:flutter/material.dart';
import 'package:gym_app/presentation/screen/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Gym App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    ),
  );
}
