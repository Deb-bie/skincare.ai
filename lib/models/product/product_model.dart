class ProductModel {
  final String id;
  final String name;
  final String subtitle;
  final String brand;
  final String description;
  final String image;
  final Set<String> tags;
  final Set<String> skinTypes;
  final Set<String> keyIngredients;
  final Set<String> category;
  final List<String> steps;

  ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.brand,
    required this.description,
    required this.image,
    this.tags = const {},
    this.skinTypes = const {},
    this.keyIngredients = const {},
    this.category = const {},
    this.steps = const []
  });


//   factory method to receive json data
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        subtitle: json['subtitle'] ?? '',
        brand: json['brand'] ?? '',
        description: json['description'] ?? '',
        image: json['image'] ?? '',
        tags: json['tags'] != null
            ? Set<String>.from(json['tags'])
            : {},
        skinTypes: json['skinTypes'] != null
            ? Set<String>.from(json['skinTypes'])
            : {},
        keyIngredients: json['keyIngredients'] != null
            ? Set<String>.from(json['keyIngredients'])
            : {},
        category: json['category'] != null
            ? Set<String>.from(json['category'])
            : {},
        steps: json['steps'] != null
            ? List<String>.from(json['steps'])
            : []
    );
  }


  // for sending data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'brand': brand,
      'description': description,
      'image': image,
      'tags': tags.toList(),
      'skinTypes': skinTypes.toList(),
      'keyIngredients': keyIngredients.toList(),
      'category': category.toList(),
      'steps': steps.toList()
    };
  }


  // copy method to update individual fields immutably
  ProductModel copyWith({
    String? name,
    String? subtitle,
    String? brand,
    String? description,
    String? image,
    Set<String>? tags,
    Set<String>? skinTypes,
    Set<String>? keyIngredients,
    Set<String>? category,
    List<String>? steps
  }) {
    return ProductModel(
        id: id,
        name: name ?? this.name,
        subtitle: subtitle ?? this.subtitle,
        brand: brand ?? this.brand,
        description: description ?? this.description,
        image: image ?? this.image,
        tags: tags ?? this.tags,
        skinTypes: skinTypes ?? this.skinTypes,
        keyIngredients: keyIngredients ?? this.keyIngredients,
        category: category ?? this.category,
        steps: steps ?? this.steps
    );
  }


}