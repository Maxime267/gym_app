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

Future<Map<String, dynamic>> loadExerciseData() async {
  final String jsonString = await rootBundle.loadString('assets/exercise.json');
  return json.decode(jsonString);
}
