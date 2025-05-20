import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings extends StatefulWidget {
  Settings({super.key});
  final TextEditingController textController = TextEditingController();

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  /*
   @override
  void initState() {
    super.initState();
    _loadData();
  } 
  
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString('user_input') ?? "";
    print("Text in Prefs: $text");
    textController.text = text;
  }

  void _onSubmit() async {
    print("Text: ${textController.text}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_input', textController.text);
  }
  */
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