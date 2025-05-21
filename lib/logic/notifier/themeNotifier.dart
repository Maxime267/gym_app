import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString("visual_mode") ?? "";
    if(text == "dark"){
      _themeMode = ThemeMode.dark;
    }
    else{
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  void setTheme(String mode) async {
  if (mode == "dark") {
    _themeMode = ThemeMode.dark;
  } else {
    _themeMode = ThemeMode.light;
  }
  notifyListeners();
}

}
