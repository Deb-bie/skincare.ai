import '../../models/product/product_model.dart';
import '../data_manager/hive_models/hive_assessment_model.dart';
import '../product/product_matching_service.dart';

class EnhancedSkinAnalysisService {
  final ProductMatchingService _productMatcher = ProductMatchingService();


  Future<Map<String, dynamic>> analyzeAndRecommendWithProducts(HiveAssessmentModel data) async {
    String determinedSkinType = _determineSkinType(data);
    List<String> prioritizedConcerns = _prioritizeConcerns(data);

    Map<String, dynamic> routine = await _buildRoutineWithProducts(
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



  Future<Map<String, dynamic>> _buildRoutineWithProducts(
      String skinType,
      List<String> concerns,
      HiveAssessmentModel data
      ) async {
    String complexityLevel = _getRoutineComplexity(data.currentRoutine);

    return {
      'morning': await _buildMorningRoutineWithProducts(skinType, concerns, data, complexityLevel),
      'evening': await _buildEveningRoutineWithProducts(skinType, concerns, data, complexityLevel),
      'weekly': await _buildWeeklyRoutineWithProducts(skinType, concerns, data, complexityLevel),
      'complexityLevel': complexityLevel,
      'progression': _getProgressionPlan(complexityLevel, data),
    };
  }



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



  Future<List<Map<String, dynamic>>> _buildMorningRoutineWithProducts(
      String skinType,
      List<String> concerns,
      HiveAssessmentModel data,
      String complexityLevel
      ) async {

    List<Map<String, dynamic>> routine = [];
    ProductModel? toner;
    ProductModel? serum;
    ProductModel? serum2;
    ProductModel? eyeCream;

    final cleanser = await _productMatcher.findBestProduct(
        category: 'cleanser',
        skinType: skinType,
        concerns: concerns
    );

    final sunscreen = await _productMatcher.findBestProduct(
      category: 'sunscreen',
      skinType: skinType,
      concerns: concerns,
    );

    final moisturizer = await _productMatcher.findBestProduct(
        category: 'moisturizer',
        skinType: skinType,
        concerns: concerns
    );

    if (!concerns.contains('Sensitivity')) {
      toner = await _productMatcher.findBestProduct(
          category: 'toner',
          skinType: skinType,
          concerns: concerns
      );
    }

    if (concerns.isNotEmpty && concerns[0] != 'General maintenance') {
      serum = await _productMatcher.findBestProduct(
        category: 'serum',
        skinType: skinType,
        concerns: [concerns[0]],
      );
    }

    if (concerns.length > 1 && concerns[1] != 'General maintenance') {
      final additional = await _productMatcher.findBestProduct(
        category: 'serum',
        skinType: skinType,
        concerns: [concerns[1]],
      );

      if (additional?.id == serum?.id ||
          (additional?.name == serum?.name && additional?.brandName == serum?.brandName)) {
        serum2 = null;
      }
    }

    if (_shouldIncludeEyeCream(data.ageRange)) {
      eyeCream = await _productMatcher.findBestProduct(
          category: 'eye cream',
          skinType: skinType,
          concerns: concerns
      );
    }

    if (complexityLevel == 'advanced') {
      if (cleanser != null) {
        routine.add({
          'step': 'Cleanser',
          'product': cleanser,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'cleanser',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
            excludeProducts: [cleanser]
          ),
          'instruction': 'Gently massage onto damp face, rinse with lukewarm water'
        });
      }

      if (toner != null) {
        routine.add({
          'step': 'Toner',
          'product': toner,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'toner',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [toner]
          ),
          'instruction': 'Apply with cotton pad or pat gently with hands',
          'optional': false,
        });
      }

      if (eyeCream != null) {
        routine.add({
          'step': 'Eye Cream',
          'product': eyeCream,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'eye cream',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [eyeCream]
          ),
          'instruction': 'Gently pat around orbital bone',
          'optional': true,
        });
      }

      if (serum != null) {
        routine.add({
          'step': 'Treatment Serum',
          'product': serum,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'serum',
            skinType: skinType,
            concerns: [concerns[0]],
            limit: 2,
              excludeProducts: [serum]
          ),
          'instruction': 'Apply 2-3 drops, pat gently until absorbed',
          'optional': false,
        });
      }

