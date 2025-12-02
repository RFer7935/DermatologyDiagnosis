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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sistem Pakar Dermatologi')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sistem Pakar Dermatologi')),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: const Text('Dermatologi Expert'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF95E1D3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.medical_services_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diagnosa Penyakit Kulit',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Berbasis CBR',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Isi gejala yang Anda alami untuk mendapatkan diagnosa akurat berdasarkan kasus serupa',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Input form section
            Card(
              elevation: 3,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.edit_note,
                            color: Color(0xFF4ECDC4),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Input Gejala',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

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
                      onChanged:
                          (val) => setState(() => _kneeAndElbow = val ? 1 : 0),
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
                      onChanged:
                          (val) => setState(() => _familyHistory = val ? 1 : 0),
                    ),
                    const SizedBox(height: 16),

                    // Age (Linear)
                    _buildAgeInput(),
                    const SizedBox(height: 24),

                    // Diagnose button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ECDC4), Color(0xFF95E1D3)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4ECDC4).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _performDiagnosis,
                          icon: const Icon(Icons.search, size: 22),
                          label: const Text(
                            'Mulai Diagnosa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_outlined,
                          color: Color(0xFF4ECDC4),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Hasil Diagnosa',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '3 Kasus Terdekat',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
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
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4ECDC4).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: DropdownButton<int>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4ECDC4)),
            style: const TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            items: List.generate(
              options.length,
              (idx) => DropdownMenuItem(value: idx, child: Text(options[idx])),
            ),
            onChanged: (val) => onChanged(val ?? 0),
          ),
        ),
      ],
    );
  }

  Widget _buildBinaryInput({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4ECDC4).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildAgeInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4ECDC4).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Usia',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_age tahun',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF4ECDC4),
              inactiveTrackColor: const Color(0xFF95E1D3).withOpacity(0.3),
              thumbColor: const Color(0xFF4ECDC4),
              overlayColor: const Color(0xFF4ECDC4).withOpacity(0.2),
              valueIndicatorColor: const Color(0xFF4ECDC4),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _age.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              label: _age.toString(),
              onChanged: (val) => setState(() => _age = val.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(int rank, DiagnosisResult result) {
    final similarity = result.similarityScore * 100;
    Color getScoreColor() {
      if (similarity >= 70) return const Color(0xFF4ECDC4);
      if (similarity >= 50) return const Color(0xFFFFB84D);
      return const Color(0xFFFF6B6B);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, getScoreColor().withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getScoreColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getScoreColor().withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: getScoreColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Rank #$rank',
                          style: TextStyle(
                            fontSize: 12,
                            color: getScoreColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          getScoreColor(),
                          getScoreColor().withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: getScoreColor().withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${similarity.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_hospital_rounded,
                      color: getScoreColor(),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        result.case_.diagnosis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.tag,
                    label: 'ID: ${result.case_.id}',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.person,
                    label: '${result.case_.age} tahun',
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4ECDC4), Color(0xFF95E1D3)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calculate_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Lihat Detail Perhitungan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4ECDC4).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4ECDC4)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
