import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product/product_model.dart';
import '../services/product/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel>? _products;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ProductModel>? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all products
  Future<void> fetchProducts({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.getAllProducts(forceRefresh: forceRefresh);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get product by ID
  ProductModel? getProductById(String productId) {
    if (_products == null) return null;

    try {
      return _products!.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Get multiple products by IDs
  List<ProductModel> getProductsByIds(List<String> productIds) {
    if (_products == null) return [];

    return _products!
        .where((product) => productIds.contains(product.id))
        .toList();
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      return await _productService.getProductsByCategory(category);
    } catch (e) {
      return [];
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategoryLocally(String category) async {
    try {
      return await _productService.getProductsByCategoryLocally(category);
    } catch (e) {
      return [];
    }
  }


  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      return await _productService.pickImage(source: source);
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  Future<String> uploadImage(File imageFile) async {
    try {
      return await _productService.uploadImage(imageFile);
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  Stream<double> uploadImageWithProgress(File imageFile) async* {
    try {
      yield* await _productService.uploadImageWithProgress(imageFile);
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  Future<String> createProduct(ProductModel product) async {
    try {
      return await _productService.createProduct(product);
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  Future<List<ProductModel>> getUserProducts() async {
    try {
      return await _productService.getUserProducts();
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  // Get products by category
  Future<List<ProductModel>> getUserProductsByCategoryLocally(String category) async {
    try {
      return await _productService.getUserProductsByCategoryLocally(category);
    } catch (e) {
      return [];
    }
  }


  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      await _productService.updateProduct(productId, updates);
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  Future<void> deleteProduct(String productId, String imageUrl) async {
    try {
      await _productService.deleteProduct(productId, imageUrl);
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  Future<List<String>> getUserCategories() async {
    try {
      return await _productService.getUserCategories();
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }


  // Clear cache and refetch
  Future<void> refreshProducts() async {
    await fetchProducts(forceRefresh: true);
  }
}

