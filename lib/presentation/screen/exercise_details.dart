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
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _loadExercises();
  }

  Future<List<Exercise>> _loadExercises() async {
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

    return exercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName ?? widget.category ?? 'Exercises'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun exercice trouvé.'));
          }

          final exercises = snapshot.data!;

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(ex.image, height: 200, fit: BoxFit.cover),
                      const SizedBox(height: 10),
                      Text(ex.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Target: ${ex.muscleGroup}', style: const TextStyle(fontStyle: FontStyle.italic)),
                      const SizedBox(height: 10),
                      Text(ex.instruction),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
