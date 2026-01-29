
import '../../models/skin_type/skin_type_analysis.dart';
import '../../models/skin_type/skin_type_score.dart';

class SkinTypeService {

  SkinTypeAnalysis analyzeSkinType(Map<String, String> answers) {
    final scores = _initializeScores();

    _analyzeSkinFeelByMidday(answers, scores);
    _analyzeSkinFeelAfterWashingFace(answers, scores);
    _analyzeSkinReactionToNewSkincare(answers, scores);
    _applyWeightedAdjustments(scores);
    final analysis = _determineSkinTypes(scores, answers);
    return analysis;

  }


  static Map<String, SkinTypeScore> _initializeScores() {
    return {
      'Dry': SkinTypeScore(),
      'Oily': SkinTypeScore(),
      'Combination': SkinTypeScore(),
      'Normal': SkinTypeScore(),
      'Sensitive': SkinTypeScore(),
    };
  }

  static void _analyzeSkinFeelByMidday(Map<String, String> answers, Map<String, SkinTypeScore> scores) {
    final skinFeelByMidday = answers['skinFeelByMidday'];
    switch (skinFeelByMidday) {
      case 'oily_all_over':
        scores['Oily']!.addScore(2.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'oily_in_t_zone_only':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(2.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'comfortable':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(2.0);
        break;
      case 'tight_and_dry':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(2.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'varies_by_season':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(1.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(1.0);
        break;
    }
  }


  static void _analyzeSkinFeelAfterWashingFace(Map<String, String> answers, Map<String, SkinTypeScore> scores) {
    final skinFeelAfterWashingFace = answers['skinFeelAfterWashingFace'];
    switch (skinFeelAfterWashingFace) {
      case 'oily_again_quickly':
        scores['Oily']!.addScore(2.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'comfortable_and_fresh':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(2.0);
        break;
      case 'very_tight_and_uncomfortable':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(2.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'red_burning_itchy':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(2.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'tight_in_some_areas_oily_in_others':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(2.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(0.0);
        break;
    }
  }


  static void _analyzeSkinReactionToNewSkincare(Map<String, String> answers, Map<String, SkinTypeScore> scores) {
    final skinReactionToNewSkinCare = answers['skinReactionToNewSkinCare'];
    switch (skinReactionToNewSkinCare) {
      case 'often_redness_burning_itching':
        scores['Oily']!.addScore(2.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(2.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'sometimes_reactive':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(1.0);
        scores['Sensitive']!.addScore(1.0);
        scores['Normal']!.addScore(0.0);
        break;
      case 'rarely_reactive':
        scores['Oily']!.addScore(1.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(1.0);
        break;
      case 'never_reactive':
        scores['Oily']!.addScore(0.0);
        scores['Dry']!.addScore(0.0);
        scores['Combination']!.addScore(0.0);
        scores['Sensitive']!.addScore(0.0);
        scores['Normal']!.addScore(2.0);
        break;
    }
  }


  static void _applyWeightedAdjustments(Map<String, SkinTypeScore> scores) {
    // Oil production and dryness are the strongest indicators (Question 1)
    scores['Oily']!.score *= 1.20;  // stronger weight
    scores['Dry']!.score *= 1.20;

    // Combination is valid only when both oily + dry signals appear
    // If both Oily and Dry have some score, boost Combo
    final oily = scores['Oily']!.score;
    final dry = scores['Dry']!.score;

    if (oily > 0 && dry > 0) {
      scores['Combination']!.score *= 1.15;
    } else {
      scores['Combination']!.score *= 1.05; // light boost otherwise
    }

    // Normal skin = absence of extremes
    // If either oily or dry is strongly present, reduce Normal
    if (oily >= 3 || dry >= 3) {
      scores['Normal']!.score *= 0.75;
    } else if (scores['Combination']!.score >= 4) {
      // If combination is strongly present, normal becomes less likely
      scores['Normal']!.score *= 0.85;
    }

    // Sensitive is a modifier — only dominant when high
    final sensitive = scores['Sensitive']!.score;

    if (sensitive < 2) {
      scores['Sensitive']!.score *= 0.7;
    } else if (sensitive >= 3) {
      scores['Sensitive']!.score *= 1.2;
    }

    // 5. Detect oily ↔ dry conflict without strong combination indication
    final oilyDryGap = (oily - dry).abs();

    // If scores for oily & dry are close, and combination is not high,
    // this usually indicates inconsistent patterns → lean Normal
    if (oilyDryGap <= 1 && scores['Combination']!.score < 3) {
      scores['Normal']!.score *= 1.25;
    }

    // If both oily and dry are high → combination likely
    if (oily >= 3 && dry >= 3) {
      scores['Combination']!.score *= 1.25;
    }
  }


  static SkinTypeAnalysis _determineSkinTypes(Map<String, SkinTypeScore> scores, Map<String, String> answers) {

    // Extract the sensitive score separately
    final sensitiveScore = scores['Sensitive']!.score;

    // Main skin types: Oily, Dry, Combination, Normal
    final mainScores = Map<String, SkinTypeScore>.from(scores)
      ..remove('Sensitive');

    // Sort by score descending
    final sorted = mainScores.entries.toList()
      ..sort((a, b) => b.value.score.compareTo(a.value.score));

    final primaryType = sorted[0].key;
    final primaryScore = sorted[0].value.score;
    final secondType = sorted.length > 1 ? sorted[1].key : null;
    final secondScore = sorted.length > 1 ? sorted[1].value.score : 0;

    String finalPrimary = primaryType;
    String? finalSecondary;

    // -----------------------------------------
    // 1. If there's a tie, apply quiz-based tie-breakers
    // -----------------------------------------

    // If scores differ by ≤1, treat this as a potential tie.
    // if ((primaryScore - secondScore).abs() <= 1 && secondType != null) {
    //
    //   // TIE-BREAKER RULE 1:
    //   // Use Q1 (midday feel) to determine oil/dry/normal/combination
    //   switch (answers[]) {
    //     case 'oily_all_over':
    //       finalPrimary = 'Oily';
    //       break;
    //     case 'oily_tzone':
    //       finalPrimary = 'Combination';
    //       break;
    //     case 'tight_dry':
    //       finalPrimary = 'Dry';
    //       break;
    //     case 'comfortable':
    //       finalPrimary = 'Normal';
    //       break;
    //     case 'varies':
    //     // Keep primary but mark secondary
    //       finalSecondary = secondType;
    //       break;
    //   }
    //
    //   // TIE-BREAKER RULE 2 (if still tied):
    //   // Use Q2 (post-wash feel)
    //   if (finalPrimary == primaryType) {
    //     switch (userAnswers.q2) {
    //       case 'oily_quickly':
    //         finalPrimary = 'Oily';
    //         break;
    //       case 'tight_uncomfortable':
    //         finalPrimary = 'Dry';
    //         break;
    //       case 'tight_some_oily_some':
    //         finalPrimary = 'Combination';
    //         break;
    //       case 'comfortable_fresh':
    //         finalPrimary = 'Normal';
    //         break;
    //       case 'red_burning':
    //       // could elevate Sensitive, but not primary
    //         break;
    //     }
    //   }
    // }


    // Secondary type is meaningful only if close to primary
    if (secondScore >= primaryScore * 0.6 && secondType != finalPrimary) {
      finalSecondary = secondType;
    }


    final bool isSensitive = sensitiveScore >= 2.5; // adjusted for small scoring range

    String skinTypeMeaning = "";
    String typePersonalizedInsight = "";


    switch (finalPrimary) {
      case "Oily":
        skinTypeMeaning = "Oily skin means your skin produces excess sebum. Your face may look shiny throughout the day especially in the T-zone and you may notice enlarged pores and a tendency for acne or blackheads.";
        typePersonalizedInsight = "Oily skin thrives with lightweight, clarifying care. We’ll help you find the perfect routine to keep shine controlled and your skin feeling fresh.";
        break;

      case "Dry":
        skinTypeMeaning = "Dry skin means your skin lacks moisture and natural oils. It often feels tight, rough, or flaky, especially after washing your face. You may also notice dullness or fine dry patches.";
        typePersonalizedInsight = "Dry skin thrives with deep hydration and nourishment. We’ll help you find the perfect routine to keep your skin soft, smooth, and comfortable.";
        break;

      case "Sensitive":
        skinTypeMeaning = "Sensitive skin means your skin reacts easily to products or environmental triggers. It may become red, itchy, stinging, or irritated when using new skincare products, harsh ingredients, or during weather changes.";
        typePersonalizedInsight = "Sensitive skin thrives with gentle, soothing care. We’ll help you find the perfect routine to keep your skin calm, protected, and irritation-free.";
        break;

      case "Combination":
        skinTypeMeaning = "Combination skin means you have both oily and dry areas. Typically, the T-zone (forehead, nose, and chin) is oily, while the cheeks are dry.";
        typePersonalizedInsight = "Combination skin thrives with balanced care. We'll help you find the perfect routine to keep your skin happy and healthy.";
        break;

      case "Normal":
        skinTypeMeaning = "Normal skin means your skin is naturally balanced. It’s not too oily or too dry, feels comfortable throughout the day, and usually has small pores with minimal sensitivity or blemishes";
        typePersonalizedInsight = "Normal skin thrives with simple, steady care. We’ll help you find the perfect routine to maintain your skin’s natural balance and glow.";
        break;

    }


    return SkinTypeAnalysis(
      primary: finalPrimary,
      secondary: finalSecondary,
      isSensitive: isSensitive,
      primaryScore: primaryScore,
      // secondaryScore: secondScore,
      sensitiveScore: sensitiveScore,
        skinTypeMeaning: skinTypeMeaning,
        typePersonalizedInsight: typePersonalizedInsight
    );
  }

}

