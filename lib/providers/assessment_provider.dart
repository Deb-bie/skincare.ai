
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:myskiin/models/assessment_data/assessment_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/skin_analysis/skin_analysis_service.dart';

class AssessmentProvider extends ChangeNotifier {
  AssessmentModel _assessmentModel = AssessmentModel();
  final SkinAnalysisService _analysisService = SkinAnalysisService();

  AssessmentModel get assessmentData => _assessmentModel;

  // Initialize and load saved data
  Future<void> initialize() async {
    await loadSavedAssessment();
  }

  // Update individual fields
  void updateGender(String? gender) {
    _assessmentModel = _assessmentModel.copyWith(gender: gender);
    _saveAssessment();
    notifyListeners();
  }

  void updateAgeRange(String? ageRange) {
    _assessmentModel = _assessmentModel.copyWith(ageRange: ageRange);
    _saveAssessment();
    notifyListeners();
  }

  void updateSkinType(String? skinType) {
    _assessmentModel = _assessmentModel.copyWith(skinType: skinType);
    _saveAssessment();
    notifyListeners();
  }

  void updateSkinConcerns(Set<String>? concerns) {
    _assessmentModel = _assessmentModel.copyWith(skinConcerns: concerns!);
    _saveAssessment();
    notifyListeners();
  }

  void updateCurrentRoutine(String? routine) {
    _assessmentModel = _assessmentModel.copyWith(currentRoutine: routine);
    _saveAssessment();
    notifyListeners();
  }

  // Save assessment to local storage
  Future<void> _saveAssessment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_assessmentModel.toJson());
      await prefs.setString('skincare_assessment', jsonString);
    } catch (e) {
      debugPrint('Error saving assessment: $e');
    }
  }

  // Load saved assessment
  Future<void> loadSavedAssessment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('skincare_assessment');

      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString);
        _assessmentModel = AssessmentModel.fromJson(jsonMap);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading assessment: $e');
    }
  }

  // Clear assessment data
  Future<void> clearAssessment() async {
    _assessmentModel = AssessmentModel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('skincare_assessment');
    notifyListeners();
  }

  // Get skin analysis and recommendations
  Map<String, dynamic> getRecommendations() {
    return _analysisService.analyzeAndRecommend(_assessmentModel);
  }

  // Check if assessment is complete enough for recommendations
  bool canGenerateRecommendations() {
    // Can generate basic recommendations even with minimal data
    // But better recommendations with more complete data
    return true;
  }

  double getCompletionPercentage() {
    return _assessmentModel.getAssessmentCompletionPercentage();
  }

}




