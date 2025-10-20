import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/product_image_card.dart';
import '../add_to_routine/add_to_routine.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageSection(product.image),
                _buildProductInfo(product.name, product.brand, product.description, product.tags, product.keyIngredients, product.steps),
                const SizedBox(height: 100),
              ],
            ),
          ),
          _buildAppBar(context),
          _buildBottomButton(),
        ],
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


  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {Navigator.pop(context);},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(String productName, String brand, String description, Set<String> tags, Set<String> keyIngredients, List<String> steps) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            brand,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            tags.join(' | '),
            style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
            )
            ,
          ),

          const SizedBox(height: 20),

          Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins',
              color: Colors.black87,
              height: 1.5
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Key Ingredients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            keyIngredients.join(', '),
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          steps.isNotEmpty
          ?

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to Use',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apply a few drops to clean, dry skin before moisturizer. Use morning and night for best results.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          )


              : SizedBox.shrink()


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
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D9D9).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
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
                final isAdded = routineProvider.isInRoutine(widget.product, 'morning');

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isAdded ? Colors.grey.shade400 : Colors.teal,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: Text(
                      isAdded ? 'Already in Routine' : 'Add to Routine',
                      style: TextStyle(
                        color: isAdded ? Colors.black : Colors.white,
                        fontSize: isAdded ? 14 : 16,
                        fontWeight: isAdded ? FontWeight.w400 : FontWeight.bold,
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

}
