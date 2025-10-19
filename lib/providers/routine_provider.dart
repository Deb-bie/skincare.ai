import 'package:flutter/foundation.dart';
import 'package:skincareai/models/routine/routine_model.dart';

import '../models/product/product_model.dart';

class RoutineProvider extends ChangeNotifier {
  String? _userId;
  final Map<String, Map<String, RoutineModel>> _userRoutines = {};

  // set the current user (call this after login)
  void setUser(String userId) {
    _userId = userId;
    _userRoutines.putIfAbsent(userId, () => {});
    notifyListeners();
  }

  // clear user data on logout
  void clearUser() {
    _userId = null;
    notifyListeners();
  }


  // get currentUserRoutine based on timeOfDay
  RoutineModel? getCurrentUserRoutine(String timeOfDay) {
    if (_userId == null) return null;

    final userRoutinesForUser = _userRoutines[_userId];
    if (userRoutinesForUser == null) return null;

    return userRoutinesForUser[timeOfDay];
  }

  // add product
  void addToRoutine(ProductModel product, String timeOfDay) {
    if (_userId == null) return;

    // Get or initialize the user's routines
    _userRoutines[_userId!] ??= {};

    // Get or initialize the specific routine (morning/evening)
    _userRoutines[_userId]![timeOfDay] ??= RoutineModel(
      name: timeOfDay,
      productsByCategory: {},
    );

    final routine = _userRoutines[_userId]![timeOfDay]!;

    final category = product.category;

    // Add product to all its categories
    for (var cat in product.category) {
      routine.productsByCategory[cat] ??= [];
      final categoryList = routine.productsByCategory[cat]!;

      if (!categoryList.any((p) => p.id == product.id)) {
        categoryList.add(product);
      }
    }
    // Notify listeners if using Provider or setState
    notifyListeners();
  }


  // check if product is in user’s routine
  bool isInRoutine(ProductModel product, String timeOfDay) {
    if (_userId == null) return false;

    // Get all routines for current user
    final userRoutinesForUser = _userRoutines[_userId];
    if (userRoutinesForUser == null) return false;

    // Get the routine for the specified time of day
    final routine = userRoutinesForUser[timeOfDay];
    if (routine == null) return false;

    // Check if category exists
    return product.category.any((cat) {
      if (!routine.productsByCategory.containsKey(cat)) return false;

    //   check if the product exists in the category set
      return routine.productsByCategory[cat]!.any((p) => p.id == product.id);
    }
    );
  }

}

