import 'dermatology_case.dart';

class DiagnosisResult {
  final DermatologyCase case_;
  final double similarityScore; // 0 to 100
  final double normalizedSimilarity; // 0 to 1

  DiagnosisResult({
    required this.case_,
    required this.similarityScore,
    required this.normalizedSimilarity,
  });

  String get scorePercentage => '${(similarityScore * 100).toStringAsFixed(2)}%';

  @override
  String toString() =>
      'DiagnosisResult(diagnosis: ${case_.diagnosis}, similarity: $scorePercentage)';
}

