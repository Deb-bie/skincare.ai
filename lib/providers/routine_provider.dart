import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:myskiin/enums/product_categories.dart';

import '../enums/day_of_week.dart';
import '../enums/product_category.dart';
import '../enums/routine_type.dart';
import '../models/product/product_model.dart';
import '../models/routine/day_routine.dart';
import '../models/routine/routine_completion.dart';
import '../models/routine/weekly_routine.dart';
import '../services/data_manager/data_manager.dart';
import '../services/data_manager/hive_models/routines/hive_routine_completion.dart';
import '../services/data_manager/hive_models/routines/hive_routine_model.dart';


class RoutineProvider extends ChangeNotifier {
  final DataManager _dataManager = DataManager();
  HiveRoutineModel? _hiveRoutineModel;
  HiveRoutineModel? get routineData => _hiveRoutineModel;

  String? _currentUserId;

  WeeklyRoutine? _weeklyRoutine;
  final Map<String, RoutineCompletion> _completions = {};


  WeeklyRoutine? get weeklyRoutine => _weeklyRoutine;
  String? get currentUserId => _currentUserId;
  bool get isSynced => _weeklyRoutine?.isSynced ?? true;
  Map<String, RoutineCompletion> get completions => _completions;


  RoutineProvider() {
    initialize();
  }



  Future<void> initialize() async {
    _currentUserId = _dataManager.getOrCreateLocalUserId();
    _hiveRoutineModel = _dataManager.getOrCreateActiveRoutine();
    await _loadWeeklyRoutineFromHive();
    await reloadFromHive();
    notifyListeners();
  }


  Future<void> reloadFromHive() async {
    _hiveRoutineModel = _dataManager.getOrCreateActiveRoutine();
    await _loadWeeklyRoutineFromHive();
    notifyListeners();
  }


  Future<void> _loadWeeklyRoutineFromHive() async {
    if (_hiveRoutineModel == null) return;

    if (_hiveRoutineModel!.morningRoutinesJson != null ||
        _hiveRoutineModel!.eveningRoutinesJson != null) {

      final morningRoutines = <DayOfWeek, DayRoutine>{};
      final eveningRoutines = <DayOfWeek, DayRoutine>{};

      if (_hiveRoutineModel!.morningRoutinesJson != null) {
        final morningJson = Map<String, dynamic>.from(_hiveRoutineModel!.morningRoutinesJson!);
        morningJson.forEach((key, value) {
          final day = DayOfWeek.values.firstWhere(
                (d) => d.toString() == key,
            orElse: () => DayOfWeek.monday,
          );
          morningRoutines[day] = DayRoutine.fromJson(Map<String, dynamic>.from(value));
        });
      }

      if (_hiveRoutineModel!.eveningRoutinesJson != null) {
        final eveningJson = Map<String, dynamic>.from(_hiveRoutineModel!.eveningRoutinesJson!);
        eveningJson.forEach((key, value) {
          final day = DayOfWeek.values.firstWhere(
                (d) => d.toString() == key,
            orElse: () => DayOfWeek.monday,
          );
          eveningRoutines[day] = DayRoutine.fromJson(Map<String, dynamic>.from(value));
        });
      }

      _weeklyRoutine = WeeklyRoutine(
        userId: _currentUserId!,
        morningRoutines: morningRoutines,
        eveningRoutines: eveningRoutines,
        createdAt: _hiveRoutineModel!.createdAt,
        updatedAt: _hiveRoutineModel!.updatedAt,
        isSynced: _hiveRoutineModel!.isSynced,
      );
    }

    notifyListeners();
  }


  Future<void> _saveToStorage() async {
    if (_weeklyRoutine == null || _hiveRoutineModel == null) return;

    // Serialize morning routines
    final morningRoutinesJson = <String, dynamic>{};
    _weeklyRoutine!.morningRoutines.forEach((day, routine) {
      morningRoutinesJson[day.toString()] = routine.toJson();
    });

    // Serialize evening routines
    final eveningRoutinesJson = <String, dynamic>{};
    _weeklyRoutine!.eveningRoutines.forEach((day, routine) {
      eveningRoutinesJson[day.toString()] = routine.toJson();
    });

    // Serialize completions
    final completionsJson = <String, dynamic>{};
    _completions.forEach((key, completion) {
      completionsJson[key] = completion.toJson();
    });

    // Update Hive model
    _hiveRoutineModel!.morningRoutinesJson = morningRoutinesJson;
    _hiveRoutineModel!.eveningRoutinesJson = eveningRoutinesJson;
    _hiveRoutineModel!.completionsJson = completionsJson;
    _hiveRoutineModel!.updatedAt = DateTime.now();
    _hiveRoutineModel!.isSynced = false;

    // Save to Hive
    await _hiveRoutineModel!.save();
  }


