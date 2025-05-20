import 'package:flutter/material.dart';
import '../../logic/session_logic/session_storage.dart';
import '../../logic/session_logic/workout_program_class.dart';

class AddExerciseToSession extends StatefulWidget {
  final int session_id;

  const AddExerciseToSession({super.key, required this.session_id});

  @override
  State<AddExerciseToSession> createState() => _AddExerciseToSessionState();
}

class _AddExerciseToSessionState extends State<AddExerciseToSession> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final setCtrl = TextEditingController();
  final repCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final restCtrl = TextEditingController();

  Future<void> _submitExercise() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newExercise = workout_program(
        name: nameCtrl.text.trim(),
        set: int.parse(setCtrl.text),
        repetition: int.parse(repCtrl.text),
        weight: int.parse(weightCtrl.text),
        rest_time: restCtrl.text.trim(),
      );

      final key = 'session${widget.session_id}';
      final current = await SessionStorage.loadSession(key);
      current.add(newExercise);
      await SessionStorage.saveSession(key, current);

      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    setCtrl.dispose();
    repCtrl.dispose();
    weightCtrl.dispose();
    restCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Exercise name'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: setCtrl,
                decoration: const InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
                validator: (val) => int.tryParse(val ?? '') == null ? 'Enter number' : null,
              ),
              TextFormField(
                controller: repCtrl,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                validator: (val) => int.tryParse(val ?? '') == null ? 'Enter number' : null,
              ),
              TextFormField(
                controller: weightCtrl,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (val) => int.tryParse(val ?? '') == null ? 'Enter number' : null,
              ),
              TextFormField(
                controller: restCtrl,
                decoration: const InputDecoration(labelText: 'Rest time (e.g. 90s)'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitExercise,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

