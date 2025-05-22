import 'package:flutter/material.dart';
import 'package:gym_app/presentation/screen/exercise_details.dart';
import 'package:gym_app/presentation/screen/edit_screen.dart';
import '../../logic/session_logic/workout_program_class.dart';
import '../../logic/session_logic/session_storage.dart';
import '../../logic/bloc/drawer.dart';

class SessionDetails extends StatefulWidget {

  final int session_id;
  final String session_name;
  const SessionDetails({super.key,required this.session_id ,required this.session_name});

  @override
  State<SessionDetails> createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {
  List<workout_program>? _workout_program;
  bool _isLoading = true;

  String get currentSessionName {
    return DrawerState.items[widget.session_id]?.name ?? widget.session_name;
  }

  @override
  void didUpdateWidget(covariant SessionDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.session_id != widget.session_id) {
      _isLoading = true;
      _workout_program = null;
      _loadSession();
    }
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
        appBar: AppBar(title: Text('')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionEditing(
                    session_id: widget.session_id,
                    session_name: widget.session_name,
                  ),
                ),
              );
              if (result == true) {
                _loadSession();
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.edit),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Edit Session',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Icon(Icons.edit),
                ],
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
                  trailing: Text('${prog.weight}\n${prog.rest_time}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                        ExerciseDetails(exerciseName: prog.name.toLowerCase()))
                    );
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