  Future<void> saveInitialRoutine(Map<RoutineType, Map<ProductCategory, List<ProductModel>>> typeWithProducts) async {
    final now = DateTime.now();
    final morningRoutines = <DayOfWeek, DayRoutine>{};
    final eveningRoutines = <DayOfWeek, DayRoutine>{};

    for (var day in DayOfWeek.values) {
      // Morning routine
      if (typeWithProducts[RoutineType.morning]?.isNotEmpty ?? false) {
        final morningProducts = typeWithProducts[RoutineType.morning]!
            .values
            .expand((products) => products)
            .toList();

        morningRoutines[day] = DayRoutine(
          day: day,
          type: RoutineType.morning,
          products: morningProducts,
          stepsWithProducts: typeWithProducts[RoutineType.morning]!,
        );
      }

      // Evening routine
      if (typeWithProducts[RoutineType.evening]?.isNotEmpty ?? false) {
        final eveningProducts = typeWithProducts[RoutineType.evening]!
            .values
            .expand((products) => products)
            .toList();

        eveningRoutines[day] = DayRoutine(
          day: day,
          type: RoutineType.evening,
          products: eveningProducts,
          stepsWithProducts: typeWithProducts[RoutineType.evening]!,
        );
      }
    }

    // Create or update weekly routine with BOTH types
    _weeklyRoutine = WeeklyRoutine(
      userId: _currentUserId!,
      morningRoutines: morningRoutines,
      eveningRoutines: eveningRoutines,
      createdAt: _weeklyRoutine?.createdAt ?? now,
      updatedAt: now,
      isSynced: false,
    );

    await _saveToStorage();
    notifyListeners();
  }


