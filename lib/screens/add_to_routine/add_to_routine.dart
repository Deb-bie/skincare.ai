import 'package:flutter/material.dart';

import '../../core/constants/product_categories.dart';
import '../../models/product/product_model.dart';

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


  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    String? morningCategory = widget.product.category.first;
    String? eveningCategory;


    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
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
                    child: const Icon(Icons.close, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 24),


              // Product info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    product.brand,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                        fontFamily: "Poppins"
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    product.subtitle,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontFamily: "Poppins"
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 32),


              // Morning Routine
              _buildRoutineSection(
                title: 'Morning Routine',
                isSelected: morningRoutineSelected,
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
              const SizedBox(height: 24),

              // Add to Both Routines toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add to Both Routines',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      switchTheme: SwitchThemeData(
                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent), // No border
                      ),
                    ),
                    child: Switch(
                      value: addToBoth,
                      onChanged: (value) {
                        setState(() {
                          addToBoth = value;
                        });
                      },
                      activeThumbColor: Colors.green, // Thumb when ON
                      activeTrackColor: Colors.green.shade200, // Track when ON
                      inactiveThumbColor: Colors.grey.shade500, // Thumb when OFF
                      inactiveTrackColor: Colors.grey.shade300,
                      // activeColor: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle confirm action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26D07C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Confirm Add',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
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
    required ValueChanged<bool?> onChanged,
    required Widget categoryDropdown,
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
                activeColor: const Color(0xFF26D07C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // routine name
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                  fontFamily: "Poppins"
              ),
            ),
          ],
        ),

        const SizedBox(height: 0),

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
    bool isPlaceholder = false,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: enabled ? onChanged : null,

      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),

        hintText: isPlaceholder ? 'Select Category' : null,
      ),

      hint: Text(
        isPlaceholder ? 'Select Category' : widget.product.name,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}



