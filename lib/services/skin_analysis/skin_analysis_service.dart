import '../../models/assessment_data/assessment_data.dart';

class SkinAnalysisService {
  Map<String, dynamic> analyzeAndRecommend(AssessmentModel data) {

    String determinedSkinType = _determineSkinType(data);

    List<String> prioritizedConcerns = _prioritizeConcerns(data);

    Map<String, dynamic> routine = _buildRoutine(
        determinedSkinType,
        prioritizedConcerns,
        data
    );

    return {
      'skinType': determinedSkinType,
      'concerns': prioritizedConcerns,
      'routine': routine,
      'confidence': _calculateConfidence(data),
      'recommendations': _getGeneralRecommendations(data, determinedSkinType),
    };
  }


  String _determineSkinType(AssessmentModel data) {
    if (data.skinType != null && data.skinType!.isNotEmpty) {
      return data.skinType!;
    }

    if (data.skinConcerns!.isNotEmpty) {

      if (data.skinConcerns!.contains('Acne') ||
          data.skinConcerns!.contains('Large pores') ||
          data.skinConcerns!.contains('Oiliness')) {
        return 'Oily';
      }

      if (data.skinConcerns!.contains('Dryness') ||
          data.skinConcerns!.contains('Flakiness') ||
          data.skinConcerns!.contains('Rough texture')) {
        return 'Dry';
      }

      if (data.skinConcerns!.contains('Sensitivity') ||
          data.skinConcerns!.contains('Redness') ||
          data.skinConcerns!.contains('Irritation')) {
        return 'Sensitive';
      }


      if (data.skinConcerns!.contains('Oiliness') &&
          data.skinConcerns!.contains('Dryness')) {
        return 'Combination';
      }
    }


    return 'Normal';
  }


  List<String> _prioritizeConcerns(AssessmentModel data) {

    if (data.skinConcerns!.isEmpty) {
      return ['General maintenance'];
    }

    List<String> priorityOrder = [
      'Acne',
      'Hyperpigmentation',
      'Dark spots',
      'Fine lines',
      'Wrinkles',
      'Dryness',
      'Oiliness',
      'Redness',
      'Sensitivity',
      'Dullness',
      'Uneven texture',
    ];

    List<String> prioritized = [];

    for (String priority in priorityOrder) {
      if (data.skinConcerns!.contains(priority)) {
        prioritized.add(priority);
      }
    }

    for (String concern in data.skinConcerns!) {
      if (!prioritized.contains(concern)) {
        prioritized.add(concern);
      }
    }

    return prioritized;
  }


  Map<String, dynamic> _buildRoutine(String skinType, List<String> concerns, AssessmentModel data) {
    return {
      'morning': _buildMorningRoutine(skinType, concerns, data),
      'evening': _buildEveningRoutine(skinType, concerns, data),
      'weekly': _buildWeeklyRoutine(skinType, concerns, data),
    };
  }


  // Map current routine to complexity level
  String _getRoutineComplexity(String? currentRoutine) {
    if (currentRoutine == null || currentRoutine == 'prefer_not_to_say') {
      return 'basic';
    }

    switch (currentRoutine) {
      case 'no_routine':
        return 'minimal';
      case 'basic':
        return 'basic';
      case 'moderate':
        return 'moderate';
      case 'extensive':
        return 'advanced';
      default:
        return 'basic';
    }
  }


  Map<String, dynamic> _getProgressionPlan(String level, AssessmentModel data) {
    switch (level) {
      case 'minimal':
        return {
          'message': 'Starting with the essentials to build a foundation',
          'nextSteps': [
            'Master these basics for 4-6 weeks',
            'Once comfortable, add a targeted treatment serum',
            'Gradually introduce one new product at a time',
          ],
          'timeframe': '4-6 weeks before adding more products',
        };
      case 'basic':
        return {
          'message': 'Building on your current routine with key additions',
          'nextSteps': [
            'Focus on consistency with these core products',
            'After 6-8 weeks, consider adding specialized treatments',
            'Monitor your skin\'s response before adding more',
          ],
          'timeframe': '6-8 weeks to see results',
        };
      case 'moderate':
        return {
          'message': 'Comprehensive routine matching your experience level',
          'nextSteps': [
            'You can handle multiple actives - space them properly',
            'Consider alternating stronger treatments',
            'Listen to your skin and adjust as needed',
          ],
          'timeframe': '8-12 weeks for full results',
        };
      case 'advanced':
        return {
          'message': 'Advanced routine for experienced skincare users',
          'nextSteps': [
            'You know your skin - customize as needed',
            'Layer products strategically for maximum benefit',
            'Consider professional treatments for enhanced results',
          ],
          'timeframe': '12+ weeks, ongoing optimization',
        };
      default:
        return {
          'message': 'Tailored routine for your needs',
          'nextSteps': ['Follow consistently', 'Track progress'],
          'timeframe': '6-12 weeks',
        };
    }
  }


