import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myskiin/models/skin_type/skin_type.dart';
import 'package:myskiin/services/skin_type_service/skin_type_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/skin_type/skin_type_analysis.dart';


class SkinTypeAssessmentProvider extends ChangeNotifier {
  SkinTypeModel _skinTypeModel = SkinTypeModel();
  final SkinTypeService _skinTypeService = SkinTypeService();

  SkinTypeModel get skinType => _skinTypeModel;

  Future<void> initialize() async {
    await loadSavedAssessment();
  }


  void updateSkinFeelByMidday(String? skinFeelByMidday) {
    _skinTypeModel = _skinTypeModel.copyWith(skinFeelByMidday: skinFeelByMidday);
    _saveAssessment();
    notifyListeners();
  }

  void updateSkinFeelAfterWashingFace(String? skinFeelAfterWashingFace) {
    _skinTypeModel = _skinTypeModel.copyWith(skinFeelAfterWashingFace: skinFeelAfterWashingFace);
    _saveAssessment();
    notifyListeners();
  }


  void updateSkinReactionToNewSkinCare(String? skinReactionToNewSkinCare) {
    _skinTypeModel = _skinTypeModel.copyWith(skinReactionToNewSkinCare: skinReactionToNewSkinCare);
    _saveAssessment();
    notifyListeners();
  }


  Future<void> _saveAssessment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_skinTypeModel.toJson());
      await prefs.setString('skin_type_assessment', jsonString);
    } catch (e) {
      debugPrint('Error saving assessment: $e');
    }
  }

  Future<SkinTypeAnalysis> getSkinType() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('skin_type_assessment');
    final Map<String, dynamic> rawMap = jsonDecode(jsonString!);
    final Map<String, String> answers = rawMap.map((key, value) => MapEntry(key, value.toString()));
    final skinType = _skinTypeService.analyzeSkinType(answers);
    return skinType;
  }


  Future<void> loadSavedAssessment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('skin_type_assessment');
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString);
        _skinTypeModel = SkinTypeModel.fromJson(jsonMap);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading assessment: $e');
    }
  }
}
