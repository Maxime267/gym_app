class workout_program {
  final String name;
  final int set;
  final int repetition;
  final String weight;
  final String rest_time;

  workout_program({
    required this.name,
    required this.set,
    required this.repetition,
    required this.weight,
    required this.rest_time,
  });

  factory workout_program.fromJson(Map<String, dynamic> json) {
    return workout_program(
      name: json['name'],
      set: json['set'],
      repetition: json['repetition'],
      weight: json['weight'],
      rest_time: json['rest_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'set': set,
      'repetition': repetition,
      'weight': weight,
      'rest_time': rest_time,
    };
  }
}