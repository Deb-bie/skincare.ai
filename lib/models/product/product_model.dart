import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String name;
  final String? subtitle;
  final String? brandId;
  final String? brandName;
  final List<String>? categoryId;
  final List<String>? categoryNames;
  final String? description;
  final String? image;
  final List<String>? tags;
  final List<String>? skinType;
  final List<String>? keyIngredients;
  final String? steps;
  final bool? isCrueltyFree;
  final bool? isFragranceFree;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  ProductModel({
    this.id,
    required this.name,
    this.subtitle,
    this.brandId,
    this.brandName,
    this.categoryId = const [],
    this.categoryNames = const [],
    this.description,
    this.image,
    this.tags = const [],
    this.skinType = const [],
    this.keyIngredients = const [],
    this.steps,
    this.isCrueltyFree,
    this.isFragranceFree,
    this.createdAt,
    this.updatedAt
  });


  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    return ProductModel.fromJson({
      ...json,
      'id': doc.id,
    });
  }


  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      brandId: json['brandId'] ?? '',
      brandName: json['brandName'] ?? '',
      categoryId: List<String>.from(json['categoryId'] ?? []),
      categoryNames: List<String>.from(json['categoryNames'] ?? []),
      description: json['description'] ?? '',
      steps: json['steps'] ?? '',
      image: json['image'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      skinType: List<String>.from(json['skinType'] ?? []),
      keyIngredients: List<String>.from(json['keyIngredients'] ?? []),
      isCrueltyFree: json['isCrueltyFree'],
      isFragranceFree: json['isFragranceFree'],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'brandId': brandId,
      'brandName': brandName,
      'categoryId': categoryId?.toList(),
      'categoryNames': categoryNames?.toList(),
      'description': description,
      'image': image,
      'tags': tags?.toList(),
      'skinType': skinType?.toList(),
      'keyIngredients': keyIngredients?.toList(),
      'steps': steps,
      'isCrueltyFree': isCrueltyFree,
      'isFragranceFree': isFragranceFree,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }


  // copy method to update individual fields immutably
  ProductModel copyWith({
    String? name,
    String? subtitle,
    String? brandId,
    String? brandName,
    List<String>? categoryId,
    List<String>? categoryNames,
    String? description,
    String? image,
    List<String>? tags,
    List<String>? skinType,
    List<String>? keyIngredients,
    String? steps,
    bool? isCrueltyFree,
    bool? isFragranceFree,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
        id: id,
        name: name ?? this.name,
        subtitle: subtitle ?? this.subtitle,
        brandId: brandId ?? this.brandId,
        brandName: brandName ?? this.brandName,
        categoryId: categoryId ?? this.categoryId,
        categoryNames: categoryNames ?? this.categoryNames,
        description: description ?? this.description,
        image: image ?? this.image,
        tags: tags ?? this.tags,
        skinType: skinType ?? this.skinType,
        keyIngredients: keyIngredients ?? this.keyIngredients,
        steps: steps ?? this.steps,
        isCrueltyFree: isCrueltyFree ?? this.isCrueltyFree,
        isFragranceFree: isFragranceFree ?? this.isFragranceFree,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;

    // Firestore Timestamp
    if (value is Timestamp) {
      return value.toDate();
    }

    // Epoch millis
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    // ISO string
    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

}


class ProductRecommendation {
  final ProductModel product;
  final double compatibilityScore;
  final List<String> reasons;
  final String matchType;

  ProductRecommendation({
    required this.product,
    required this.compatibilityScore,
    required this.reasons,
    required this.matchType,
  });

  String get matchLabel {
    switch (matchType) {
      case 'perfect':
        return '🌟 Perfect Match';
      case 'great':
        return '✨ Great Match';
      case 'good':
        return '👍 Good Match';
      case 'alternative':
        return '💡 Alternative Option';
      default:
        return '';
    }
  }

}