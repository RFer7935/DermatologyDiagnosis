import 'package:flutter/material.dart';
import '../models/user_input.dart';
import '../models/diagnosis_result.dart';
import '../services/cbr_service.dart';
import '../widgets/calculation_detail_sheet.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final CbrService _cbrService = CbrService();
  bool _isLoading = true;
  String? _error;
  List<DiagnosisResult> _results = [];
  bool _hasSearched = false;

  // Input states
  int _erythema = 0;
  int _scaling = 0;
  int _itching = 0;
  int _kneeAndElbow = 0;
  int _scalp = 0;
  int _familyHistory = 0;
  int _age = 30;

  @override
  void initState() {
    super.initState();
    _initializeCbr();
  }

  Future<void> _initializeCbr() async {
    try {
      await _cbrService.initialize();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to initialize: $e';
      });
    }
  }

  Future<void> _performDiagnosis() async {
    final input = UserInput(
      erythema: _erythema,
      scaling: _scaling,
      itching: _itching,
      kneeAndElbow: _kneeAndElbow,
      scalp: _scalp,
      familyHistory: _familyHistory,
      age: _age,
    );

    try {
      final results = await _cbrService.calculateDiagnosis(input);
      setState(() {
        _results = results;
        _hasSearched = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sistem Pakar Dermatologi'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sistem Pakar Dermatologi'),
        ),
        body: Center(
          child: Text(_error!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistem Pakar Dermatologi'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and description
            const Text(
              'Diagnosa Penyakit Kulit Berbasis CBR',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Silakan isi gejala yang Anda alami untuk mendapatkan diagnosa berdasarkan kasus serupa',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Input form section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Input Gejala',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Erythema (Ordinal)
                    _buildOrdinalInput(
                      label: 'Erythema (Kemerahan)',
                      value: _erythema,
                      onChanged: (val) => setState(() => _erythema = val),
                    ),
                    const SizedBox(height: 16),

                    // Scaling (Ordinal)
                    _buildOrdinalInput(
                      label: 'Scaling (Pengelupasan)',
                      value: _scaling,
                      onChanged: (val) => setState(() => _scaling = val),
                    ),
                    const SizedBox(height: 16),

                    // Itching (Ordinal)
                    _buildOrdinalInput(
                      label: 'Itching (Gatal)',
                      value: _itching,
                      onChanged: (val) => setState(() => _itching = val),
                    ),
                    const SizedBox(height: 16),

                    // Knee and Elbow (Binary)
                    _buildBinaryInput(
                      label: 'Knee and Elbow (Lutut dan Siku)',
                      value: _kneeAndElbow == 1,
                      onChanged: (val) =>
                          setState(() => _kneeAndElbow = val ? 1 : 0),
                    ),
                    const SizedBox(height: 16),

                    // Scalp (Binary)
                    _buildBinaryInput(
                      label: 'Scalp (Kulit Kepala)',
                      value: _scalp == 1,
                      onChanged: (val) => setState(() => _scalp = val ? 1 : 0),
                    ),
                    const SizedBox(height: 16),

                    // Family History (Binary)
                    _buildBinaryInput(
                      label: 'Family History (Riwayat Keluarga)',
                      value: _familyHistory == 1,
                      onChanged: (val) =>
                          setState(() => _familyHistory = val ? 1 : 0),
                    ),
                    const SizedBox(height: 16),

                    // Age (Linear)
                    _buildAgeInput(),
                    const SizedBox(height: 24),

                    // Diagnose button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _performDiagnosis,
                        icon: const Icon(Icons.search),
                        label: const Text(
                          'Diagnosa',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Results section
            if (_hasSearched)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil Diagnosa (3 Kasus Terdekat)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._results.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final result = entry.value;
                    return _buildResultCard(index, result);
                  }),
                  const SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdinalInput({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    const options = ['Tidak', 'Ringan', 'Sedang', 'Parah'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButton<int>(
          value: value,
          isExpanded: true,
          items: List.generate(
            options.length,
            (idx) => DropdownMenuItem(
              value: idx,
              child: Text(options[idx]),
            ),
          ),
          onChanged: (val) => onChanged(val ?? 0),
        ),
      ],
    );
  }

  Widget _buildBinaryInput({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildAgeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usia: $_age tahun',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _age.toDouble(),
          min: 0,
          max: 100,
          divisions: 100,
          label: _age.toString(),
          onChanged: (val) => setState(() => _age = val.toInt()),
        ),
      ],
    );
  }

  Widget _buildResultCard(int rank, DiagnosisResult result) {
    final similarity = result.similarityScore * 100;
    Color getScoreColor() {
      if (similarity >= 70) return Colors.green;
      if (similarity >= 50) return Colors.orange;
      return Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ranking #$rank',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getScoreColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${similarity.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              result.case_.diagnosis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ID Kasus: ${result.case_.id}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Usia Pasien: ${result.case_.age} tahun',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Detail Perhitungan Button
            InkWell(
              onTap: () {
                final input = UserInput(
                  erythema: _erythema,
                  scaling: _scaling,
                  itching: _itching,
                  kneeAndElbow: _kneeAndElbow,
                  scalp: _scalp,
                  familyHistory: _familyHistory,
                  age: _age,
                );
                showCalculationDetail(
                  context,
                  input,
                  result.case_,
                  similarity,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lihat Detail Perhitungan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.blue[700],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

