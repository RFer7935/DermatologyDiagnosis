import '../models/calculation_detail_row.dart';
import '../models/dermatology_case.dart';
import '../models/user_input.dart';
import '../services/cbr_service.dart';

class CalculationDetailService {
  /// Attribute labels in Indonesian
  static const Map<String, String> attributeLabels = {
    'erythema': 'Erythema (Kemerahan)',
    'scaling': 'Scaling (Pengelupasan)',
    'itching': 'Itching (Gatal)',
    'kneeAndElbow': 'Lutut dan Siku',
    'scalp': 'Kulit Kepala',
    'familyHistory': 'Riwayat Keluarga',
    'age': 'Usia',
  };

  /// Ordinal value labels
  static const List<String> ordinalLabels = ['Tidak', 'Ringan', 'Sedang', 'Parah'];

  /// Binary value labels
  static const List<String> binaryLabels = ['Tidak', 'Ya'];

  /// Generate detailed calculation breakdown
  static List<CalculationDetailRow> generateCalculationDetails(
    UserInput input,
    DermatologyCase caseData,
  ) {
    final List<CalculationDetailRow> details = [];

    // Erythema (Ordinal)
    details.add(_createOrdinalRow(
      'erythema',
      input.erythema,
      caseData.erythema,
      CbrService.weights['erythema']!,
      CbrService.ranges['erythema']!,
    ));

    // Scaling (Ordinal)
    details.add(_createOrdinalRow(
      'scaling',
      input.scaling,
      caseData.scaling,
      CbrService.weights['scaling']!,
      CbrService.ranges['scaling']!,
    ));

    // Itching (Ordinal)
    details.add(_createOrdinalRow(
      'itching',
      input.itching,
      caseData.itching,
      CbrService.weights['itching']!,
      CbrService.ranges['itching']!,
    ));

    // Knee and Elbow (Binary)
    details.add(_createBinaryRow(
      'kneeAndElbow',
      input.kneeAndElbow,
      caseData.kneeAndElbow,
      CbrService.weights['kneeAndElbow']!,
    ));

    // Scalp (Binary)
    details.add(_createBinaryRow(
      'scalp',
      input.scalp,
      caseData.scalp,
      CbrService.weights['scalp']!,
    ));

    // Family History (Binary)
    details.add(_createBinaryRow(
      'familyHistory',
      input.familyHistory,
      caseData.familyHistory,
      CbrService.weights['familyHistory']!,
    ));

    // Age (Linear)
    details.add(_createLinearRow(
      'age',
      input.age,
      caseData.age,
      CbrService.weights['age']!,
      CbrService.ranges['age']!,
    ));

    return details;
  }

  /// Create row for ordinal attributes
  static CalculationDetailRow _createOrdinalRow(
    String attributeKey,
    int inputValue,
    int caseValue,
    double weight,
    int range,
  ) {
    final distance = (inputValue - caseValue).abs() / range;
    final similarity = 1.0 - distance;
    final partialScore = similarity * weight;

    return CalculationDetailRow(
      attributeName: attributeLabels[attributeKey]!,
      inputDisplay: '${ordinalLabels[inputValue]} ($inputValue)',
      inputValue: inputValue,
      caseDisplay: '${ordinalLabels[caseValue]} ($caseValue)',
      caseValue: caseValue,
      range: range,
      distance: distance,
      similarity: similarity,
      weight: weight,
      partialScore: partialScore,
      weightLabel: weight > 1.0 ? '$weight (Penting)' : weight.toString(),
    );
  }

  /// Create row for binary attributes
  static CalculationDetailRow _createBinaryRow(
    String attributeKey,
    int inputValue,
    int caseValue,
    double weight,
  ) {
    final range = 1;
    final distance = (inputValue - caseValue).abs() / range;
    final similarity = 1.0 - distance;
    final partialScore = similarity * weight;

    return CalculationDetailRow(
      attributeName: attributeLabels[attributeKey]!,
      inputDisplay: '${binaryLabels[inputValue]} ($inputValue)',
      inputValue: inputValue,
      caseDisplay: '${binaryLabels[caseValue]} ($caseValue)',
      caseValue: caseValue,
      range: range,
      distance: distance,
      similarity: similarity,
      weight: weight,
      partialScore: partialScore,
      weightLabel: weight > 1.0 ? '$weight (Sangat Penting)' : weight.toString(),
    );
  }

  /// Create row for linear attributes (age)
  static CalculationDetailRow _createLinearRow(
    String attributeKey,
    int inputValue,
    int caseValue,
    double weight,
    int range,
  ) {
    final distance = (inputValue - caseValue).abs() / range;
    final similarity = 1.0 - distance;
    final partialScore = similarity * weight;

    return CalculationDetailRow(
      attributeName: attributeLabels[attributeKey]!,
      inputDisplay: '$inputValue tahun',
      inputValue: inputValue,
      caseDisplay: '$caseValue tahun',
      caseValue: caseValue,
      range: range,
      distance: distance,
      similarity: similarity,
      weight: weight,
      partialScore: partialScore,
      weightLabel: weight.toString(),
    );
  }

  /// Calculate total score and weight
  static Map<String, double> calculateTotals(List<CalculationDetailRow> details) {
    double totalScore = 0;
    double totalWeight = 0;

    for (final row in details) {
      totalScore += row.partialScore;
      totalWeight += row.weight;
    }

    final finalSimilarity = totalScore / totalWeight;

    return {
      'totalScore': totalScore,
      'totalWeight': totalWeight,
      'finalSimilarity': finalSimilarity,
      'percentage': finalSimilarity * 100,
    };
  }
}

