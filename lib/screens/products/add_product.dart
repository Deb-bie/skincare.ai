import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _brandNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();
  final _ingredientsController = TextEditingController();

  late final productProvider = Provider.of<ProductProvider>(context, listen: false);

  String? selectedCategory;
  File? _imageFile;
  bool _isLoading = false;
  List<String> selectedIngredients = [];

  final List<Map<String, dynamic>> categories = [
    {'icon': '💧', 'name': 'Cleanser', 'color': Color(0xFF06B6D4)},
    {'icon': '🧪', 'name': 'Serum', 'color': Colors.grey[400]},
    {'icon': '💧', 'name': 'Moisturizer', 'color': Colors.grey[400]},
    {'icon': '☀️', 'name': 'Sunscreen', 'color': Colors.grey[400]},
    {'icon': '😊', 'name': 'Face Mask', 'color': Colors.grey[400]},
    {'icon': '🌿', 'name': 'Toner', 'color': Colors.grey[400]},
  ];




  @override
  void initState() {
    super.initState();
    selectedCategory = 'Cleanser';
  }


  void _addIngredient() {
    if (_ingredientsController.text.isNotEmpty) {
      setState(() {
        selectedIngredients.add(_ingredientsController.text);
        _ingredientsController.clear();
      });
    }
  }


  void _removeIngredient(String ingredient) {
    setState(() {
      selectedIngredients.remove(ingredient);
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          'Add Products',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                // Upload Photo Section
                GestureDetector(
                  onTap: _isLoading ? null : _showImageSourceDialog,
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: isDark ? Colors.grey[850] : Colors.grey[50],
                    ),
                    child: _imageFile != null
                        ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _imageFile!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                LucideIcons.pen,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : _showImageSourceDialog,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        // Camera Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4D6).withValues(alpha:
                              isDark ? 0.3 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            LucideIcons.focus,
                            color: Color(0xFFFF9B7A),
                            size: 36,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Scan or Upload',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Tap to take or upload an image of the product.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Brand Name
                Text(
                  'BRAND NAME',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: _brandNameController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'e.g. CeraVe',
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 20),

                // Product Name
                Text(
                  'PRODUCT NAME',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: _productNameController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'e.g. Hydrating Cleanser',
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 24),

                // What is it?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'What is it?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showViewAll(
                          onCategorySelected: (category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Color(0xFFFF9B7A),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Category Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category['name'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category['name'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                              ? const Color(0xFF06B6D4).withValues(alpha: 0.2)
                              : const Color(0xFFE0F2FE))
                              : (isDark ? Colors.grey[850] : Colors.grey[50]),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF06B6D4)
                                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    category['icon'],
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? const Color(0xFF0E7490)
                                          : theme.textTheme.bodyMedium?.color,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF06B6D4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Key Ingredients
                Text(
                  'Key Ingredients',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 12),

                // Selected Ingredients
                if (selectedIngredients.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedIngredients.map((ingredient) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4D6).withValues(alpha:
                            isDark ? 0.3 : 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ingredient,
                              style: const TextStyle(
                                color: Color(0xFFFF9B7A),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _removeIngredient(ingredient),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Color(0xFFFF9B7A),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                if (selectedIngredients.isNotEmpty)
                  const SizedBox(height: 12),

                // Add Ingredient Field
                TextField(
                  controller: _ingredientsController,
                  onSubmitted: (_) => _addIngredient(),
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Add ingredient...',
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add, color: theme.primaryColor),
                      onPressed: _addIngredient,
                    ),
                  ),
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 8),

                Text(
                  'Type to search ingredients or add custom ones.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 35),

                // Notes
                Text(
                  'Notes',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _notesController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Anything special about this product? (e.g. use only at night)',
                    hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 40),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _uploadProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: isDark
                                ? Colors.grey[800]
                                : Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Add Product',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),


                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await productProvider.pickImage(source: source);
      if (file != null) {
        setState(() {
          _imageFile = file;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }


  void _showErrorDialog(String message) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Text(
          'Error',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }


  void _showImageSourceDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Product Photo',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[isDark ? 900 : 50]?.withValues(alpha:
                      isDark ? 0.3 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: Colors.blue[isDark ? 300 : 700],
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: theme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'Select an existing photo',
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),

              Divider(height: 1, color: theme.dividerTheme.color),

              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[isDark ? 900 : 50]?.withValues(alpha:
                      isDark ? 0.3 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.green[isDark ? 300 : 700],
                  ),
                ),
                title: Text(
                  'Take a Photo',
                  style: theme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'Use your camera',
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    color: Colors.red[isDark ? 300 : 400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _uploadProduct() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageFile == null) {
      _showErrorDialog('Please select an image');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final ingredients = _ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final imageUrl = await productProvider.uploadImage(_imageFile!);

      await productProvider.createProduct(
        ProductModel(
          name: _productNameController.text,
          brandName: _brandNameController.text,
          keyIngredients: ingredients,
          description: _notesController.text,
          categoryNames: [selectedCategory!],
          image: imageUrl,
          // userId: '',
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Product uploaded successfully!'),
            backgroundColor: Colors.green[isDark ? 300 : 400],
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorDialog('Failed to upload product: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  void showViewAll({required Function(String) onCategorySelected}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String? selectedCategory;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final List<Map<String, dynamic>> categories = [
          {'icon': '🧼', 'name': 'Cleanser', 'color': Color(0xFF06B6D4)},
          {'icon': '🧪', 'name': 'Serum', 'color': Colors.grey[400]},
          {'icon': '☁️', 'name': 'Moisturizer', 'color': Colors.grey[400]},
          {'icon': '☀️', 'name': 'Sunscreen', 'color': Colors.grey[400]},
          {'icon': '🧖‍♀️', 'name': 'Face Mask', 'color': Colors.grey[400]},
          {'icon': '🌿', 'name': 'Toner', 'color': Colors.grey[400]},
          {'icon': '🫧', 'name': 'Exfoliator', 'color': Colors.grey[400]},
          {'icon': '🧴', 'name': 'Eye Cream', 'color': Colors.grey[400]},
          {'icon': '💧', 'name': 'Essences', 'color': Colors.grey[400]},
          {'icon': '🧴', 'name': 'Other', 'color': Colors.grey[400]},
        ];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Add Product Type',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: theme.iconTheme.color,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category['name'];

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedCategory = category['name'];
                              });
                              onCategorySelected(category['name']);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                    ? const Color(0xFF06B6D4).withValues(alpha: 0.2)
                                    : const Color(0xFFE0F2FE))
                                    : (isDark ? Colors.grey[850] : Colors.grey[50]),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF06B6D4)
                                      : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          category['icon'],
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          category['name'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? const Color(0xFF0E7490)
                                                : theme.textTheme.bodyMedium?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF06B6D4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _brandNameController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }
}