      if (serum2 != null) {
        routine.add({
          'step': 'Additional Serum',
          'product': serum2,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'serum',
            skinType: skinType,
            concerns: [concerns[1]],
            limit: 2,
              excludeProducts: [serum2]
          ),
          'instruction': 'Apply after first serum, wait 30 seconds between',
          'optional': true,
        });
      }

      if (moisturizer != null) {
        routine.add({
          'step': 'Moisturizer',
          'product': moisturizer,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'moisturizer',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [moisturizer]
          ),
          'instruction': 'Apply evenly to face and neck',
          'optional': false,
        });
      }

      if (sunscreen != null) {
        routine.add({
          'step': 'Sunscreen',
          'product': sunscreen,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'sunscreen',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [sunscreen]
          ),
          'instruction': 'Apply SPF 30+ as final step, reapply every 2 hours',
          'optional': false,
        });
      }

      return routine;
    }

    else if (complexityLevel == "moderate") {
      if (cleanser != null) {
        routine.add({
          'step': 'Cleanser',
          'product': cleanser,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'cleanser',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [cleanser]
          ),
          'instruction': 'Gently massage onto damp face, rinse with lukewarm water'
        });
      }

      if (toner != null) {
        routine.add({
          'step': 'Toner',
          'product': toner,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'toner',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [toner]
          ),
          'instruction': 'Apply with cotton pad or pat gently with hands',
          'optional': false,
        });
      }

      if (serum != null) {
        routine.add({
          'step': 'Treatment Serum',
          'product': serum,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'serum',
            skinType: skinType,
            concerns: [concerns[0]],
            limit: 2,
              excludeProducts: [serum]
          ),
          'instruction': 'Apply 2-3 drops, pat gently until absorbed',
          'optional': false,
        });
      }

      if (moisturizer != null) {
        routine.add({
          'step': 'Moisturizer',
          'product': moisturizer,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'moisturizer',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [moisturizer]
          ),
          'instruction': 'Apply evenly to face and neck',
          'optional': false,
        });
      }

      if (sunscreen != null) {
        routine.add({
          'step': 'Sunscreen',
          'product': sunscreen,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'sunscreen',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [sunscreen]
          ),
          'instruction': 'Apply SPF 30+ as final step, reapply every 2 hours',
          'optional': false,
        });
      }

      return routine;
    }

    else {
      if (cleanser != null) {
        routine.add({
          'step': 'Cleanser',
          'product': cleanser,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'cleanser',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [cleanser]
          ),
          'instruction': 'Gently massage onto damp face, rinse with lukewarm water'
        });
      }

      if (moisturizer != null) {
        routine.add({
          'step': 'Moisturizer',
          'product': moisturizer,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'moisturizer',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [moisturizer]
          ),
          'instruction': 'Apply evenly to face and neck',
          'optional': false,
        });
      }

      if (sunscreen != null) {
        routine.add({
          'step': 'Sunscreen',
          'product': sunscreen,
          'alternatives': await _productMatcher.findProductsWithAlternatives(
            category: 'sunscreen',
            skinType: skinType,
            concerns: concerns,
            limit: 2,
              excludeProducts: [sunscreen]
          ),
          'instruction': 'Apply SPF 30+ as final step, reapply every 2 hours',
          'optional': false,
        });
      }

      return routine;
    }
  }



  Future<List<Map<String, dynamic>>> _buildEveningRoutineWithProducts(
      String skinType,
      List<String> concerns,
      HiveAssessmentModel data,
      String complexityLevel
      ) async {

    List<Map<String, dynamic>> routine = [];
    ProductModel? serum1;
    ProductModel? serum2;

    if (concerns.isNotEmpty && concerns[0] != 'General maintenance') {
      serum1 = await _productMatcher.findBestProduct(
        category: 'serum',
        skinType: skinType,
        concerns: [concerns[0]],
      );
    }

    if (concerns.length > 1 && concerns[1] != 'General maintenance') {
      final additional = await _productMatcher.findBestProduct(
        category: 'serum',
        skinType: skinType,
        concerns: [concerns[1]],
      );

      if (additional?.id == serum1?.id ||
          (additional?.name == serum1?.name && additional?.brandName == serum1?.brandName)) {
        serum2 = null;
      }
    }

    final cleanser = await _productMatcher.findBestProduct(
      category: 'cleanser',
      skinType: skinType,
      concerns: concerns
    );

    if (cleanser != null) {
      routine.add({
        'step': 'Cleanser',
        'product': cleanser,
        'instruction': 'Remove makeup/sunscreen, massage onto face, rinse thoroughly',
        'optional': false,
      });
    }


    if (complexityLevel == 'minimal') {
      return routine;
    }


    final moisturizer = await _productMatcher.findBestProduct(
      category: 'moisturizer',
      skinType: skinType,
      concerns: concerns
    );

    if (moisturizer != null) {
      routine.add({
        'step': 'Night Moisturizer',
        'product': moisturizer,
        'instruction': 'Apply as final step to seal in treatments',
        'optional': false,
      });
    }


    if (complexityLevel == 'basic') {
      return routine;
    }


    if (!concerns.contains('Sensitivity')) {
      final toner = await _productMatcher.findBestProduct(
        category: 'toner',
        skinType: skinType,
        concerns: concerns
      );

      if (toner != null) {
        routine.insert(1, {
          'step': 'Toner',
          'product': toner,
          'instruction': 'Apply with cotton pad or pat gently with hands',
          'optional': false,
        });
      }
    }


    if (concerns.isNotEmpty && concerns[0] != 'General maintenance') {
      if (serum1 != null) {
        int insertIndex = routine.indexWhere((r) => r['step'] == 'Night Moisturizer');
        routine.insert(insertIndex, {
          'step': 'Primary Treatment',
          'product': serum1,
          'instruction': 'Apply and let absorb for 1-2 minutes',
          'optional': false,
        });
      }
    }


    if (complexityLevel == 'moderate') {
      return routine;
    }


    if (concerns.length > 1 && concerns[1] != 'General maintenance') {

      if (serum2 != null) {
        int insertIndex = routine.indexWhere((r) => r['step'] == 'Night Moisturizer');
        routine.insert(insertIndex, {
          'step': 'Secondary Treatment',
          'product': serum2,
          'instruction': 'Apply after primary treatment, wait between applications',
          'optional': true,
        });
      }
    }


    if (_shouldIncludeEyeCream(data.ageRange)) {
      final eyeCream = await _productMatcher.findBestProduct(
        category: 'eye cream',
        skinType: skinType,
        concerns: concerns
      );

      if (eyeCream != null) {
        int insertIndex = routine.indexWhere((r) => r['step'] == 'Night Moisturizer');
        routine.insert(insertIndex, {
          'step': 'Eye Cream',
          'product': eyeCream,
          'instruction': 'Gently pat around orbital bone',
          'optional': true,
        });
      }
    }

    return routine;
  }


  Future<List<Map<String, dynamic>>> _buildWeeklyRoutineWithProducts(
      String skinType,
      List<String> concerns,
      HiveAssessmentModel data,
      String complexityLevel
      ) async {

    List<Map<String, dynamic>> routine = [];

    if (complexityLevel == 'minimal') {
      return routine;
    }

    final exfoliator = await _productMatcher.findBestProduct(
      category: 'exfoliator',
      skinType: skinType,
      concerns: concerns
    );

    if (exfoliator != null) {
      String frequency = complexityLevel == 'basic'
          ? (skinType == 'Sensitive' ? '1x per week' : '1-2x per week')
          : (skinType == 'Sensitive' ? '1-2x per week' : '2-3x per week');

      routine.add({
        'step': 'Exfoliation',
        'product': exfoliator,
        'instruction': 'Use $frequency in the evening, avoid over-exfoliating',
        'optional': false,
      });
    }


    if (complexityLevel == 'moderate' || complexityLevel == 'advanced') {
      final mask = await _productMatcher.findBestProduct(
        category: 'mask',
        skinType: skinType,
        concerns: concerns
      );

      if (mask != null) {
        routine.add({
          'step': 'Face Mask',
          'product': mask,
          'instruction': 'Apply 1-2x per week for 10-15 minutes',
          'optional': complexityLevel == 'moderate',
        });
      }
    }

    return routine;
  }


  Map<String, dynamic> _getProgressionPlan(String level, HiveAssessmentModel data) {
    switch (level) {
      case 'minimal':
        return {
          'message': 'Starting with the essentials to build a foundation',
          'productCount': '2-3 products',
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
          'productCount': '3-4 products',
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
          'productCount': '5-7 products',
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
          'productCount': '7+ products',
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
          'productCount': '3-5 products',
          'nextSteps': ['Follow consistently', 'Track progress'],
          'timeframe': '6-12 weeks',
        };
    }
  }


  String _determineSkinType(HiveAssessmentModel data) {
    if (data.skinType != null && data.skinType!.isNotEmpty) {
      return data.skinType!;
    }

    if (data.skinConcerns != null && data.skinConcerns!.isNotEmpty) {
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

  List<String> _prioritizeConcerns(HiveAssessmentModel data) {
    if (data.skinConcerns == null || data.skinConcerns!.isEmpty) {
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


  bool _shouldIncludeEyeCream(String? ageRange) {
    if (ageRange == null) return false;
    List<String> olderGroups = ['25-34', '35-44', '45-54', '55-above'];
    return olderGroups.contains(ageRange);
  }

  double _calculateConfidence(HiveAssessmentModel data) {
    return data.getAssessmentCompletionPercentage();
  }

  List<String> _getGeneralRecommendations(HiveAssessmentModel data, String skinType) {
    List<String> recommendations = [];

    if (data.ageRange != null) {
      if (data.ageRange == '18-24') {
        recommendations.add('Focus on prevention: sunscreen and basic hydration');
      } else if (data.ageRange == '25-34') {
        recommendations.add('Start incorporating anti-aging actives like retinol');
      } else if (['35-44', '45-54', '55+'].contains(data.ageRange)) {
        recommendations.add('Prioritize retinoids, peptides, and intense hydration');
      }
    }

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

    recommendations.add('Always wear SPF 30+ during the day');
    recommendations.add('Introduce new products one at a time');
    recommendations.add('Be consistent - results take 6-12 weeks');

    return recommendations;
  }
}

