import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/day_of_week.dart';
import '../../enums/product_categories.dart';
import '../../enums/routine_type.dart';
import '../../models/product/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/routine_provider.dart';
import '../product_details/product_details.dart';

class SelectExistingProductPage extends StatefulWidget {
  final ProductCategory? category;
  final RoutineType routineType;
  final DayOfWeek day;
  final VoidCallback? onProductsAdded;

  const SelectExistingProductPage({
    super.key,
    this.category,
    required this.routineType,
    required this.day,
    this.onProductsAdded,
  });

  @override
  State<SelectExistingProductPage> createState() => _SelectExistingProductPageState();
}

class _SelectExistingProductPageState extends State<SelectExistingProductPage> {
  final TextEditingController _searchController = TextEditingController();


  String searchQuery = '';
  String selectedCategory = 'All';
  Set<String> selectedProducts = {};
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      selectedCategory = widget.category!.name[0].toUpperCase() + widget.category!.name.substring(1);
    }
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final all = await productProvider.getProductsByCategoryLocally(selectedCategory);

      setState(() {
        allProducts = all;
        isLoading = false;
        _filterProducts();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        bool searchMatch = searchQuery.isEmpty ||
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (product.brandName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

        return searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          'Select Products',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),

        actions: [
          if (selectedProducts.isNotEmpty)
            TextButton(
              onPressed: _addSelectedProducts,
              child: Text(
                'Add (${selectedProducts.length})',
                style: const TextStyle(
                    color: Color(0xFF00897B),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"
                ),
              ),
            ),
        ],
      ),

      body: Column(
        children: [

          // Search Bar
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterProducts();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Poppins',
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      searchQuery = '';
                      _filterProducts();
                    });
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Products List
          Expanded(
            child: allProducts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final isSelected = selectedProducts.contains(product.id);
                return _buildProductCard(product, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                ProductDetailsPage(product: product)
            )
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9B7A) : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [

            // Checkbox
            InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedProducts.remove(product.id);
                  } else {
                    selectedProducts.add(product.id);
                  }
                });
              },

              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFF9B7A) : Colors.grey[400]!,
                    width: 1,
                  ),
                  color: isSelected ? const Color(0xFFFF9B7A) : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),

            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: product.image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image, color: Colors.grey[400]),
                ),
              )
                  : Icon(Icons.image, color: Colors.grey[400]),
            ),
            const SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                    maxLines: 2,
                  ),

                  if (product.brandName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.brandName!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                  if (product.categoryNames != null && product.categoryNames!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      product.categoryNames!.join(' • '),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty ? 'No products available' : 'No products found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _addSelectedProducts() {
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    final products = productProvider.getProductsByIds(selectedProducts.toList());

    if (products.isNotEmpty) {
      routineProvider.addProductsToRoutine(
          products,
          widget.category!,
          widget.routineType,
          widget.day
      );
      widget.onProductsAdded?.call();
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedProducts.length} product(s) added'),
        backgroundColor: const Color(0xFF00897B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}