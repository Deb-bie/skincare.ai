import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:myskiin/screens/product_details/product_details.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../enums/day_of_week.dart';
import '../../enums/product_categories.dart';
import '../../enums/routine_type.dart';
import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';
import '../products/existing_products.dart';


class EditRoutinePage extends StatefulWidget {
  final RoutineType routineType;
  final DayOfWeek? day;

  const EditRoutinePage({
    super.key,
    required this.routineType,
    this.day,
  });

  @override
  State<EditRoutinePage> createState() => _EditRoutinePageState();
}


class _EditRoutinePageState extends State<EditRoutinePage> {
  bool isEditing = false;
  bool hasChanges = false;
  Map<ProductCategory, List<ProductModel>> routineProducts = {};


  void _loadRoutineProducts() {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    final day = widget.day ?? _getCurrentDay();
    final dayRoutine = routineProvider.getDayRoutine(day, widget.routineType);

    if (dayRoutine != null) {
      setState(() {
        routineProducts = Map.from(dayRoutine.stepsWithProducts);
      });
    }
  }


  DayOfWeek _getCurrentDay() {
    final now = DateTime.now();
    switch (now.weekday % 7) {
      case 0: return DayOfWeek.sunday;
      case 1: return DayOfWeek.monday;
      case 2: return DayOfWeek.tuesday;
      case 3: return DayOfWeek.wednesday;
      case 4: return DayOfWeek.thursday;
      case 5: return DayOfWeek.friday;
      case 6: return DayOfWeek.saturday;
      default: return DayOfWeek.monday;
    }
  }


  void _markAsChanged() {
    setState(() {
      hasChanges = true;
    });
  }


  @override
  void initState() {
    super.initState();
    _loadRoutineProducts();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: theme.iconTheme.color
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          widget.day != null
              ? 'Edit ${_capitalize(widget.day!.name)} ${_capitalize(widget.routineType.name)}'
              : 'Manage Routine',

          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed:
              hasChanges
                  ? () {Navigator.pop(context);}
                  : null,

              style: ElevatedButton.styleFrom(
                backgroundColor: hasChanges
                    ? const Color(0xFFA8D5BA)
                    : Colors.grey.shade300,
                foregroundColor: hasChanges ? Colors.black87 : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
                fixedSize: Size(80, 10)
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

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(20.0),

            child: Text(
              'Customize your routine for this specific day',
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? Colors.grey.shade200
                    : Colors.grey[600],
                fontFamily: "Poppins",
              ),
              textAlign: TextAlign.center,
            ),
          ),


