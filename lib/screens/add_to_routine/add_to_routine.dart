import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/product_categories.dart';
import '../../enums/product_categories.dart';
import '../../enums/routine_type.dart';
import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/buildChip.dart';

class AddToRoutine extends StatefulWidget {
  final ProductModel product;

  const AddToRoutine({super.key, required this.product});

  @override
  State<AddToRoutine> createState() => _AddToRoutineState();
}


class _AddToRoutineState extends State<AddToRoutine> {
  bool morningRoutineSelected = true;
  bool eveningRoutineSelected = false;
  bool addToBoth = false;
  String? morningCategory;
  String? eveningCategory;
  ProductModel? product;

  // Track if product is already in routines
  bool isInMorningRoutine = false;
  bool isInEveningRoutine = false;



  @override
  void initState() {
    super.initState();
    morningCategory = widget.product.categoryNames!.first;
    _checkExistingRoutines();
  }

  void _checkExistingRoutines() {
    final routineProvider = context.read<RoutineProvider>();

    isInMorningRoutine = routineProvider.isProductInRoutine(
      widget.product,
      type: RoutineType.morning,
    );

    isInEveningRoutine = routineProvider.isProductInRoutine(
      widget.product,
      type: RoutineType.evening,
    );
  }



  Future<void> _addToRoutine() async {
    final routineProvider = context.read<RoutineProvider>();

    if (!morningRoutineSelected && !eveningRoutineSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one routine.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Add to morning routine
      if (morningRoutineSelected && morningCategory != null) {
        final morningCat = convertToCategory(morningCategory!);
        await routineProvider.addProductToRoutine(
          product!,
          morningCat,
          RoutineType.morning,
        );
      }

      // Add to evening routine
      if (eveningRoutineSelected && eveningCategory != null) {
        final eveningCat = convertToCategory(eveningCategory!);
        await routineProvider.addProductToRoutine(
          product!,
          eveningCat,
          RoutineType.evening,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to routine: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }




  ProductCategory convertToCategory(String category) {
    if (category == "Cleanser") {
      return ProductCategory.cleanser;
    }
    else if (category == "Toner") {
      return ProductCategory.toner;
    }
    else if (category == "Serum") {
      return ProductCategory.serum;
    }
    else if (category == "Moisturizer") {
      return ProductCategory.moisturizer;
    }
    else if (category == "Sunscreen") {
      return ProductCategory.sunscreen;
    }
    return ProductCategory.cleanser;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    product = widget.product;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),

      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [

              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Add to Routine',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                        Icons.close,
                        size: 24
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),


              // Product info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product!.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"
                    ),
                  ),

                  const SizedBox(height: 12),

                  buildChip(product!.brandName!, const Color(0xFFFF7A59).withValues(alpha: 0.1), const Color(0xFFFF7A59)),

                  const SizedBox(height: 12),

                  if (product!.subtitle != '')
                    buildChip(product!.subtitle!, Colors.blue.shade50, Colors.blue.shade700),
                ],
              ),

              const SizedBox(height: 40),

              // Morning Routine
              _buildRoutineSection(
                title: 'Morning Routine',
                isSelected: morningRoutineSelected,
                isAlreadyInRoutine: isInMorningRoutine,
                onChanged: (value) {
                  setState(() {
                    morningRoutineSelected = value ?? false;
                  });
                },
                categoryDropdown: _buildCategoryDropdown(
                  value: morningCategory,
                  onChanged: (value) {
                    setState(() {
                      morningCategory = value;
                    });
                  },
                  enabled: morningRoutineSelected,
                ),
              ),

              const SizedBox(height: 20),

              // Evening Routine
              _buildRoutineSection(
                title: 'Evening Routine',
                isSelected: eveningRoutineSelected,
                isAlreadyInRoutine: isInEveningRoutine,
                onChanged: (value) {
                  setState(() {
                    eveningRoutineSelected = value ?? false;
                  });
                },
                categoryDropdown: _buildCategoryDropdown(
                  value: eveningCategory,
                  onChanged: (value) {
                    setState(() {
                      eveningCategory = value;
                    });
                  },
                  enabled: eveningRoutineSelected,
                  isPlaceholder: true,
                ),
              ),

              const SizedBox(height: 50),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _addToRoutine();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (!morningRoutineSelected && !eveningRoutineSelected)
                        ? Colors.grey.shade300
                        : Colors.teal[500],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Confirm Add',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: (!morningRoutineSelected && !eveningRoutineSelected) ? Colors.black : Colors.white,
                        fontFamily: "Poppins",
                        letterSpacing: 1
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildRoutineSection({
    required String title,
    required bool isSelected,
    required bool isAlreadyInRoutine,
    required ValueChanged<bool?> onChanged,
    required Widget categoryDropdown
  }) {
    return Column(
      children: [
        Row(
          children: [

            // checkbox
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: Colors.teal[500],
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // routine name
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins"
              ),
            ),

            const SizedBox(width: 16),

            // "Already added" indicator
            if (isAlreadyInRoutine)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green.shade700,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      'Added',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 2),

        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: categoryDropdown,
        ),
      ],
    );
  }



  Widget _buildCategoryDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
    required bool enabled,
    bool isPlaceholder = false
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        onChanged: enabled ? onChanged : null,
        isExpanded: true,
        dropdownColor: theme.cardTheme.color,

        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
                category,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),

        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? Colors.grey.shade200.withValues(alpha: 0.2) : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),

          hintText: isPlaceholder ? 'Select Category' : null,
        ),

        hint: Text(
          isPlaceholder ? 'Select Category' : widget.product.name,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

