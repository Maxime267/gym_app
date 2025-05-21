import 'dart:convert';
import 'package:flutter/services.dart';

class Exercise {
  final String name;
  final String muscleGroup;
  final String image;
  final String instruction;

  Exercise({
    required this.name,
    required this.muscleGroup,
    required this.image,
    required this.instruction,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      muscleGroup: json['target muscle group'],
      image: json['image'],
      instruction: json['instruction'],
    );
  }
}

Future<List<Exercise>> loadExerciseList() async {
  final data = await loadExerciseData();
  final Map<String, dynamic> rawGroups = data['exercise'];

  final List<Exercise> allExercises = [];

  rawGroups.forEach((muscleGroup, list) {
    for (var item in list) {
      allExercises.add(Exercise.fromJson(item));
    }
  });

  return allExercises;
}

Future<Map<String, dynamic>> loadExerciseData() async {
  final String jsonString = await rootBundle.loadString('assets/exercise.json');
  return json.decode(jsonString);
}
