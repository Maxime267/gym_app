import 'package:flutter/material.dart';
import 'package:gym_app/presentation/screen/exercise_details.dart';
import 'package:gym_app/presentation/screen/add_ex_to_session.dart';
import '../../logic/session_logic/workout_program_class.dart';
import '../../logic/session_logic/session_storage.dart';
import '../../logic/bloc/drawer.dart';



class SessionEditing extends StatefulWidget {

  final int session_id;
  final String session_name;
  const SessionEditing({super.key,required this.session_id ,required this.session_name});

  @override
  State<SessionEditing> createState() => _SessionEditingState();
}

class _SessionEditingState extends State<SessionEditing> {
  List<workout_program> _workout_program = [];
  bool _isLoading = true;

  String get currentSessionName {
    return DrawerState.items[widget.session_id]?.name ?? widget.session_name;
  }

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final sessionKey = 'session${widget.session_id}';
    final programs = await SessionStorage.loadSession(sessionKey);
    setState(() {
      _workout_program = List.from(programs); ;
      _isLoading = false;
    });
  }

  Future<void> _saveAndExit() async {
    final sessionKey = 'session${widget.session_id}';
    await SessionStorage.saveSession(sessionKey, _workout_program);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _saveAndExit,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 30,),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    AddExerciseToSession(session_id: widget.session_id)
                ),
              );
              if (result == true) {
                _loadSession();
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Text(
              currentSessionName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          if (_workout_program.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No exercise in this session',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: _workout_program.length,
                itemBuilder: (context, index) {
                  final prog = _workout_program[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      tileColor: Colors.blueGrey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(prog.name),
                      subtitle: Text('${prog.set} series of ${prog.repetition} reps'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${prog.weight}kg'),
                              Text('${prog.rest_time}'),
                            ],
                          ),
                          const SizedBox(width: 12),
                          IconButton.outlined(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () async {
                              setState(() {
                                _workout_program.removeAt(index);
                              });

                              final sessionKey = 'session${widget.session_id}';
                              await SessionStorage.saveSession(sessionKey, _workout_program);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExerciseDetails(exerciseName: prog.name.toLowerCase()),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}



