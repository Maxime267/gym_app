import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings extends StatefulWidget {
  Settings({super.key});
  final TextEditingController textController = TextEditingController();

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController textController = TextEditingController();

  final List<Map<String, String>> settings = [
  {
    'settingName': 'Default Number of set',
    'parameterName': '',
  },
  {
    'settingName': 'Default Number of repetition',
    'parameterName': '',
  },
  {
    'settingName': 'Default Rest time (seconds)',
    'parameterName': '',
  },
  ];

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

  void _onClear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_input');
    textController.clear();
  } 

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "General Settings",
            style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          )),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.light_mode),
                onPressed: () {
                  
                },
                tooltip: "Light mode",
              ),
              IconButton(
                icon: Icon(Icons.dark_mode),
                onPressed: () {
                  
                },
                tooltip: "Dark mode",
              ),
            ],
          ),

          
          Text("Session Settings", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),),
          SizedBox(height: 30,),

          /*
          TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                  hintText: 'Default number of set',
                )
          ),
          */
          
          Expanded(
            child: ListView.builder(
              //separatorBuilder: (context, index) => const Divider(color: Colors.black),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: settings.length,
              itemBuilder: (context, index) {
                final setting = settings[index];
                final settingName = setting['settingName']!;
                final parameterName = setting['parameterName']!;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(settingName),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }
}