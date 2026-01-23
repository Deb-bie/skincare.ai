import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../providers/product_provider.dart';


class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}


class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  late final productProvider = Provider.of<ProductProvider>(context, listen: false);

  String? selectedCategory;
  String? imageUrl;
  bool isLoading = false;
  bool isSaving = false;
  bool hasChanges = false;
  final bool _isLoading = false;
  File? _imageFile;
  List<String> selectedIngredients = [];

  List<String> categories = [
    'Cleanser',
    'Moisturizer',
    'Serum',
    'Sunscreen',
    'Face Mask',
    "Eye Cream",
    'Toner',
    'Exfoliator'
  ];


  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _brandController.text = widget.product.brandName ?? '';
    _descriptionController.text = widget.product.description ?? '';
    selectedCategory = widget.product.categoryNames?.first;
    imageUrl = widget.product.image;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          'Edit Product',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,

        actions: [
          if (isSaving)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            )

          else
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 0, bottom: 0),
              child: ElevatedButton(
                onPressed: hasChanges ? _updateProduct : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasChanges
                      ? const Color(0xFFA8D5BA)
                      : (isDark
                      ? Colors.grey[800]
                      : Colors.grey.shade300),
                  foregroundColor: hasChanges
                      ? Colors.black87
                      : (isDark ? Colors.grey[600] : Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                  fixedSize: const Size(80, 3),
                ),

                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Product Image Section
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _showImageSourceDialog,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[850]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                          width: 2,
                        ),
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
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.cardTheme.color,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha:
                                            isDark ? 0.5 : 0.2,
                                          ),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            )

                          : imageUrl != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    imageUrl!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _buildImagePlaceholder(),
                                  ),
                                ),

                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.cardTheme.color,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha:
                                            isDark ? 0.5 : 0.2,
                                          ),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            )

                          : _buildImagePlaceholder()
                    ),
                  ),
                ),


                const SizedBox(height: 32),

                // Product Name
                _buildSectionLabel('Product Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: theme.textTheme.bodyMedium,
                  onChanged: (value) => _markAsChanged(),
                  decoration: InputDecoration(
                    hintText: 'e.g., Hydrating Serum',
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),


                const SizedBox(height: 32),

                // Brand Name
                _buildSectionLabel('Brand'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _brandController,
                  style: theme.textTheme.bodyMedium,
                  onChanged: (value) => _markAsChanged(),
                  decoration: InputDecoration(
                    hintText: 'e.g., The Ordinary',
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter brand name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Category
                _buildSectionLabel('Category'),
                const SizedBox(height: 8),
                Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
              ),

              child: DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                hint: Text(
                  'Select a category',
                  style: theme.inputDecorationTheme.hintStyle,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                dropdownColor: theme.cardTheme.color,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.iconTheme.color,
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    _markAsChanged();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
            ),


                const SizedBox(height: 24),


                // Key Ingredients
                const Text(
                  'Key Ingredients',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                      fontFamily: "Poppins",
                      letterSpacing: 1
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4D6),
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
                  decoration: InputDecoration(
                    hintText: 'Add ingredient...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontFamily: "Poppins"),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF06B6D4)),
                      onPressed: _addIngredient,
                    ),
                  ),
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 8),

                Text(
                  'Type to search ingredients or add custom ones.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                      fontFamily: "Poppins",
                  ),
                ),

                const SizedBox(height: 24),

                // Notes
                _buildSectionLabel('Notes (Optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  onChanged: (value) => _markAsChanged(),
                  decoration: InputDecoration(
                    hintText: 'Add notes about this product...',
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 50),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _updateProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: isDark
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isSaving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : const Text(
                      'Update Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textTheme.bodyMedium?.color,
                      side: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    final theme = Theme.of(context);

    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }


  Widget _buildImagePlaceholder() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 48,
          color: isDark ? Colors.grey[600] : Colors.grey[400],
        ),
        const SizedBox(height: 8),
        Text(
          'Add Photo',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    super.dispose();
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


  Future<void> _updateProduct() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a category'),
          backgroundColor: Colors.red[isDark ? 300 : 400],
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {

      final updatedProduct = ProductModel(
        id: widget.product.id,
        name: _nameController.text.trim(),
        brandName: _brandController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryNames: [selectedCategory!],
        image: imageUrl,
        createdAt: widget.product.createdAt,
      );

      await productProvider.updateProduct(widget.product.id!, updatedProduct.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Product updated successfully!'),
            backgroundColor: Colors.green[isDark ? 300 : 400],
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating product: $e'),
            backgroundColor: Colors.red[isDark ? 300 : 400],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await productProvider.pickImage(source: source);
      if (file != null) {
        setState(() {
          _imageFile = file;
        });
        _markAsChanged();
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
                'Change Product Photo',
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


  void _markAsChanged() {
    setState(() {
      hasChanges = true;
    });
  }

}