          // Tab selector (if no specific day)
          if (widget.day == null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                        'Morning Routine',
                        widget.routineType == RoutineType.morning
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildTabButton(
                        'Evening Routine',
                        widget.routineType == RoutineType.evening
                    ),
                  ),
                ],
              ),
            ),


          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              children: [
                ...routineProducts.entries.map((entry) {
                  return _buildCategorySection(entry.key, entry.value);
                }),

                // Add Category Button
                const SizedBox(height: 16),
                _buildAddCategoryButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTabButton(String label, bool isSelected) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditRoutinePage(
              routineType: isSelected ? widget.routineType :
              (widget.routineType == RoutineType.morning ? RoutineType.evening : RoutineType.morning),
              day: widget.day,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor
              : (
              isDark
                  ? Colors.grey[800]
                  : Colors.grey[200]
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : theme.textTheme.bodyMedium?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildCategorySection(ProductCategory category, List<ProductModel> products) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Color(0xFF4FC3DC).withValues(alpha: 0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black)
                .withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [

          // Category Header
          InkWell(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 10, 12),
              child: Row(
                children: [

                  Expanded(
                    child: Text(
                      _categoryToString(category)[0].toUpperCase() +
                          _categoryToString(category).substring(1).toLowerCase(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  if (products.isEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 20,
                      ),
                      onPressed: () => _deleteCategory(category),
                    ),
                ],
              ),
            ),
          ),

          if (products.isNotEmpty)
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = products.removeAt(oldIndex);
                  products.insert(newIndex, item);
                  _markAsChanged();
                });
              },
              itemBuilder: (context, productIndex) {
                final product = products[productIndex];
                return buildProductItem(product, category);
              },
            ),

          // Add Product Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                _showExistingProductsModal(category: category);
              },
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
                  strokeWidth: 1,
                  dashPattern: [6, 3],
                  radius: Radius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Product',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }


  Widget buildProductItem(ProductModel product, ProductCategory category) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: ValueKey(product),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.grey[700]!
                : Colors.grey[200]!,
            width: 1,
          ),
        ),
        color: isDark
            ? Colors.grey[800]!.withValues(alpha: 0.5)
            : Colors.white,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product)
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.drag_indicator,
                color: isDark
                    ? Colors.grey[500]
                    : Colors.grey[400],
                size: 20,
              ),
              const SizedBox(width: 8),

              // Product Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.orange.shade900.withValues(alpha: 0.3)
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product.image!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag,
                        color: isDark
                            ? Colors.orange.shade700
                            : Colors.orange.shade300,
                      );
                    },
                  ),
                )
                    : Icon(
                  Icons.shopping_bag,
                  color: isDark
                      ? Colors.orange.shade700
                      : Colors.orange.shade300,
                ),
              ),
              const SizedBox(width: 12),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4),

                    Text(
                      product.brandName!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Delete icon
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[isDark ? 300 : 400],
                ),
                onPressed: () {
                  _removeProduct(product, category);
                  _markAsChanged();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAddCategoryButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: showAddNewCategoryModal,

      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isDark
                ? Colors.grey[700]!
                : Colors.grey[300]!,
            width: 1,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.add_circle_outline,
              color: theme.primaryColor,
              size: 24,
            ),

            SizedBox(width: 12),

            Text(
              'Add Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }


  void showAddNewCategoryModal() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String? selectedSuggestion;
    final TextEditingController categoryController = TextEditingController();
    String? errorMessage;

    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);

    final availableCategories = routineProvider.getAvailableCategories(
      widget.routineType,
      widget.day ?? _getCurrentDay(),
    );

    final List<String> suggestions = availableCategories
        .map((category) => ProductCategoryHelper.toDisplayName(category))
        .toList();

    suggestions.sort();

    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            bool canSave = (categoryController.text.trim().isNotEmpty ||
                selectedSuggestion != null) && errorMessage == null;

            void saveCategory() {
              final categoryName = categoryController.text.trim().isNotEmpty
                  ? categoryController.text.trim()
                  : selectedSuggestion!;

              final categoryEnum = ProductCategoryHelper.fromDisplayName(categoryName);

              if (categoryEnum == null) {
                setModalState(() {
                  errorMessage = 'Invalid category name. Please select from suggestions.';
                });
                return;
              }

              final alreadyExists = routineProvider.hasCategoryInRoutine(
                categoryEnum,
                widget.routineType,
                widget.day ?? _getCurrentDay(),
              );

              if (alreadyExists) {
                setModalState(() {
                  errorMessage = 'This category already exists in your routine.';
                });
                return;
              }

              routineProvider.addCategoryToRoutine(
                categoryEnum,
                widget.routineType,
                widget.day ?? _getCurrentDay(),
              ).then((_) {
                _markAsChanged();
                _refreshRoutineProducts();
                Navigator.pop(context);
              }).catchError((error) {
                setModalState(() {
                  errorMessage = 'Error adding category: $error';
                });
              });
            }

            return Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Add New Category',
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

                      // Available categories info
                      if (suggestions.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.orange.shade900.withValues(alpha: 0.3)
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.orange.shade700
                                  : Colors.orange.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: isDark
                                    ? Colors.orange.shade400
                                    : Colors.orange.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'All available categories have been added to this routine.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    color: isDark
                                        ? Colors.orange.shade200
                                        : Colors.orange.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.blue.shade900.withValues(alpha: 0.3)
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.category_outlined,
                                color: isDark
                                    ? Colors.blue.shade300
                                    : Colors.blue.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${suggestions.length} ${suggestions.length == 1 ? 'category' : 'categories'} available',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  color: isDark
                                      ? Colors.blue.shade200
                                      : Colors.blue.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Error message
                      if (errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.red.shade900.withValues(alpha: 0.3)
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.red.shade700
                                  : Colors.red.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: isDark
                                    ? Colors.red.shade400
                                    : Colors.red.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    color: isDark
                                        ? Colors.red.shade200
                                        : Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (suggestions.isNotEmpty) ...[
                        // Input field and suggestions
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category Name',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Text Field
                            Container(
                              decoration: BoxDecoration(
                                color: theme.cardTheme.color,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: categoryController,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                ),
                                onChanged: (value) {
                                  setModalState(() {
                                    if (value.isNotEmpty) {
                                      selectedSuggestion = null;
                                    }
                                    errorMessage = null;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Type to search categories...',
                                  hintStyle: theme.inputDecorationTheme.hintStyle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: theme.cardTheme.color,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            Text(
                              'Or choose a suggestion',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Suggestion chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: suggestions.map((suggestion) {
                                final isSelected = selectedSuggestion == suggestion;

                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (isSelected) {
                                        selectedSuggestion = null;
                                      } else {
                                        selectedSuggestion = suggestion;
                                        categoryController.clear();
                                      }
                                      errorMessage = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFA8D5BA)
                                          : (isDark ? Colors.grey[800] : Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Text(
                                      suggestion,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        color: isSelected
                                            ? Colors.white
                                            : theme.textTheme.bodyLarge?.color,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Save button
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: canSave ? saveCategory : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canSave
                                    ? const Color(0xFFFF7A59)
                                    : (isDark ? Colors.grey[800] : Colors.grey.shade100),
                                foregroundColor: canSave
                                    ? Colors.white
                                    : (isDark ? Colors.grey[600] : Colors.grey.shade200),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Save Category',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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


  void _showExistingProductsModal({ProductCategory? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectExistingProductPage(
          category: category,
          routineType: widget.routineType,
          day: widget.day ?? _getCurrentDay(),
          onProductsAdded: () {
            _markAsChanged();
            _refreshRoutineProducts();
          },
        ),
      ),
    );
  }


  void _refreshRoutineProducts() {
    setState(() {
      final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
      final dayRoutine = routineProvider.getDayRoutine(
        widget.day ?? _getCurrentDay(),
        widget.routineType,
      );

      if (dayRoutine != null) {
        routineProducts = Map<ProductCategory, List<ProductModel>>.from(
          dayRoutine.stepsWithProducts,
        );
      }
    });
  }


  void _deleteCategory(ProductCategory category) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(

        title: const Text(
            'Remove Category',
          style: TextStyle(
            fontFamily: "Poppins"
          ),
        ),

        content: Text(
          "Are you sure you want to remove '${category.name}' and all its products from this routine?",
          style: TextStyle(
              fontFamily: "Poppins"
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),

            child: const Text(
                'Cancel',
              style: TextStyle(
                  fontFamily: "Poppins"
              ),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(
                'Remove',
              style: TextStyle(
                  fontFamily: "Poppins"
              ),

            ),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    try {
      setState(() {
        hasChanges = true;
        routineProducts.remove(category);
      });

      final routineProvider = context.read<RoutineProvider>();
      await routineProvider.removeCategoryFromRoutine(
        category,
        widget.routineType,
        widget.day!,
      );
      
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove category: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  
  void _removeProduct(ProductModel product, ProductCategory category) {
    setState(() {
      routineProducts[category]?.removeWhere((p) => p.id == product.id);
    });
  }
  
  
  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }


  String _categoryToString(ProductCategory category) {
    return category.toString().split('.').last.replaceAll('_', ' ');
  }
}