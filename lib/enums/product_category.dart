import 'package:myskiin/enums/product_categories.dart';

class ProductCategoryOrder {
  static const Map<ProductCategory, int> order = {
    ProductCategory.cleanser: 1,
    ProductCategory.exfoliator: 2,
    ProductCategory.toner: 3,
    ProductCategory.essence: 4,
    ProductCategory.serum: 5,
    ProductCategory.faceMask: 6,
    ProductCategory.eyeCream: 7,
    ProductCategory.moisturizer: 8,
    ProductCategory.sunscreen: 9,
    // ProductCategory.other: 10
  };

  static ProductCategory? fromString(String? categoryString) {
    if (categoryString == null) return null;

    try {
      return ProductCategory.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == categoryString.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static int getOrder(ProductCategory category) {
    return order[category] ?? 999; // Default to end if not found
  }

  static List<ProductCategory> getSortedCategories(Iterable<ProductCategory> categories) {
    final list = categories.toList();
    list.sort((a, b) => getOrder(a).compareTo(getOrder(b)));
    return list;
  }
}