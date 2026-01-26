import 'package:myskiin/services/product/product_service.dart';

import '../../models/product/product_model.dart';

class ProductMatchingService {

  final ProductService _productService = ProductService();

  Future<List<ProductModel>> _getProducts() async {
    return await _productService.getAllProducts();
  }


  Future<ProductModel?> findBestProduct({
    required String category,
    required String skinType,
    required List<String> concerns,
    List<String>? preferredBrands,
    List<String>? avoidIngredients
  }) async {

    final allProducts = await _getProducts();
    var filteredProducts = allProducts.where((p) =>
        p.categoryNames!.any((cat) => cat.toLowerCase() == category.toLowerCase())
    ).toList();

    if (filteredProducts.isEmpty) return null;

    Map<ProductModel, double> productScores = {};

    for (var product in filteredProducts) {
      double score = 0;

      if (product.skinType!.any((type) =>
      type.toLowerCase() == skinType.toLowerCase())) {
        score += 10;
      }

      if (preferredBrands != null && preferredBrands.isNotEmpty) {
        if (preferredBrands.any((brand) =>
        product.brandName!.toLowerCase() == brand.toLowerCase())) {
          score += 3;
        }
      }

      if (avoidIngredients != null && avoidIngredients.isNotEmpty) {
        bool hasAvoidIngredient = product.keyIngredients!.any((ingredient) =>
            avoidIngredients.any((avoid) =>
                ingredient.toLowerCase().contains(avoid.toLowerCase())));

        if (hasAvoidIngredient) {
          continue;
        }
      }

      if (product.skinType!.length > 2) {
        score += 1;
      }
      productScores[product] = score;
    }


    if (productScores.isEmpty) return null;

    var sortedProducts = productScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedProducts.first.key;
  }


  Future<List<ProductModel>> findProductsWithAlternatives({required String category, required String skinType, required List<String> concerns, List<String>? preferredBrands, int limit = 3, List<ProductModel>? excludeProducts, }) async {
    final allProducts = await _getProducts();

    var filteredProducts = allProducts.where((p) =>
        p.categoryNames!.any((cat) => cat.toLowerCase() == category.toLowerCase()) &&
            (excludeProducts == null || !excludeProducts.any((ex) => ex.id == p.id))
    ).toList();

    if (filteredProducts.isEmpty) return [];

    Map<ProductModel, double> productScores = {};

    for (var product in filteredProducts) {
      double score = 0;

      if (product.skinType!.any((type) =>
      type.toLowerCase() == skinType.toLowerCase())) {
        score += 10;
      }

      if (preferredBrands != null && preferredBrands.isNotEmpty) {
        if (preferredBrands.any((brand) =>
        product.brandName!.toLowerCase() == brand.toLowerCase())) {
          score += 3;
        }
      }

      productScores[product] = score;
    }

    var sortedProducts = productScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedProducts
        .take(limit)
        .map((e) => e.key)
        .toList();
  }

}

