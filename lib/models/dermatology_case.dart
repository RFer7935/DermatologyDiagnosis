class DermatologyCase {
  final int id;
  final int erythema;
  final int scaling;
  final int itching;
  final int kneeAndElbow;
  final int scalp;
  final int familyHistory;
  final int age;
  final String diagnosis;

  DermatologyCase({
    required this.id,
    required this.erythema,
    required this.scaling,
    required this.itching,
    required this.kneeAndElbow,
    required this.scalp,
    required this.familyHistory,
    required this.age,
    required this.diagnosis,
  });

  /// Maps text values to numeric scale
  static const Map<String, int> ordinalMap = {
    'Tidak': 0,
    'Ringan': 1,
    'Sedang': 2,
    'Parah': 3,
  };

  static const Map<String, int> binaryMap = {
    'Tidak': 0,
    'Ya': 1,
  };

  /// Factory constructor to parse JSON and convert string values to integers
  factory DermatologyCase.fromJson(Map<String, dynamic> json) {
    return DermatologyCase(
      id: json['id'] as int,
      erythema: ordinalMap[json['erythema'] as String] ?? 0,
      scaling: ordinalMap[json['scaling'] as String] ?? 0,
      itching: ordinalMap[json['itching'] as String] ?? 0,
      kneeAndElbow: binaryMap[json['knee_and_elbow'] as String] ?? 0,
      scalp: binaryMap[json['scalp'] as String] ?? 0,
      familyHistory: binaryMap[json['family_history'] as String] ?? 0,
      age: json['age'] as int,
      diagnosis: json['diagnosis'] as String,
    );
  }

  @override
  String toString() =>
      'DermatologyCase(id: $id, diagnosis: $diagnosis, age: $age)';
}

