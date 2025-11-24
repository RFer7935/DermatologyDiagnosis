class UserInput {
  final int erythema;
  final int scaling;
  final int itching;
  final int kneeAndElbow;
  final int scalp;
  final int familyHistory;
  final int age;

  UserInput({
    required this.erythema,
    required this.scaling,
    required this.itching,
    required this.kneeAndElbow,
    required this.scalp,
    required this.familyHistory,
    required this.age,
  });

  @override
  String toString() =>
      'UserInput(erythema: $erythema, scaling: $scaling, itching: $itching, '
      'kneeAndElbow: $kneeAndElbow, scalp: $scalp, familyHistory: $familyHistory, age: $age)';
}

