import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/buildChip.dart';
import '../add_to_routine/add_to_routine.dart';
import 'full_image.dart';


class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isFavorite = false;
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final product = widget.product;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [

              // App Bar with transparent background
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor,

                elevation: 0,

                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade300 : Colors.white.withValues(alpha:0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),

                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [

                      // Product Image
                      if (product.image != null) GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImage(
                                imagePath: product.image!,
                              ),
                            ),
                          );
                        },

                        child: Container(
                          color: isDark ? null : Colors.white,
                          child: Image.network(
                            product.image!,
                            fit: BoxFit.cover,
                          )
                        ),
                      ) else Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Product Header Card
                    _buildProductHeader(),

                    const SizedBox(height: 12),

                    // Badges (Cruelty-free, Fragrance-free)
                    if (product.isCrueltyFree == true || product.isFragranceFree == true)
                      _buildBadges(),

                    const SizedBox(height: 12),

                    if (product.categoryNames != null && product.categoryNames!.isNotEmpty)
                      _buildSection(
                        title: "Categories",
                        icon: Icons.category_outlined,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.categoryNames!.map((category) =>
                            buildChip(category, const Color(0xFFFF7A59).withValues(alpha: 0.1), const Color(0xFFFF7A59))

                          ).toList(),
                        ),
                      ),

                    // Description
                    if (product.description != null && product.description!.isNotEmpty)
                      _buildSection(
                        title: "About This Product",
                        child: Text(
                          product.description!,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white70 : Color(0xFF374151),
                            height: 1.6,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

                    // Skin Types
                    if (product.skinType != null && product.skinType!.isNotEmpty)
                      _buildSection(
                        title: "Suitable For",
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.skinType!.map((type) =>
                              buildChip(type, Color(0xFFE0F2F1), Color(0xFF00897B))
                          ).toList(),
                        ),
                      ),

                    // Key Ingredients
                    if (product.keyIngredients != null && product.keyIngredients!.isNotEmpty)
                      _buildSection(
                        title: "Key Ingredients",
                        icon: Icons.science_outlined,
                        child: Column(
                          children: product.keyIngredients!.map((ingredient) =>
                              _buildIngredientItem(ingredient)
                          ).toList(),
                        ),
                      ),

                    // How to Use

                    if (product.steps != null && product.steps!.trim().isNotEmpty)
                      _buildSection(
                        title: "How to Use",
                        child: Column(
                          children: (() {
                            final List<String> stepsList = product.steps!
                                .split('.')
                                .map((s) => s.trim())
                                .where((s) => s.isNotEmpty)
                                .map((s) => '$s.')
                                .toList();

                            return List<Widget>.generate(
                              stepsList.length,
                                  (index) => _buildStep(index + 1, stepsList[index]),
                            );
                          })(),
                        ),
                      ),


                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Fixed Bottom Button
          _buildBottomButton(),
        ],
      ),
    );
  }


  Widget _buildProductHeader() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final product = widget.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: isDark ? theme.cardTheme.color : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            product.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),

          if (product.brandName != null && product.brandName!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              product.brandName!,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Color(0xFF6B7280),
              ),
            ),
          ],

          if (product.subtitle != null && product.subtitle!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              product.subtitle!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: 'Poppins',
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],

          // Tags
          if (product.tags != null && product.tags!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.tags!.map((tag) =>
                  buildChip(tag, Colors.blue.shade50, Colors.blue.shade700)
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildBadges() {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (product.isCrueltyFree == true)
            Expanded(
              child: _buildBadge(
                icon: Icons.eco_outlined,
                label: "Cruelty Free",
                color: Colors.green,
              ),
            ),
          if (product.isCrueltyFree == true && product.isFragranceFree == true)
            const SizedBox(width: 12),
          if (product.isFragranceFree == true)
            Expanded(
              child: _buildBadge(
                icon: Icons.air_outlined,
                label: "No Fragrance",
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildBadge({required IconData icon, required String label, required Color color}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? theme.cardTheme.color : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSection({required String title, IconData? icon, required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.cardTheme.color : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 22, color: const Color(0xFF00897B)),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }


  Widget _buildIngredientItem(String ingredient) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade300.withValues(alpha: 0.5) : Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ingredient,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStep(int number, String step) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              // color: isDark ? Colors.white70 : Color(0xFF374151),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                step,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : const Color(0xFF374151),
                  height: 1.5,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBottomButton() {

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF00D9D9),
          borderRadius: BorderRadius.circular(28),

        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showAddToRoutineModal(context, widget.product);
            },
            borderRadius: BorderRadius.circular(28),
            child: Consumer<RoutineProvider>(
              builder: (BuildContext context, routineProvider, child) {
                bool isAdded = routineProvider.isProductInRoutine(widget.product);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isAdded ?
                    Colors.grey.shade300 : Colors.teal,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: Text(
                      isAdded ? 'Already in Routine' : 'Add to Routine',
                      style: TextStyle(
                        color: isAdded ? Colors.black : Colors.white,
                        fontSize: isAdded ? 14 : 16,
                        fontWeight: isAdded ? FontWeight.w400 : FontWeight.bold,
                        fontFamily: "Poppins"
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

  }

  void showAddToRoutineModal(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddToRoutine(product: widget.product);
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }
}

