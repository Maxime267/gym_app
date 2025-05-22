import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_app/logic/notifier/themeNotifier.dart';
import 'package:provider/provider.dart';
import '../format/textformat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class SettingMap {
  final String settingName;
  final String parameterName;
  final TextEditingController controller;

  SettingMap({
    required this.settingName,
    required this.parameterName,
    required this.controller,
  });
}


class Settings extends StatefulWidget {
  Settings({super.key});
  final TextEditingController textController = TextEditingController();
  
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final List<SettingMap> settings = [
    SettingMap(
      settingName: 'Default Number of set',
      parameterName: 'nb_set',
      controller: TextEditingController(),
    ),
    SettingMap(
      settingName: 'Default Number of repetition',
      parameterName: 'nb_rep',
      controller: TextEditingController(),
    ),
    SettingMap(
      settingName: 'Default Rest time (mm:ss enter 4 digits)',
      parameterName: 'rest_time',
      controller: TextEditingController(),
    ),
  ];

  String selectedUnit = 'kg';


  @override
  
  void initState() {
    super.initState();

    for(int i =0 ; i<3; i++){
      _loadData(settings[i].parameterName,settings[i].controller);
    }
    _loadSelectedUnit();
  } 
  

  void _loadData(String parameterName, TextEditingController textController) async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(parameterName) ?? "";
    textController.text = text;
  }
  Future<String> _loadData_return(String parameterName) async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(parameterName) ?? "";
    return text;
  }
  Future<void> _loadSelectedUnit() async {
    final loadedUnit = await _loadData_return('weight_unit');
    setState(() {
      // fallback to 'kg' if loadedUnit is null or invalid
      selectedUnit = (loadedUnit == 'kg' || loadedUnit == 'lb') ? loadedUnit : 'kg';
    });
  }


  void _onSubmit(String parameterName, String text) async {
    print("Text: $text");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(parameterName, text);
  }

  final Uri url1 = Uri.parse("https://liftmanual.com/");
  final Uri url2 = Uri.parse("https://www.muscleandstrength.com/");

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
 
  
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                      _onSubmit("visual_mode", "light");
                      themeNotifier.setTheme("light");
                    },
                    tooltip: "Light mode",
                  ),
                  IconButton(
                    icon: Icon(Icons.dark_mode),
                    onPressed: () {
                      _onSubmit("visual_mode", "dark");
                      themeNotifier.setTheme("dark");
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
          
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child :
                Row(
                  children: [
                    Text("Default Unit"),
                    SizedBox(width: 50,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedUnit,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedUnit = newValue;
                              });
                              _onSubmit('weight_unit',selectedUnit);
                            }
                          },
                          items: ['kg', 'lb'].map((unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).iconTheme.color),
                          style: Theme.of(context).textTheme.bodyMedium,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              
              Column(
                children: [
                  ListView.builder(
                    //separatorBuilder: (context, index) => const Divider(color: Colors.black),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: settings.length,
                    itemBuilder: (context, index) {
                      final setting = settings[index];
                      final settingName = setting.settingName;
                      final parameterName = setting.parameterName;
                      final TextEditingController controler = setting.controller;
                  
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
                                controller: controler,
                                onSubmitted: (newpara){
                                  _onSubmit(parameterName,controler.text);
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  border: OutlineInputBorder(),
                                ),
                                inputFormatters: parameterName == 'rest_time' ? [TimeTextInputFormatter()] : [] ,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Credits",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Developers",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Giraux Maxime\nZambon Yanis",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Sources used for exercises",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                      children: [
                        TextSpan(
                          text: "https://liftmanual.com/",
                          style: TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url1),
                        ),
                        TextSpan(text: "\n\n"),
                        TextSpan(
                          text: "https://www.muscleandstrength.com/",
                          style: TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url2),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}