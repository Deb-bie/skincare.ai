import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myskiin/core/utils/app_logger.dart';
import '../../models/product/product_model.dart';


class ProductService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';
  final ImagePicker _picker = ImagePicker();
  List<ProductModel>? _cachedProducts;
  DateTime? _cacheTime;
  final Duration _cacheDuration = Duration(days: 7);


  Future<List<ProductModel>> getAllProducts({bool forceRefresh = false}) async {
    if (_cachedProducts != null && !forceRefresh && _cacheTime != null) {
      final now = DateTime.now();
      if (now.difference(_cacheTime!) < _cacheDuration) {
        return _cachedProducts!;
      }
    }

    try {
      final snapshot = await _firestore
          .collection(_collection)
          .get();

      var products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      _cachedProducts = products;

      _cacheTime = DateTime.now();
      return products;
    } catch (e) {
      AppLogger.error('Error fetching all products: $e');
      return _cachedProducts ?? [];

    }
  }


  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('categoryNames', arrayContains: category.toLowerCase())
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching products by category: $e');
      return [];
    }
  }


  Future<List<ProductModel>> getProductsBySkinType(String skinType) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('skinType', arrayContains: skinType.toLowerCase())
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching products by skin type: $e');
      return [];
    }
  }


  Future<List<ProductModel>> getProductsByConcern(String concern) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('skinConcerns', arrayContains: concern.toLowerCase())
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching products by concern: $e');
      return [];
    }
  }


  Future<List<ProductModel>> getProductsByBrand(String brand) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('brandName', isEqualTo: brand.toLowerCase())
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching products by brand: $e');
      return [];
    }
  }


  Future<List<ProductModel>> getProductsByCategoryLocally(String categoryName) async {
    final allProducts = await getAllProducts();

    final filteredProducts = allProducts
        .where((product) => product.categoryNames!.contains(categoryName))
        .toList();

    return filteredProducts;
  }



  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to pick image: $e');
      throw Exception('Failed to pick image: $e');
    }
  }


  Future<String> uploadImage(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      // Validate file size (5MB max)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('Image must be less than 5MB');
      }

      // Create unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_${imageFile.path.split('/').last}';
      final storageRef = _storage.ref().child('user_added_products/${user.uid}/$fileName');

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }



  Stream<double> uploadImageWithProgress(File imageFile) async* {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_${imageFile.path.split('/').last}';
      final storageRef = _storage.ref().child('userproducts/${user.uid}/$fileName');

      final uploadTask = storageRef.putFile(imageFile);

      await for (final snapshot in uploadTask.snapshotEvents) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        yield progress;
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }


  Future<String> createProduct(ProductModel product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      final now = DateTime.now();
      final products = ProductModel(
        name: product.name,
        brandName: product.brandName,
        keyIngredients: product.keyIngredients,
        description: product.description,
        categoryNames: product.categoryNames,
        image: product.image,
        createdAt: now,
        updatedAt: now,
      );


      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection("user_added_products")
          .add(products.toJson());

      await docRef.update({
        'serverCheck': FieldValue.serverTimestamp(),
      });


      final snap = await docRef.get(const GetOptions(source: Source.server));
      return docRef.id;

    } catch (e) {
      AppLogger.error('Failed to create product: $e');
      throw Exception('Failed to create product: $e');
    }
  }


  // Upload product with image
  Future<String> uploadProduct({
    required File imageFile,
    required String name,
    required String? brandName,
    required List<String>? keyIngredients,
    String description = '',
    List<String> categoryNames = const [],
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      // Upload image first
      final imageUrl = await uploadImage(imageFile);

      // Create product document
      final product = ProductModel(
        name: name,
        brandName: brandName,
        keyIngredients: keyIngredients,
        description: description,
        categoryNames: categoryNames,
        image: imageUrl
      );

      final productId = await createProduct(product);
      return productId;
    } catch (e) {
      throw Exception('Failed to upload product: $e');
    }
  }


  Future<List<ProductModel>> getUserProducts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('user_added_products')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();

    } catch (e) {
      AppLogger.error('Error fetching user products: $e');
      return [];
    }
  }


  Future<List<ProductModel>> getUserProductsByCategoryLocally(String categoryName) async {
    final allProducts = await getUserProducts();

    final filteredProducts = allProducts
        .where((product) => product.categoryNames!.contains(categoryName))
        .toList();

    return filteredProducts;
  }



  Future<List<String>> getUserCategories() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }

      final snapshot = await _firestore
          .collection('usercategories')
          .where('userId', isEqualTo: user.uid)
          .get();

      return snapshot.docs.map((doc) {
        try {
          return "";
        } catch (e) {
          AppLogger.error("Error parsing doc ${doc.id}: $e");
          rethrow;
        }
      }).toList();

    } catch (e) {
      AppLogger.error('Error fetching products by user: $e');
      return [];
    }
  }


  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection('users/${user.uid}/user_added_products')
          .doc(productId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }


  Future<void> deleteProduct(String productId, String imageUrl) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated');
      }

      if (imageUrl.isNotEmpty) {
        try {
          final ref = _storage.refFromURL(imageUrl);
          await ref.delete();
        } catch (e) {
          AppLogger.error('Error deleting image: $e');
        }
      }

      await _firestore
          .collection('users/${user.uid}/user_added_products')
          .doc(productId)
          .delete();

    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }


  void clearCache() {
    _cachedProducts = null;
    _cacheTime = null;
  }


  Future<List<ProductModel>> refreshProducts() async {
    clearCache();
    return getAllProducts(forceRefresh: true);
  }

}

