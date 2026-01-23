import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:myskiin/screens/product_details/product_details.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../providers/product_provider.dart';
import '../../services/data_manager/hive_models/user/hive_user_model.dart';
import 'add_product_sign_in.dart';
import 'edit_user_product.dart';
import 'add_product.dart';

class MyShelfScreen extends StatefulWidget {
  const MyShelfScreen({super.key});

  @override
  State<MyShelfScreen> createState() => _MyShelfScreenState();
}

class _MyShelfScreenState extends State<MyShelfScreen> {

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String searchQuery = '';
  String selectedCategory = 'All';
  Set<String> selectedProducts = {};
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<String> categories = ['All', 'Cleanser', 'Moisturizer', 'Serum', 'Sunscreen', 'Face Mask', "Eye Cream", 'Toner', 'Exfoliator'];
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    isSignedIn();
    _loadCategories();
    _loadProducts();
  }

  void _loadCategories() async {
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final customCategories = await productProvider.getUserCategories();

      setState(() {
        // Merge default categories with custom ones, avoiding duplicates
        categories = [
          'All',
          'Cleanser',
          'Moisturizer',
          'Serum',
          'Sunscreen',
          'Face Mask',
          "Eye Cream",
          'Toner',
          'Exfoliator',
          ...customCategories.where((cat) => ![
            'All',
            'Cleanser',
            'Moisturizer',
            'Serum',
            'Sunscreen',
            'Face Mask',
            "Eye Cream",
            'Toner',
            'Exfoliator'
          ].contains(cat))
        ];
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }


  void _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final all = await productProvider.getUserProducts();

      setState(() {
        allProducts = all;
        isLoading = false;
        _filterProducts();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error loading products: $e');
    }
  }


  void _filterProducts() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchesCategory = selectedCategory == 'All' ||
            product.categoryNames!.first == selectedCategory;

        bool searchMatch = searchQuery.isEmpty ||
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (product.brandName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

        return matchesCategory && searchMatch;
      }).toList();
    });
  }


  void isSignedIn()async {
    final userBox = Hive.box<HiveUserModel>('users');
    final user = userBox.get('currentUser');
    if (user != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'My Shelf',
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            // Search Bar
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: theme.textTheme.bodyMedium,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterProducts();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search serums, cleansers...',
                  hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
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
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Category Tabs with Add Button
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...categories.map((category) => _buildCategoryChip(category)),

                  // Add Category Button
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 4),
                    child: ActionChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: 16,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      onPressed: _showAddCategoryDialog,
                      backgroundColor: theme.cardTheme.color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 16),

            // Products Grid
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              )
                  : filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(filteredProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        onPressed: () {
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductScreen(),
              ),
            ).then((result) {
              _loadProducts();
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductSignInPage(),
              ),
            );
          }
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }


  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty ? 'No products available' : 'No products found',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
            ),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildCategoryChip(String category) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: GestureDetector(
        onLongPress: () {
          if (!['All', 'Cleanser', 'Moisturizer', 'Serum'].contains(category)) {
            _showDeleteCategoryDialog(category);
          }
        },
        child: ChoiceChip(
          label: Text(
            category,
            style: const TextStyle(fontFamily: "Poppins"),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              selectedCategory = category;
              _filterProducts();
            });
          },
          backgroundColor: theme.cardTheme.color,
          selectedColor: theme.primaryColor,
          labelStyle: TextStyle(
            color: isSelected
                ? Colors.white
                : theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
    );
  }


  Widget _buildProductCard(ProductModel product) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      onLongPress: () {
        _showProductOptions(product);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.black)
                      .withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: product.image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                    )
                        : Icon(
                      Icons.image,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ),

                // Product Info
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.brandName!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7A59).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.categoryNames!.first,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              color: Color(0xFFFF7A59),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Options Button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _showProductOptions(product),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color?.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: theme.iconTheme.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showAddCategoryDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    _categoryController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        title: Text(
          'Add Category',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        content: TextField(
          controller: _categoryController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'e.g., Sunscreen, Toner',
            hintStyle: theme.inputDecorationTheme.hintStyle,
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          enabled: true,
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Poppins',
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final categoryName = _categoryController.text.trim();

              if (categoryName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please enter a category name'),
                    backgroundColor: Colors.red[isDark ? 300 : 400],
                  ),
                );
                return;
              }

              if (categories.contains(categoryName)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Category already exists'),
                    backgroundColor: Colors.orange[isDark ? 300 : 400],
                  ),
                );
                return;
              }

              try {
                setState(() {
                  categories.add(categoryName);
                });

                Navigator.pop(context);

              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error adding category: $e'),
                    backgroundColor: Colors.red[isDark ? 300 : 400],
                  ),
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showDeleteCategoryDialog(String category) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Can't delete default categories
    if (['All', 'Cleanser', 'Moisturizer', 'Serum'].contains(category)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot delete default categories'),
          backgroundColor: Colors.orange[isDark ? 300 : 400],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        title: Text(
          'Delete Category',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        content: Text(
          'Are you sure you want to delete "$category"?\n\nProducts in this category won\'t be deleted.',
          style: theme.textTheme.bodyMedium,
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Poppins',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                setState(() {
                  categories.remove(category);
                  if (selectedCategory == category) {
                    selectedCategory = 'All';
                    _filterProducts();
                  }
                });

                Navigator.pop(context);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting category: $e'),
                    backgroundColor: Colors.red[isDark ? 300 : 400],
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[isDark ? 300 : 400],
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }


  void _showProductOptions(ProductModel product) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                LucideIcons.pen,
                color: Colors.blue,
              ),
              title: Text(
                'Edit Product',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _editProduct(product);
              },
            ),

            ListTile(
              leading: const Icon(
                LucideIcons.trash,
                color: Colors.red,
              ),
              title: Text(
                'Delete Product',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteProduct(product);
              },
            ),

            ListTile(
              leading: Icon(
                LucideIcons.circleX,
                color: theme.iconTheme.color,
              ),
              title: Text(
                'Cancel',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _deleteProduct(ProductModel product) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,

        title: Text(
          'Delete Product',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontFamily: 'Poppins',
          ),
        ),

        content: Text(
          'Are you sure you want to delete ${product.name}?',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'Poppins',
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Poppins',
                fontSize: 13,
              ),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[isDark ? 300 : 400],
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final productProvider = Provider.of<ProductProvider>(
          context,
          listen: false,
        );
        await productProvider.deleteProduct(product.id!, product.image!);

        _loadProducts();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting product: $e'),
            backgroundColor: Colors.red[isDark ? 300 : 400],
          ),
        );
      }
    }
  }


  void _editProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    ).then((result) {
        _loadProducts();
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

}



