import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/dermatology_case.dart';
import '../models/diagnosis_result.dart';
import '../models/user_input.dart';

class CbrService {
  late List<DermatologyCase> _cases;
  bool _isInitialized = false;

  /// Weights for each attribute to prioritize distinctive symptoms
  static const Map<String, double> weights = {
    'erythema': 1.0,
    'scaling': 1.0,
    'itching': 1.5,
    'kneeAndElbow': 2.0,
    'scalp': 2.0,
    'familyHistory': 1.0,
    'age': 1.0,
  };

  /// Attribute ranges for normalization
  static const Map<String, int> ranges = {
    'erythema': 3, // 0-3
    'scaling': 3,
    'itching': 3,
    'kneeAndElbow': 1, // binary
    'scalp': 1,
    'familyHistory': 1,
    'age': 100,
  };

  /// Initialize the service by loading dataset from JSON
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final jsonString =
          await rootBundle.loadString('assets/dermatologi/dataset_cleaned.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _cases = jsonData
          .map((item) => DermatologyCase.fromJson(item as Map<String, dynamic>))
          .toList();
      _isInitialized = true;
      debugPrint('CBRService initialized with ${_cases.length} cases');
    } catch (e) {
      debugPrint('Error loading dataset: $e');
      rethrow;
    }
  }

  /// Calculate normalized distance between two values
  /// Distance = |Value1 - Value2| / Range
  /// Returns value between 0 (identical) and 1 (maximum difference)
  double _calculateNormalizedDistance(
    int inputValue,
    int caseValue,
    int range,
  ) {
    final difference = (inputValue - caseValue).abs();
    return difference / range;
  }

  /// Calculate similarity for a single attribute
  /// Similarity = 1 - Distance
  /// Returns value between 0 (completely different) and 1 (identical)
  double _calculateAttributeSimilarity(
    int inputValue,
    int caseValue,
    String attribute,
  ) {
    final range = ranges[attribute]!;
    final distance = _calculateNormalizedDistance(inputValue, caseValue, range);
    return 1 - distance;
  }

  /// Calculate weighted similarity score between user input and a case
  /// Formula: Sum(Weight_i * Similarity_i) / Sum(Weight_i)
  /// Returns value between 0 and 1
  double _calculateCaseSimilarity(UserInput input, DermatologyCase case_) {
    double totalWeightedSimilarity = 0;
    double totalWeight = 0;

    // Erythema
    final erythemaSim = _calculateAttributeSimilarity(
      input.erythema,
      case_.erythema,
      'erythema',
    );
    totalWeightedSimilarity += weights['erythema']! * erythemaSim;
    totalWeight += weights['erythema']!;

    // Scaling
    final scalingSim = _calculateAttributeSimilarity(
      input.scaling,
      case_.scaling,
      'scaling',
    );
    totalWeightedSimilarity += weights['scaling']! * scalingSim;
    totalWeight += weights['scaling']!;

    // Itching
    final itchingSim = _calculateAttributeSimilarity(
      input.itching,
      case_.itching,
      'itching',
    );
    totalWeightedSimilarity += weights['itching']! * itchingSim;
    totalWeight += weights['itching']!;

    // Knee and Elbow
    final kneeElbowSim = _calculateAttributeSimilarity(
      input.kneeAndElbow,
      case_.kneeAndElbow,
      'kneeAndElbow',
    );
    totalWeightedSimilarity += weights['kneeAndElbow']! * kneeElbowSim;
    totalWeight += weights['kneeAndElbow']!;

    // Scalp
    final scalpSim = _calculateAttributeSimilarity(
      input.scalp,
      case_.scalp,
      'scalp',
    );
    totalWeightedSimilarity += weights['scalp']! * scalpSim;
    totalWeight += weights['scalp']!;

    // Family History
    final familySim = _calculateAttributeSimilarity(
      input.familyHistory,
      case_.familyHistory,
      'familyHistory',
    );
    totalWeightedSimilarity += weights['familyHistory']! * familySim;
    totalWeight += weights['familyHistory']!;

    // Age (linear scale)
    final ageSim = _calculateAttributeSimilarity(
      input.age,
      case_.age,
      'age',
    );
    totalWeightedSimilarity += weights['age']! * ageSim;
    totalWeight += weights['age']!;

    // Calculate weighted average similarity
    return totalWeightedSimilarity / totalWeight;
  }

  /// Main method: Calculate diagnosis based on user input
  /// Performs K-NN algorithm to find most similar cases
  /// Returns top 3 results (K=3) sorted by similarity score (highest first)
  Future<List<DiagnosisResult>> calculateDiagnosis(UserInput input) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Calculate similarity score for each case
    final results = <DiagnosisResult>[];
    for (final case_ in _cases) {
      final normalizedSimilarity = _calculateCaseSimilarity(input, case_);
      results.add(
        DiagnosisResult(
          case_: case_,
          normalizedSimilarity: normalizedSimilarity,
          similarityScore: normalizedSimilarity,
        ),
      );
    }

    // Sort by similarity score in descending order (highest first)
    results.sort((a, b) => b.similarityScore.compareTo(a.similarityScore));

    // Return top 3 results
    return results.take(3).toList();
  }

  /// Get all loaded cases (useful for debugging/analysis)
  List<DermatologyCase> get cases => _cases;

  /// Get number of loaded cases
  int get caseCount => _cases.length;
}

