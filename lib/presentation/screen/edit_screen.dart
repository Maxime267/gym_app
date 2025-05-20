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
  List<workout_program>? _workout_program;
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
      _workout_program = programs;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(currentSessionName)),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 20,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    AddExerciseToSession(session_id: widget.session_id)),
              );
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
          if (_workout_program == null || _workout_program!.isEmpty)
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
                itemCount: _workout_program!.length,
                itemBuilder: (context, index) {
                  final prog = _workout_program![index];
                  return ListTile(
                      tileColor: Colors.blueGrey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      title: Text(prog.name),
                      subtitle: Text('${prog.set} series of ${prog.repetition} reps'),
                      trailing: Text('${prog.weight}kg\n${prog.rest_time}'),
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                ExerciseDetails(exerciseName: prog.name.toLowerCase()))
                        );
                        if (result == true) {
                          _loadSession();
                        }
                      }
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}



