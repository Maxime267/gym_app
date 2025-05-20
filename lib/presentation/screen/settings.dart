import 'package:flutter/material.dart';


class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("General Settings"),
          TextField(),
          Text("Session Settings"),
          TextField()
        ],
      ),
    );
  }
}