  Future<void> updateDayRoutine(DayOfWeek day, RoutineType type, List<ProductModel> products, Map<RoutineType, Map<ProductCategory, List<ProductModel>>> typeWithProducts) async {
    if (_weeklyRoutine == null) return;

    final now = DateTime.now();
    final updatedRoutine = DayRoutine(
      day: day,
      type: type,
      products: products,
      stepsWithProducts: typeWithProducts[type]!,
    );

    if (type == RoutineType.morning) {
      final updatedMorningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.morningRoutines,
      );
      updatedMorningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        morningRoutines: updatedMorningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    } else {
      final updatedEveningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.eveningRoutines,
      );
      updatedEveningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        eveningRoutines: updatedEveningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    }

    await _saveToStorage();
    notifyListeners();
  }


  List<ProductModel> getDayRoutineProducts(DayOfWeek day, RoutineType type) {
    if (_weeklyRoutine == null) return [];

    final routine = type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines[day]
        : _weeklyRoutine!.eveningRoutines[day];


    return routine?.products ?? [];
  }


  DayRoutine? getDayRoutine(DayOfWeek day, RoutineType type) {
    if (_weeklyRoutine == null) return null;

    return type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines[day]
        : _weeklyRoutine!.eveningRoutines[day];
  }


  bool hasRoutineForDay(DayOfWeek day, RoutineType type) {
    if (_weeklyRoutine == null) return false;

    return type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines.containsKey(day)
        : _weeklyRoutine!.eveningRoutines.containsKey(day);
  }


  bool isProductInRoutine(ProductModel product, {RoutineType? type, DayOfWeek? day}) {
    if (_weeklyRoutine == null) return false;

    // Check specific day and type
    if (day != null && type != null) {
      final routine = type == RoutineType.morning
          ? _weeklyRoutine!.morningRoutines[day]
          : _weeklyRoutine!.eveningRoutines[day];

      return routine?.products.any((p) => p.id == product.id) ?? false;
    }

    // Check specific type across all days
    if (type != null) {
      final routines = type == RoutineType.morning
          ? _weeklyRoutine!.morningRoutines.values
          : _weeklyRoutine!.eveningRoutines.values;

      return routines.any((routine) =>
          routine.products.any((p) => p.id == product.id)
      );
    }

    // Check specific day across both types
    if (day != null) {
      final morningRoutine = _weeklyRoutine!.morningRoutines[day];
      final eveningRoutine = _weeklyRoutine!.eveningRoutines[day];

      final inMorning = morningRoutine?.products.any((p) => p.id == product.id) ?? false;
      final inEvening = eveningRoutine?.products.any((p) => p.id == product.id) ?? false;

      return inMorning || inEvening;
    }

    // Check entire weekly routine (all days, both types)
    final inMorning = _weeklyRoutine!.morningRoutines.values.any((routine) =>
        routine.products.any((p) => p.id == product.id)
    );

    final inEvening = _weeklyRoutine!.eveningRoutines.values.any((routine) =>
        routine.products.any((p) => p.id == product.id)
    );

    return inMorning || inEvening;
  }


  Future<void> addProductToRoutine(ProductModel product, ProductCategory category, RoutineType type) async {
    if (_weeklyRoutine == null) {
      final productMap = {category: [product]};
      final typeWithProducts = type == RoutineType.morning
          ? {
        RoutineType.morning: productMap,
        RoutineType.evening: <ProductCategory, List<ProductModel>>{}  // Add explicit type
      }
          : {
        RoutineType.morning: <ProductCategory, List<ProductModel>>{},  // Add explicit type
        RoutineType.evening: productMap
      };

      await saveInitialRoutine(typeWithProducts);
      return;
    }

    final now = DateTime.now();

    // Update all days for the specified routine type
    for (var day in DayOfWeek.values) {
      final existingRoutine = type == RoutineType.morning
          ? _weeklyRoutine!.morningRoutines[day]
          : _weeklyRoutine!.eveningRoutines[day];

      // Get existing products and steps
      final existingProducts = existingRoutine?.products ?? [];
      final existingSteps = existingRoutine?.stepsWithProducts ?? {};

      // Check if product already exists
      final productExists = existingProducts.any((p) => p.id == product.id);

      // Add or update the product
      var updatedProducts = productExists
          ? existingProducts.map((p) => p.id == product.id ? product : p).toList()
          : [...existingProducts, product];

      // Sort products by category order
      updatedProducts = _sortProductsByCategory(updatedProducts);

      // Update steps with products
      final updatedSteps = Map<ProductCategory, List<ProductModel>>.from(existingSteps);

      if (updatedSteps.containsKey(category)) {
        // Check if product already exists in this category
        final categoryProducts = updatedSteps[category]!;
        final existsInCategory = categoryProducts.any((p) => p.id == product.id);

        if (existsInCategory) {
          updatedSteps[category] = categoryProducts
              .map((p) => p.id == product.id ? product : p)
              .toList();
        } else {
          updatedSteps[category] = [...categoryProducts, product];
        }
      } else {
        updatedSteps[category] = [product];
      }

      // Sort steps by category order
      final sortedSteps = _sortStepsByCategory(updatedSteps);

      // Create updated routine
      final updatedRoutine = DayRoutine(
        day: day,
        type: type,
        products: updatedProducts,
        stepsWithProducts: sortedSteps,
      );


      // Update the weekly routine
      if (type == RoutineType.morning) {
        final updatedMorningRoutines = Map<DayOfWeek, DayRoutine>.from(
          _weeklyRoutine!.morningRoutines,
        );
        updatedMorningRoutines[day] = updatedRoutine;

        _weeklyRoutine = _weeklyRoutine!.copyWith(
          morningRoutines: updatedMorningRoutines,
          updatedAt: now,
          isSynced: false,
        );
      } else {
        final updatedEveningRoutines = Map<DayOfWeek, DayRoutine>.from(
          _weeklyRoutine!.eveningRoutines,
        );
        updatedEveningRoutines[day] = updatedRoutine;

        _weeklyRoutine = _weeklyRoutine!.copyWith(
          eveningRoutines: updatedEveningRoutines,
          updatedAt: now,
          isSynced: false,
        );
      }
    }

    await _saveToStorage();
    notifyListeners();
  }


  Future<void> addProductsToRoutine(List<ProductModel> products, ProductCategory category, RoutineType type, DayOfWeek day) async {
    if (_weeklyRoutine == null) {

      // Create initial routine with all products
      final productMap = {category: products};
      final dayRoutine = DayRoutine(
        day: day,
        type: type,
        products: products,
        stepsWithProducts: productMap,
      );

      final morningRoutines = type == RoutineType.morning
          ? {day: dayRoutine}
          : <DayOfWeek, DayRoutine>{};

      final eveningRoutines = type == RoutineType.evening
          ? {day: dayRoutine}
          : <DayOfWeek, DayRoutine>{};

      _weeklyRoutine = WeeklyRoutine(
        morningRoutines: morningRoutines,
        eveningRoutines: eveningRoutines,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await _saveToStorage();
      notifyListeners();
      return;
    }

    final now = DateTime.now();

    // Get existing routine for this day
    final existingRoutine = type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines[day]
        : _weeklyRoutine!.eveningRoutines[day];

    final existingProducts = existingRoutine?.products ?? [];
    final existingSteps = existingRoutine?.stepsWithProducts ?? {};

    // Merge products (avoid duplicates)
    final existingProductIds = existingProducts.map((p) => p.id).toSet();
    final newProducts = products.where((p) => !existingProductIds.contains(p.id)).toList();
    final updatedProducts = [...existingProducts, ...newProducts];

    // Update steps with products
    final updatedSteps = Map<ProductCategory, List<ProductModel>>.from(existingSteps);

    if (updatedSteps.containsKey(category)) {
      final categoryProducts = updatedSteps[category]!;
      final categoryProductIds = categoryProducts.map((p) => p.id).toSet();
      final newCategoryProducts = products.where((p) => !categoryProductIds.contains(p.id)).toList();
      updatedSteps[category] = [...categoryProducts, ...newCategoryProducts];
    } else {
      updatedSteps[category] = products;
    }

    // Create updated routine
    final updatedRoutine = DayRoutine(
      day: day,
      type: type,
      products: updatedProducts,
      stepsWithProducts: updatedSteps,
    );

    // Update weekly routine
    if (type == RoutineType.morning) {
      final updatedMorningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.morningRoutines,
      );
      updatedMorningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        morningRoutines: updatedMorningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    } else {
      final updatedEveningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.eveningRoutines,
      );
      updatedEveningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        eveningRoutines: updatedEveningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    }

    await _saveToStorage();
    notifyListeners();
  }


  // Sort products by their category order
  List<ProductModel> _sortProductsByCategory(List<ProductModel> products) {
    final sorted = [...products];
    sorted.sort((a, b) {
      final aCategoryString = a.categoryId?.firstOrNull;
      final bCategoryString = b.categoryId?.firstOrNull;
      final aCategory = ProductCategoryOrder.fromString(aCategoryString) ?? ProductCategory.other;
      final bCategory = ProductCategoryOrder.fromString(bCategoryString) ?? ProductCategory.other;
      final aOrder = ProductCategoryOrder.getOrder(aCategory);
      final bOrder = ProductCategoryOrder.getOrder(bCategory);
      return aOrder.compareTo(bOrder);
    });
    return sorted;
  }


  // Sort the stepsWithProducts map by category order
  Map<ProductCategory, List<ProductModel>> _sortStepsByCategory(Map<ProductCategory, List<ProductModel>> steps) {
    final sortedKeys = ProductCategoryOrder.getSortedCategories(steps.keys);
    final sortedMap = <ProductCategory, List<ProductModel>>{};

    for (var key in sortedKeys) {
      sortedMap[key] = steps[key]!;
    }

    return sortedMap;
  }


  Future<void> addCategoryToRoutine(ProductCategory category, RoutineType type, DayOfWeek day) async {
    if (_weeklyRoutine == null) {

      // Create initial routine with empty category
      final productMap = {category: <ProductModel>[]};
      final dayRoutine = DayRoutine(
        day: day,
        type: type,
        products: [],
        stepsWithProducts: productMap,
      );

      final morningRoutines = type == RoutineType.morning
          ? {day: dayRoutine}
          : <DayOfWeek, DayRoutine>{};

      final eveningRoutines = type == RoutineType.evening
          ? {day: dayRoutine}
          : <DayOfWeek, DayRoutine>{};

      _weeklyRoutine = WeeklyRoutine(
        morningRoutines: morningRoutines,
        eveningRoutines: eveningRoutines,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await _saveToStorage();
      notifyListeners();
      return;
    }

    final now = DateTime.now();

    // Get existing routine for this specific day
    final existingRoutine = type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines[day]
        : _weeklyRoutine!.eveningRoutines[day];

    // Get existing steps
    final existingSteps = existingRoutine?.stepsWithProducts ?? {};

    // Check if category already exists
    if (existingSteps.containsKey(category)) {
      return;
    }

    // Add empty category
    final updatedSteps = Map<ProductCategory, List<ProductModel>>.from(existingSteps);
    updatedSteps[category] = [];

    // Sort steps by category order
    final sortedSteps = _sortStepsByCategory(updatedSteps);

    // Products list stays the same since we're just adding an empty category
    final existingProducts = existingRoutine?.products ?? [];

    // Create updated routine
    final updatedRoutine = DayRoutine(
      day: day,
      type: type,
      products: existingProducts,
      stepsWithProducts: sortedSteps,
    );

    // Update the weekly routine
    if (type == RoutineType.morning) {
      final updatedMorningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.morningRoutines,
      );
      updatedMorningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        morningRoutines: updatedMorningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    } else {
      final updatedEveningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.eveningRoutines,
      );
      updatedEveningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        eveningRoutines: updatedEveningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    }

    await _saveToStorage();
    notifyListeners();
  }


  Future<void> removeCategoryFromRoutine(ProductCategory category, RoutineType type, DayOfWeek day) async {
    if (_weeklyRoutine == null) return;

    final now = DateTime.now();

    // Get existing routine for this specific day
    final existingRoutine = type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines[day]
        : _weeklyRoutine!.eveningRoutines[day];

    if (existingRoutine == null) return;

    // Get existing steps and products
    final existingSteps = existingRoutine.stepsWithProducts;
    final existingProducts = existingRoutine.products;

    // Check if category exists
    if (!existingSteps.containsKey(category)) {
      return;
    }

    // Get products that belong to this category
    final categoryProducts = existingSteps[category] ?? [];
    final categoryProductIds = categoryProducts.map((p) => p.id).toSet();

    // Remove category from steps
    final updatedSteps = Map<ProductCategory, List<ProductModel>>.from(existingSteps);
    updatedSteps.remove(category);

    // Remove products that belong to this category from the products list
    final updatedProducts = existingProducts
        .where((p) => !categoryProductIds.contains(p.id))
        .toList();

    // Create updated routine
    final updatedRoutine = DayRoutine(
      day: day,
      type: type,
      products: updatedProducts,
      stepsWithProducts: updatedSteps,
    );

    // Update the weekly routine
    if (type == RoutineType.morning) {
      final updatedMorningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.morningRoutines,
      );
      updatedMorningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        morningRoutines: updatedMorningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    } else {
      final updatedEveningRoutines = Map<DayOfWeek, DayRoutine>.from(
        _weeklyRoutine!.eveningRoutines,
      );
      updatedEveningRoutines[day] = updatedRoutine;

      _weeklyRoutine = _weeklyRoutine!.copyWith(
        eveningRoutines: updatedEveningRoutines,
        updatedAt: now,
        isSynced: false,
      );
    }

    await _saveToStorage();
    notifyListeners();
  }


  bool hasCategoryInRoutine(ProductCategory category, RoutineType type, DayOfWeek day,) {
    if (_weeklyRoutine == null) return false;

    final routine = type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines[day]
        : _weeklyRoutine!.eveningRoutines[day];

    return routine?.stepsWithProducts.containsKey(category) ?? false;
  }


  List<ProductCategory> getAvailableCategories(RoutineType type, DayOfWeek day) {
    if (_weeklyRoutine == null) {
      return ProductCategory.values;
    }

    final routine = type == RoutineType.morning
        ? _weeklyRoutine!.morningRoutines[day]
        : _weeklyRoutine!.eveningRoutines[day];

    if (routine == null) {
      return ProductCategory.values;
    }

    // Return categories that are not yet in the routine
    final existingCategories = routine.stepsWithProducts.keys.toSet();
    return ProductCategory.values
        .where((category) => !existingCategories.contains(category))
        .toList();
  }


  bool isProductSkipped(DateTime date, RoutineType type, String productId) {
    final completion = _dataManager.getCompletion(date, type);
    return completion?.skippedProductIds.contains(productId) ?? false;
  }


  // Get completion key for a specific date and routine type
  String _getCompletionKey(DateTime date, RoutineType type) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return '${dateOnly.toIso8601String().split('T')[0]}_${type.name}';
  }


  // Helper to convert DateTime to DayOfWeek
  DayOfWeek getDayOfWeekFromDate(DateTime date) {
    switch (date.weekday % 7) {
      case 0:
        return DayOfWeek.sunday;
      case 1:
        return DayOfWeek.monday;
      case 2:
        return DayOfWeek.tuesday;
      case 3:
        return DayOfWeek.wednesday;
      case 4:
        return DayOfWeek.thursday;
      case 5:
        return DayOfWeek.friday;
      case 6:
        return DayOfWeek.saturday;
      default:
        return DayOfWeek.sunday;
    }
  }



  Future<void> toggleProductCompletion(
      DateTime date,
      RoutineType type,
      String productId,
      ) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final key = _getCompletionKey(date, type);
    final dayOfWeek = getDayOfWeekFromDate(date);
    final routine = getDayRoutine(dayOfWeek, type);
    final totalProducts = routine?.products.length ?? 0;

    // Get existing completion from Hive
    var completion = _dataManager.getCompletion(date, type);


    if (completion != null) {
      // Update existing completion
      final updatedIds = List<String>.from(completion.completedProductIds);
      final skippedIds = completion.skippedProductIds;

      // Can't complete a skipped product
      if (skippedIds.contains(productId)) {
        return;
      }

      if (updatedIds.contains(productId)) {
        updatedIds.remove(productId);
      } else {
        updatedIds.add(productId);
      }

      // Calculate active products
      final activeProducts = totalProducts - skippedIds.length;

      // Mark completion time when all products are checked
      DateTime? completedAt = completion.completedAt;
      if (activeProducts > 0 && updatedIds.length >= activeProducts) {
        completedAt = DateTime.now();
      } else if (updatedIds.length < activeProducts) {
        completedAt = null;
      }

      completion.completedProductIds = updatedIds;
      completion.completedAt = completedAt;
      completion.totalProducts = totalProducts;
      completion.updatedAt = DateTime.now();
      completion.isSynced = false;
    } else {
      // Create new completion
      completion = HiveRoutineCompletion(
        id: key,
        localUserId: _currentUserId!,
        date: dateOnly,
        routineType: type.name,
        completedProductIds: [productId],
        skippedProductIds: [],
        totalProducts: totalProducts,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );
    }

    await _dataManager.saveCompletion(completion);
    notifyListeners();

  }


  // Check if a product is completed for a specific date
  bool isProductCompleted(DateTime date, RoutineType type, String productId) {
    final completion = _dataManager.getCompletion(date, type);
    return completion?.completedProductIds.contains(productId) ?? false;
  }


  int getCompletedSteps(DateTime date, RoutineType type) {
    final completion = _dataManager.getCompletion(date, type);
    return completion?.completedProductIds.length ?? 0;
  }


  Future<void> resetCompletions(DateTime date, RoutineType type) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final key = '${dateOnly.toIso8601String().split('T')[0]}_${type.name}';
    await _dataManager.deleteCompletion(key);

    notifyListeners();
  }


  // Get completion percentage
  double getCompletionPercentage(DateTime date, RoutineType type) {
    final total = getTotalSteps(date, type);
    if (total == 0) return 0.0;
    final completed = getCompletedSteps(date, type);
    return completed / total;
  }


  // Get history for a date range
  List<HiveRoutineCompletion> getHistoryForDateRange(DateTime startDate, DateTime endDate) {
    return _dataManager.getCompletionsInRange(startDate, endDate);
  }


  List<HiveRoutineCompletion> getMonthHistory(int year, int month) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    return getHistoryForDateRange(startDate, endDate);
  }


  int getCurrentStreak() {
    final now = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final morningCompletion = _dataManager.getCompletion(date, RoutineType.morning);
      final eveningCompletion = _dataManager.getCompletion(date, RoutineType.evening);

      final morningComplete = morningCompletion?.isFullyCompleted ?? false;
      final eveningComplete = eveningCompletion?.isFullyCompleted ?? false;

      if (morningComplete || eveningComplete) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }


  int getLongestStreak() {
    final allCompletions = _dataManager.getAllCompletions();
    if (allCompletions.isEmpty) return 0;

    final sortedDates = allCompletions
        .map((c) => c.date)
        .toSet()
        .toList()
      ..sort();

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (var date in sortedDates) {
      final morningCompletion = _dataManager.getCompletion(date, RoutineType.morning);
      final eveningCompletion = _dataManager.getCompletion(date, RoutineType.evening);

      final morningComplete = morningCompletion?.isFullyCompleted ?? false;
      final eveningComplete = eveningCompletion?.isFullyCompleted ?? false;

      if (morningComplete || eveningComplete) {
        if (lastDate == null || date.difference(lastDate).inDays == 1) {
          currentStreak++;
        } else {
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
          currentStreak = 1;
        }
        lastDate = date;
      }
    }

    return currentStreak > longestStreak ? currentStreak : longestStreak;
  }



  // Get completion statistics
  Map<String, dynamic> getStatistics({int days = 30}) {
    final now = DateTime.now();
    int totalRoutines = 0;
    int completedRoutines = 0;
    int partiallyCompleted = 0;

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));

      for (var type in RoutineType.values) {
        final dayOfWeek = getDayOfWeekFromDate(date);
        final routine = getDayRoutine(dayOfWeek, type);

        if (routine != null && routine.products.isNotEmpty) {
          totalRoutines++;

          final completion = _dataManager.getCompletion(date, type);

          if (completion != null) {
            if (completion.isFullyCompleted) {
              completedRoutines++;
            } else if (completion.completedProductIds.isNotEmpty) {
              partiallyCompleted++;
            }
          }
        }
      }
    }

    return {
      'totalRoutines': totalRoutines,
      'completedRoutines': completedRoutines,
      'partiallyCompleted': partiallyCompleted,
      'completionRate': totalRoutines > 0
          ? (completedRoutines / totalRoutines * 100).toStringAsFixed(1)
          : '0.0',
      'currentStreak': getCurrentStreak(),
      'longestStreak': getLongestStreak(),
    };
  }



  // Get completion data for calendar heatmap
  Map<DateTime, double> getHeatmapData(DateTime startDate, DateTime endDate) {
    final heatmapData = <DateTime, double>{};

    for (var date = startDate;
    date.isBefore(endDate.add(const Duration(days: 1)));
    date = date.add(const Duration(days: 1))) {

      final morningCompletion = _dataManager.getCompletion(date, RoutineType.morning);
      final eveningCompletion = _dataManager.getCompletion(date, RoutineType.evening);

      double dayCompletion = 0;
      int routineCount = 0;

      if (morningCompletion != null && morningCompletion.totalProducts > 0) {
        dayCompletion += morningCompletion.completionPercentage;
        routineCount++;
      }
      if (eveningCompletion != null && eveningCompletion.totalProducts > 0) {
        dayCompletion += eveningCompletion.completionPercentage;
        routineCount++;
      }

      if (routineCount > 0) {
        heatmapData[date] = dayCompletion / routineCount;
      }
    }

    return heatmapData;
  }


  // Toggle product skip status for a specific date
  Future<void> toggleProductSkip(
      DateTime date,
      RoutineType type,
      String productId,
      ) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final key = '${dateOnly.toIso8601String().split('T')[0]}_${type.name}';

    final dayOfWeek = getDayOfWeekFromDate(date);
    final routine = getDayRoutine(dayOfWeek, type);
    final totalProducts = routine?.products.length ?? 0;

    var completion = _dataManager.getCompletion(date, type);

    if (completion != null) {
      final updatedSkipped = List<String>.from(completion.skippedProductIds);
      final updatedCompleted = List<String>.from(completion.completedProductIds);

      if (updatedSkipped.contains(productId)) {
        updatedSkipped.remove(productId);
      } else {
        updatedSkipped.add(productId);
        updatedCompleted.remove(productId);
      }

      final activeProducts = totalProducts - updatedSkipped.length;
      DateTime? completedAt = completion.completedAt;
      if (activeProducts > 0 && updatedCompleted.length >= activeProducts) {
        completedAt = DateTime.now();
      } else {
        completedAt = null;
      }

      completion.completedProductIds = updatedCompleted;
      completion.skippedProductIds = updatedSkipped;
      completion.completedAt = completedAt;
      completion.totalProducts = totalProducts;
      completion.updatedAt = DateTime.now();
      completion.isSynced = false;
    } else {
      completion = HiveRoutineCompletion(
        id: key,
        localUserId: _currentUserId!,
        date: dateOnly,
        routineType: type.name,
        completedProductIds: [],
        skippedProductIds: [productId],
        totalProducts: totalProducts,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );
    }

    await _dataManager.saveCompletion(completion);
    notifyListeners();

  }


  // Update getTotalSteps to exclude skipped products
  int getTotalSteps(DateTime date, RoutineType type) {
    final dayOfWeek = getDayOfWeekFromDate(date);
    final routine = getDayRoutine(dayOfWeek, type);
    if (routine == null) return 0;

    return routine.products.length;

  }


}

