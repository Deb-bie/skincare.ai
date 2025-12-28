
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:myskiin/screens/products/product_search.dart';
import '../../models/product/product_model.dart';
import '../../services/product/product_service.dart';
import '../product_details/product_details.dart';

class DiscoverProduct extends StatefulWidget {
  final String category;
  const DiscoverProduct({super.key, required this.category});

  @override
  State<DiscoverProduct> createState() => _DiscoverProductState();
}

class _DiscoverProductState extends State<DiscoverProduct> {
  final ProductService _productService = ProductService();
  late final String category = widget.category;
  bool isLoading = true;
  int selectedCategory = 0;
  String searchQuery = '';
  var all = [];


  _getAllProducts(String category) async {
    setState(() {
      isLoading = true;
    });

    try {
      final allProducts =  await _productService.getProductsByCategoryLocally(category);
      setState(() {
        all = allProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }

  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(all, (query) {
        setState(() {
          searchQuery = query;
        });
      }),
    );
  }

  List<dynamic> get filteredProducts {
    var products = all;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      products = products.where((p) {
        final name = p.name.toLowerCase();
        final brand = p.brandName.toLowerCase();
        final description = p.description.toLowerCase();
        final query = searchQuery.toLowerCase();
        return name.contains(query) || brand.contains(query) || description.contains(query);
      }).toList();
    }

    return products;
  }

  @override
  void initState() {
    super.initState();
    _getAllProducts(widget.category);
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
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "${category}s",
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: 18,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
                LucideIcons.search,
                color: isDark ? Colors.white70 : Colors.black54
            ),
            onPressed: _openSearch,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Browse Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Browse Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    letterSpacing: 1
                ),
              ),
            ),

            const SizedBox(height: 24),


            // Product Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (searchQuery.isNotEmpty)

                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [

                          Text(
                            'Results for "$searchQuery"',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                                fontFamily: 'Poppins',
                                letterSpacing: 1
                            ),
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () {
                              setState(() {
                                searchQuery = '';
                              });
                            },
                            child: const Text(
                                'Clear',
                              style: TextStyle(
                                color: Colors.red,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )

                  else if (filteredProducts.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [

                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),

                            const SizedBox(height: 16),

                            Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  else
                    ...filteredProducts.map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildProductCard(
                          product
                        ),
                      );
                    }),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }



  Widget _buildProductCard(ProductModel product) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.cardTheme.color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image Section
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),

                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.network(
                          width: double.infinity,
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.water_drop,
                              color: const Color(0xFF4FC3DC),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),


            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // brand name
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.brandName!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              letterSpacing: 1
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // product name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 1
                    ),
                  ),

                  const SizedBox(height: 8),

                  // sub titles
                  Text(
                    product.subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                        fontFamily: 'Poppins',
                        letterSpacing: 1
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 16),

                  // skin types
                  if (product.skinType != [])
                    SizedBox(
                    height: 28,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: product.skinType!.map((type) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.blue.shade600.withValues(alpha: 0.2)
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            type,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 1
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  if (product.skinType != [])
                    const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Color(0xFFFF9B7A).withValues(alpha: 0.9)
                            : Color(0xFFFF9B7A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),

                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                letterSpacing: 1
                            ),
                          ),

                          SizedBox(width: 8),

                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

