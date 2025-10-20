import '../product/product_model.dart';

class RoutineModel {
  final String name;
  final Map<String, List<ProductModel>> productsByCategory;

  RoutineModel({
    required this.name,
    required this.productsByCategory
  });

  // factory method to receive json data
  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      name: json['name'],
      productsByCategory: (json['productsByCategory'] as Map<String, dynamic>?)
          ?.map((category, productList) {
        final products = (productList as List)
            .map((p) => ProductModel.fromJson(Map<String, dynamic>.from(p)))
            .toList();
        return MapEntry(category, products);
      }) ??
          {},
    );
  }


  // factory for sending routines
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'productsByCategory': productsByCategory.map((category, products) {
        return MapEntry(
          category,
          products.map((p) => p.toJson()).toList(),
        );
      }),
    };
  }
}