  List<Map<String, String>> _buildMorningRoutine(String skinType, List<String> concerns, AssessmentModel data) {

    List<Map<String, String>> routine = [];

    // 1. Cleanser
    routine.add({
      'step': 'Cleanser',
      'product': _getCleanserRecommendation(skinType, data),
      'instruction': 'Gently massage onto damp face, rinse with lukewarm water',
    });

    // 2. Toner (if not super sensitive)
    if (!concerns.contains('Sensitivity')) {
      routine.add({
        'step': 'Toner',
        'product': _getTonerRecommendation(skinType, concerns),
        'instruction': 'Apply with cotton pad or pat gently with hands',
      });
    }

    // 3. Treatment serums (based on top concerns)
    if (concerns.isNotEmpty && concerns[0] != 'General maintenance') {
      routine.add({
        'step': 'Serums',
        'product': _getSerumRecommendation(concerns[0], true),
        'instruction': 'Apply 2-3 drops, pat gently until absorbed',
      });
    }

    // 4. Moisturizer
    routine.add({
      'step': 'Moisturizer',
      'product': _getMoisturizerRecommendation(skinType, data),
      'instruction': 'Apply evenly to face and neck',
    });

    // 5. Sunscreen (ALWAYS in AM)
    routine.add({
      'step': 'Sunscreen',
      'product': _getSunscreenRecommendation(skinType, data),
      'instruction': 'Apply SPF 30+ as final step, reapply every 2 hours',
    });

    return routine;
  }

  List<Map<String, String>> _buildEveningRoutine(String skinType, List<String> concerns, AssessmentModel data) {
    List<Map<String, String>> routine = [];

    // 1. Cleanser (double cleanse if wearing makeup)
    routine.add({
      'step': 'Cleanser',
      'product': _getCleanserRecommendation(skinType, data),
      'instruction': 'Remove makeup/sunscreen, massage onto face, rinse thoroughly',
    });

    // 2. Toner
    if (!concerns.contains('Sensitivity')) {
      routine.add({
        'step': 'Toner',
        'product': _getTonerRecommendation(skinType, concerns),
        'instruction': 'Apply with cotton pad or pat gently with hands',
      });
    }

    // 3. Treatment serums (can layer multiple at night)
    for (int i = 0; i < concerns.length && i < 2; i++) {
      if (concerns.elementAt(i) != 'General maintenance') {
        routine.add({
          'step': 'Treatment ${i + 1}',
          'product': _getSerumRecommendation(concerns.elementAt(i), false),
          'instruction': 'Wait 1-2 minutes between treatments',
        });
      }
    }

    // 4. Eye cream (if age 25+)
    if (_shouldIncludeEyeCream(data.ageRange)) {
      routine.add({
        'step': 'Eye Cream',
        'product': 'Caffeine or peptide eye cream',
        'instruction': 'Gently pat around orbital bone',
      });
    }

    // 5. Moisturizer
    routine.add({
      'step': 'Night Moisturizer',
      'product': _getNightMoisturizerRecommendation(skinType, concerns, data),
      'instruction': 'Apply as final step to seal in treatments',
    });

    return routine;
  }

  List<Map<String, String>> _buildWeeklyRoutine(String skinType, List<String> concerns, AssessmentModel data) {
    List<Map<String, String>> routine = [];

    // Exfoliation
    String frequency = skinType == 'Sensitive' ? '1-2x per week' : '2-3x per week';
    routine.add({
      'step': 'Exfoliation',
      'product': _getExfoliatorRecommendation(skinType, concerns),
      'instruction': 'Use $frequency, avoid over-exfoliating',
    });

    // Face mask
    routine.add({
      'step': 'Face Mask',
      'product': _getMaskRecommendation(skinType, concerns),
      'instruction': 'Apply 1-2x per week for 10-15 minutes',
    });

    return routine;
  }

  // Product recommendation helpers
  String _getCleanserRecommendation(String skinType, AssessmentModel data) {
    switch (skinType) {
      case 'Oily':
        return 'Gel-based or foaming cleanser with salicylic acid';
      case 'Dry':
        return 'Cream or milk cleanser with hydrating ingredients';
      case 'Sensitive':
        return 'Gentle, fragrance-free cream cleanser';
      case 'Combination':
        return 'Balanced gel cleanser suitable for all skin types';
      default:
        return 'Gentle foaming cleanser';
    }
  }

  String _getTonerRecommendation(String skinType, List<String> concerns) {
    if (concerns.contains('Acne') || concerns.contains('Oiliness')) {
      return 'Salicylic acid or witch hazel toner';
    }
    if (concerns.contains('Dryness') || skinType == 'Dry') {
      return 'Hydrating toner with hyaluronic acid';
    }
    return 'Balancing pH-adjusting toner';
  }

