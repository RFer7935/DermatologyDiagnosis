class CalculationDetailRow {
  final String attributeName;
  final String inputDisplay;
  final int inputValue;
  final String caseDisplay;
  final int caseValue;
  final int range;
  final double distance;
  final double similarity;
  final double weight;
  final double partialScore;
  final String weightLabel;

  CalculationDetailRow({
    required this.attributeName,
    required this.inputDisplay,
    required this.inputValue,
    required this.caseDisplay,
    required this.caseValue,
    required this.range,
    required this.distance,
    required this.similarity,
    required this.weight,
    required this.partialScore,
    required this.weightLabel,
  });

  String get differenceDisplay => (inputValue - caseValue).abs().toString();

  String get calculationFormula {
    final diff = (inputValue - caseValue).abs();
    return '$weight × (1 - $diff/$range) = ${partialScore.toStringAsFixed(2)}';
  }

  String get similarityPercentage => '${(similarity * 100).toStringAsFixed(1)}%';
}

