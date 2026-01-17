import 'package:flutter/foundation.dart';
import 'package:myskiin/services/skin_analysis/enhanced_analysis.dart';

import '../services/data_manager/data_manager.dart';
import '../services/data_manager/hive_models/hive_assessment_model.dart';

class AssessmentProvider extends ChangeNotifier {
  final EnhancedSkinAnalysisService _analysisService = EnhancedSkinAnalysisService();

  final DataManager _dataManager = DataManager();
  HiveAssessmentModel? _hiveAssessmentModel;
  HiveAssessmentModel? get assessmentData => _hiveAssessmentModel;

  // Initialize and load saved data from Hive
  Future<void> initialize() async {
    _hiveAssessmentModel = _dataManager.getOrCreateActiveAssessment();
    notifyListeners();
  }

  // Update individual fields and save to Hive immediately
  void updateGender(String? gender) {
    if (_hiveAssessmentModel == null) return;
    _hiveAssessmentModel!
      ..gender = gender
      ..updatedAt = DateTime.now()
      ..isSynced = false
      ..save();
    notifyListeners();
  }

  void updateAgeRange(String? ageRange) {
    if (_hiveAssessmentModel == null) return;
    _hiveAssessmentModel!
      ..ageRange = ageRange
      ..updatedAt = DateTime.now()
      ..isSynced = false
      ..save();
    notifyListeners();
  }

  void updateSkinType(String? skinType) {
    if (_hiveAssessmentModel == null) return;
    _hiveAssessmentModel!
      ..skinType = skinType
      ..updatedAt = DateTime.now()
      ..isSynced = false
      ..save();
    notifyListeners();
  }

  void updateSkinConcerns(List<String>? concerns) {
    if (_hiveAssessmentModel == null) return;
    _hiveAssessmentModel!
      ..skinConcerns = concerns
      ..updatedAt = DateTime.now()
      ..isSynced = false
      ..save();
    notifyListeners();
  }

  void updateCurrentRoutine(String? routine) {
    if (_hiveAssessmentModel == null) return;
    _hiveAssessmentModel!
      ..currentRoutine = routine
      ..updatedAt = DateTime.now()
      ..isSynced = false
      ..save();
    notifyListeners();
  }

  // Clear active assessment (reset)
  Future<void> clearAssessment() async {
    if (_hiveAssessmentModel == null) return;
    _dataManager.resetActiveAssessment();
    _hiveAssessmentModel = _dataManager.getOrCreateActiveAssessment();
    notifyListeners();
  }

  // Submit the assessment (move from active draft to history)
  Future<void> submitAssessment() async {
    await _dataManager.submitAssessment();
    _hiveAssessmentModel = null;
    notifyListeners();
  }

  // Get recommendations from your existing analysis service
  Future<Map<String, dynamic>> getRecommendations() {
    return _analysisService.analyzeAndRecommendWithProducts(_hiveAssessmentModel!);
  }

  // Check if assessment is complete enough for recommendations
  bool canGenerateRecommendations() {
    return true;
  }

  double getCompletionPercentage() {
    return _hiveAssessmentModel?.getAssessmentCompletionPercentage() ?? 0.0;
  }

}




