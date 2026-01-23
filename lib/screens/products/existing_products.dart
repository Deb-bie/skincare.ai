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

class _SelectExistingProductPageState extends State<SelectExistingProductPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  String searchQuery = '';
  String selectedCategory = 'All';
  Set<String> selectedProducts = {};

  List<ProductModel> allSystemProducts = [];
  List<ProductModel> allUserProducts = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    if (widget.category != null) {
      selectedCategory = widget.category!.name[0].toUpperCase() + widget.category!.name.substring(1);
    }
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        searchQuery = '';
        _searchController.clear();
        _filterProducts();
      });
    }
  }


  void _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      // Load system products
      final systemProducts = await productProvider.getProductsByCategoryLocally(selectedCategory);

      // Load user's own products
      final userProducts = await productProvider.getUserProductsByCategoryLocally(selectedCategory);

      setState(() {
        allSystemProducts = systemProducts;
        allUserProducts = userProducts;
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
      final sourceList = _tabController.index == 0 ? allSystemProducts : allUserProducts;

      filteredProducts = sourceList.where((product) {
        bool searchMatch = searchQuery.isEmpty ||
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (product.brandName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

        return searchMatch;
      }).toList();
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
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          'Select Products',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          if (selectedProducts.isNotEmpty)
            TextButton(
              onPressed: _addSelectedProducts,
              child: Text(
                'Add (${selectedProducts.length})',
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"
                ),
              ),
            ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.primaryColor,
              unselectedLabelColor: theme.textTheme.bodyMedium?.color,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              indicatorColor: theme.primaryColor,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'System Products'),
                Tab(text: 'My Products'),
              ],
            ),
          ),
        ),
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
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: theme.inputDecorationTheme.hintStyle,
                prefixIcon: Icon(Icons.search,
                    color: isDark ? Colors.grey[500] : Colors.grey[400]),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear,
                      color: isDark ? Colors.grey[500] : Colors.grey[400]),
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
                fillColor: theme.cardTheme.color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12
                ),
              ),
            ),
          ),

          // Products List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsList(),
                _buildProductsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProductCard(ProductModel product, bool isSelected) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product)
            )
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF9B7A)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.black)
                  .withValues(alpha: isDark ? 0.3 : 0.04),
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
                    selectedProducts.add(product.id!);
                  }
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF9B7A)
                        : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                    width: 1,
                  ),
                  color: isSelected
                      ? const Color(0xFFFF9B7A)
                      : Colors.transparent,
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
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: product.image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image,
                          color: isDark ? Colors.grey[600] : Colors.grey[400]),
                ),
              )
                  : Icon(Icons.image,
                  color: isDark ? Colors.grey[600] : Colors.grey[400]),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),

                  if (product.brandName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.brandName!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (product.categoryNames != null &&
                      product.categoryNames!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      product.categoryNames!.join(' • '),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
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
    final theme = Theme.of(context);
    final isUserTab = _tabController.index == 1;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isEmpty ? Icons.inventory_2_outlined : Icons.search_off,
            size: 64,
            color: theme.brightness == Brightness.dark
                ? Colors.grey[700]
                : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty
                ? (isUserTab ? 'No personal products yet' : 'No products available')
                : 'No products found',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
            ),
          ] else if (isUserTab) ...[
            const SizedBox(height: 8),
            Text(
              'Add your own products to see them here',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildProductsList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00897B),
        ),
      );
    }

    if (filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        if (index >= filteredProducts.length) {
          return const SizedBox.shrink();
        }

        final product = filteredProducts[index];
        final isSelected = selectedProducts.contains(product.id);
        return _buildProductCard(product, isSelected);
      },
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