  String _getSerumRecommendation(String concern, bool isMorning) {
    Map<String, Map<String, String>> serumMap = {
      'Acne': {'am': 'Niacinamide serum', 'pm': 'Salicylic acid or retinol'},
      'Hyperpigmentation': {'am': 'Vitamin C serum', 'pm': 'Alpha arbutin or kojic acid'},
      'Dark spots': {'am': 'Vitamin C serum', 'pm': 'Tranexamic acid'},
      'Fine lines': {'am': 'Peptide serum', 'pm': 'Retinol'},
      'Wrinkles': {'am': 'Antioxidant serum', 'pm': 'Retinol'},
      'Dryness': {'am': 'Hyaluronic acid', 'pm': 'Hyaluronic acid + ceramides'},
      'Redness': {'am': 'Centella asiatica', 'pm': 'Azelaic acid'},
    };

    if (serumMap.containsKey(concern)) {
      return serumMap[concern]![isMorning ? 'am' : 'pm']!;
    }
    return 'Niacinamide serum';
  }

  String _getMoisturizerRecommendation(String skinType, AssessmentModel data) {
    switch (skinType) {
      case 'Oily':
        return 'Lightweight, oil-free gel moisturizer';
      case 'Dry':
        return 'Rich cream with ceramides and shea butter';
      case 'Sensitive':
        return 'Fragrance-free, minimal ingredient moisturizer';
      case 'Combination':
        return 'Lightweight lotion with balanced hydration';
      default:
        return 'Balanced day cream with SPF';
    }
  }

  String _getNightMoisturizerRecommendation(String skinType, List<String> concerns, AssessmentModel data) {
    if (concerns.contains('Wrinkles') || concerns.contains('Fine lines')) {
      return 'Rich anti-aging night cream with retinol or peptides';
    }
    if (skinType == 'Dry') {
      return 'Heavy occlusive night cream';
    }
    return 'Nourishing night moisturizer';
  }

  String _getSunscreenRecommendation(String skinType, AssessmentModel data) {
    switch (skinType) {
      case 'Oily':
        return 'Matte-finish, oil-free mineral sunscreen SPF 30+';
      case 'Dry':
        return 'Hydrating chemical sunscreen SPF 50+';
      case 'Sensitive':
        return 'Mineral (zinc oxide) sunscreen SPF 30+';
      default:
        return 'Broad spectrum SPF 30+ sunscreen';
    }
  }

  String _getExfoliatorRecommendation(String skinType, List<String> concerns) {
    if (skinType == 'Sensitive') {
      return 'Gentle enzyme exfoliator (papaya or pumpkin)';
    }
    if (concerns.contains('Acne')) {
      return 'BHA (salicylic acid) chemical exfoliator';
    }
    return 'AHA (glycolic or lactic acid) exfoliator';
  }

  String _getMaskRecommendation(String skinType, List<String> concerns) {
    if (concerns.contains('Acne')) {
      return 'Clay mask with sulfur or charcoal';
    }
    if (skinType == 'Dry') {
      return 'Hydrating sheet mask or sleeping mask';
    }
    return 'Multi-masking based on zone needs';
  }

  bool _shouldIncludeEyeCream(String? ageRange) {
    if (ageRange == null) return false;
    List<String> olderGroups = ['25-34', '35-44', '45-54', '55+'];
    return olderGroups.contains(ageRange);
  }

  // Calculate confidence score based on data completeness
  double _calculateConfidence(AssessmentModel data) {
    return data.getAssessmentCompletionPercentage();
  }

  // General recommendations
  List<String> _getGeneralRecommendations(
      AssessmentModel data,
      String skinType
      ) {
    List<String> recommendations = [];

    // Age-based recommendations
    if (data.ageRange != null) {
      if (data.ageRange == '18-24') {
        recommendations.add('Focus on prevention: sunscreen and basic hydration');
      } else if (data.ageRange == '25-34') {
        recommendations.add('Start incorporating anti-aging actives like retinol');
      } else if (['35-44', '45-54', '55+'].contains(data.ageRange)) {
        recommendations.add('Prioritize retinoids, peptides, and intense hydration');
      }
    }

    // Skin type specific
    switch (skinType) {
      case 'Oily':
        recommendations.add('Avoid heavy oils, opt for lightweight products');
        break;
      case 'Dry':
        recommendations.add('Layer hydrating products and use occlusive at night');
        break;
      case 'Sensitive':
        recommendations.add('Patch test new products, avoid fragrance and harsh actives');
        break;
    }

    // Universal recommendations
    recommendations.add('Always wear SPF 30+ during the day');
    recommendations.add('Introduce new products one at a time');
    recommendations.add('Be consistent - results take 6-12 weeks');

    return recommendations;
  }
}
