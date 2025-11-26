import '../../enums/day_of_week.dart';
import '../../enums/product_categories.dart';
import '../../enums/routine_type.dart';
import '../product/mini.dart';

class DayRoutine {
  final DayOfWeek day;
  final RoutineType type;
  final List<Product> products;
  final Map<ProductCategory, List<Product>> stepsWithProducts;

  DayRoutine({
    required this.day,
    required this.type,
    required this.products,
    required this.stepsWithProducts,
  });

  Map<String, dynamic> toJson() => {
    'day': day.toString(),
    'type': type.toString(),
    'products': products.map((p) => p.toJson()).toList(),
    'stepsWithProducts': stepsWithProducts.map(
          (category, products) => MapEntry(
            category.name, products.map(
                  (p) => p.toJson()
          ).toList()
          ),
    ),
  };

  factory DayRoutine.fromJson(Map<String, dynamic> json) => DayRoutine(
    day: DayOfWeek.values.firstWhere(
          (d) => d.toString() == json['day'],
    ),
    type: json['type'] == 'RoutineType.morning'
        ? RoutineType.morning
        : RoutineType.evening,
    products: (json['products'] as List)
        .map((p) => Product.fromJson(p))
        .toList(),
    stepsWithProducts: (json['stepsWithProducts'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
        ProductCategory.values.firstWhere((e) => e.name == key),
        (value as List).map((p) => Product.fromJson(p)).toList(),
      ),
    ),
  );

  DayRoutine copyWith({
    DayOfWeek? day,
    RoutineType? type,
    List<Product>? products,
    Map<ProductCategory, List<Product>>? stepsWithProducts,
  }) {
    return DayRoutine(
      day: day ?? this.day,
      type: type ?? this.type,
      products: products ?? this.products,
      stepsWithProducts: stepsWithProducts ?? this.stepsWithProducts,
    );
  }
}

