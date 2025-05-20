import 'package:flutter/material.dart';
import '../../logic/json_database/exercise_loader.dart';


class ExerciseDetails extends StatefulWidget {
  final String? category;
  final String? exerciseName;

  const ExerciseDetails({
    super.key,
    this.category,
    this.exerciseName,
  });

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  List<Exercise>? _exercises;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final jsonData = await loadExerciseData();
    List<Exercise> exercises = [];

    if (widget.exerciseName != null) {
      jsonData['exercise'].forEach((key, value) {
        for (var item in value) {
          if (item['name'].toString().toLowerCase() == widget.exerciseName!.toLowerCase()) {
            exercises.add(Exercise.fromJson(item));
            break;
          }
        }
      });
    } else if (widget.category != null) {
      final data = jsonData['exercise'][widget.category];
      if (data != null) {
        exercises = List<Exercise>.from(data.map((e) => Exercise.fromJson(e)));
      }
    }
    setState(() {
      _exercises = exercises;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.exerciseName ?? widget.category ?? 'Exercises';
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_exercises == null || _exercises!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: Text('No exercise found')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: _exercises!.length,
        itemBuilder: (context, index) {
          final ex = _exercises![index];
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(ex.image, height: 200, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Text(
                  ex.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Target: ${ex.muscleGroup}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Text(ex.instruction),
              ],
            ),
          );
        }
      ),
    );
  }
}
