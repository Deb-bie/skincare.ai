import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/product_categories.dart';
import '../../models/product/product_model.dart';


double opacityToAlpha(double opacity) => (opacity * 255);

Map<ProductCategory, List<ProductModel>> convertToProductMap(List<MapEntry<ProductCategory, ProductModel>> productsInOrder) {
  final result = <ProductCategory, List<ProductModel>>{};

  for (var entry in productsInOrder) {
    result.putIfAbsent(entry.key, () => []);
    result[entry.key]!.add(entry.value);
  }

  return result;
}


IconData getCategoryIcon(String? category) {
  if (category == null) return Icons.circle_outlined;

  final categoryLower = category.toLowerCase();

  if (categoryLower.contains('cleanser')) {
    return LucideIcons.soapDispenserDroplet;
  } else if (categoryLower.contains('toner')) {
    return Icons.waves_outlined;
  } else if (categoryLower.contains('essence')) {
    return Icons.blur_on_outlined;
  } else if (categoryLower.contains('serum')) {
    return Icons.science_outlined;
  } else if (categoryLower.contains('treatment')) {
    return Icons.healing_outlined;
  } else if (categoryLower.contains('eye')) {
    return Icons.visibility_outlined;
  } else if (categoryLower.contains('moisturizer') || categoryLower.contains('cream')) {
    return Icons.opacity_outlined;
  } else if (categoryLower.contains('oil')) {
    return Icons.water_outlined;
  } else if (categoryLower.contains('sunscreen') || categoryLower.contains('spf')) {
    return Icons.wb_sunny_outlined;
  } else if (categoryLower.contains('spot') || categoryLower.contains('acne')) {
    return Icons.stop_circle_outlined;
  } else if (categoryLower.contains('mask')) {
    return Icons.face_outlined;
  } else if (categoryLower.contains('exfoliator') || categoryLower.contains('peel')) {
    return Icons.spa_outlined;
  } else {
    return Icons.opacity_sharp;
  }
}


class UserPreferences {
  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_onboarding', true);
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', value);
  }

  static Future<void> setAssessmentComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_assessment', value);
  }

  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}


// Add this to your ProductCategoryOrder class or as a separate utility

class ProductCategoryHelper {
  // Map of display names to enum values
  static const Map<String, ProductCategory> _categoryMap = {
    'cleansers': ProductCategory.cleanser,
    'moisturizers': ProductCategory.moisturizer,
    'serums': ProductCategory.serum,
    'sunscreens': ProductCategory.sunscreen,
    'face masks': ProductCategory.faceMask,
    'eye creams': ProductCategory.eyeCream,
    'toners': ProductCategory.toner,
    'essences': ProductCategory.essence,
    'exfoliators': ProductCategory.exfoliator,
    'other': ProductCategory.other
  };

  // Convert string to ProductCategory enum
  static ProductCategory? fromDisplayName(String displayName) {
    final normalized = displayName.toLowerCase().trim();
    return _categoryMap[normalized];
  }

  // Get display name from enum
  static String toDisplayName(ProductCategory category) {
    return _categoryMap.entries
        .firstWhere(
          (entry) => entry.value == category,
      orElse: () => MapEntry('other', category),
    )
        .key
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // Get all available display names
  static List<String> getAllDisplayNames() {
    return _categoryMap.keys
        .map((key) => key.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' '))
        .toList();
  }
}