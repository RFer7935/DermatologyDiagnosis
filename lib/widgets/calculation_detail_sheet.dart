import 'package:flutter/material.dart';
import '../models/calculation_detail_row.dart';
import '../models/dermatology_case.dart';
import '../models/user_input.dart';
import '../services/calculation_detail_service.dart';

class CalculationDetailSheet extends StatelessWidget {
  final UserInput input;
  final DermatologyCase caseData;
  final double similarityScore;

  const CalculationDetailSheet({
    super.key,
    required this.input,
    required this.caseData,
    required this.similarityScore,
  });

  @override
  Widget build(BuildContext context) {
    final details = CalculationDetailService.generateCalculationDetails(input, caseData);
    final totals = CalculationDetailService.calculateTotals(details);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context),
                  const SizedBox(height: 20),

                  // Formula Banner
                  _buildFormulaBanner(),
                  const SizedBox(height: 24),

                  // Explanation
                  _buildExplanation(),
                  const SizedBox(height: 20),

                  // Calculation Table
                  _buildCalculationTable(details),
                  const SizedBox(height: 24),

                  // Summary
                  _buildSummary(totals),
                  const SizedBox(height: 20),

                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calculate, color: Colors.blue[700], size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Detail Logika Diagnosa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Perbandingan Input vs Kasus ID #${caseData.id}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Diagnosis: ${caseData.diagnosis}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.functions, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                'Formula Perhitungan:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Similarity = Σ(Bobot × (1 - |Input - Kasus| / Range)) / ΣBobot',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 13,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanation() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sistem membandingkan gejala Anda dengan basis pengetahuan pakar. '
              'Bobot lebih tinggi diberikan pada lokasi lesi (Lutut/Siku/Kepala) '
              'karena merupakan ciri spesifik penyakit tertentu.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[900],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationTable(List<CalculationDetailRow> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perhitungan Per Gejala:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Gejala',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Input',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Kasus',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Skor',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Table Rows
              ...details.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                return _buildTableRow(row, index);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(CalculationDetailRow row, int index) {
    final isEven = index % 2 == 0;
    final isMatch = row.inputValue == row.caseValue;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: isEven ? Colors.white : Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main row
          Row(
            children: [
              // Attribute name
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.attributeName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (row.weight > 1.0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          row.weightLabel,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.orange[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Input value
              Expanded(
                flex: 2,
                child: Text(
                  row.inputDisplay,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              // Case value
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      row.caseDisplay,
                      style: const TextStyle(fontSize: 11),
                    ),
                    if (isMatch) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green[600],
                      ),
                    ],
                  ],
                ),
              ),
              // Partial score
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      row.partialScore.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isMatch ? Colors.green[700] : Colors.grey[800],
                      ),
                    ),
                    Text(
                      '(${row.similarityPercentage})',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Formula
          const SizedBox(height: 6),
          Text(
            row.calculationFormula,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(Map<String, double> totals) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[900]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Hasil Akhir:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Total partial scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Skor Parsial:',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              Text(
                totals['totalScore']!.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Total weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Bobot:',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              Text(
                totals['totalWeight']!.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white38, height: 24),
          // Final calculation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Skor Kemiripan:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${totals['percentage']!.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '= ${totals['totalScore']!.toStringAsFixed(2)} ÷ ${totals['totalWeight']!.toStringAsFixed(1)} × 100%',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white60,
              fontFamily: 'Courier',
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

/// Show calculation detail modal bottom sheet
void showCalculationDetail(
  BuildContext context,
  UserInput input,
  DermatologyCase caseData,
  double similarityScore,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => CalculationDetailSheet(
        input: input,
        caseData: caseData,
        similarityScore: similarityScore,
      ),
    ),
  );
}

