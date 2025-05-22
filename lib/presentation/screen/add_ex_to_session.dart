import 'package:flutter/material.dart';
import '../../logic/session_logic/session_storage.dart';
import '../../logic/session_logic/workout_program_class.dart';
import '../../logic/json_database/exercise_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../format/textformat.dart';

class AddExerciseToSession extends StatefulWidget {
  final int session_id;

  const AddExerciseToSession({super.key, required this.session_id});

  @override
  State<AddExerciseToSession> createState() => _AddExerciseToSessionState();
}

class _AddExerciseToSessionState extends State<AddExerciseToSession> {
  final _formKey = GlobalKey<FormState>();

  final setCtrl = TextEditingController();
  final repCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final restCtrl = TextEditingController();

  final TextEditingController _autocompleteController = TextEditingController();

  Exercise? selectedExercise;
  List<Exercise> _exerciseList = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _loadSettings('nb_set', setCtrl);
    _loadSettings('nb_rep', repCtrl);
    _loadSettings('rest_time', restCtrl);
  }

  Future<void> _loadExercises() async {
    final exercises = await loadExerciseList();
    setState(() {
      _exerciseList = exercises;
    });
  }
  void _loadSettings(String parameterName, TextEditingController textController) async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(parameterName) ?? "";
    textController.text = text;
  }

  Future<void> _submitExercise() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newExercise = workout_program(
        name: selectedExercise!.name,
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
    setCtrl.dispose();
    repCtrl.dispose();
    weightCtrl.dispose();
    restCtrl.dispose();
    _autocompleteController.dispose();
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
              Autocomplete<Exercise>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) return const Iterable<Exercise>.empty();
                    return _exerciseList.where((ex) =>
                    ex.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                displayStringForOption: (Exercise ex) => ex.name,
                onSelected: (Exercise ex) {
                  setState(() {
                    selectedExercise = ex;
                    _autocompleteController.text = ex.name;
                  });
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  _autocompleteController.value = controller.value;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(labelText: 'Exercise name'),
                    validator: (_) => selectedExercise == null ? 'Choose an exercise' : null,
                  );
                },
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
                decoration: const InputDecoration(labelText: 'Rest time (mm:ss enter 4 digits)'),
                keyboardType: TextInputType.number,
                inputFormatters: [TimeTextInputFormatter()],
                
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




