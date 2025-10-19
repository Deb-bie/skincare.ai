import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:skincareai/screens/product_details/product_details.dart';

import '../../data/mock_data.dart';
import '../../providers/browse_tab_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/build_product_card.dart';
import '../../widgets/category_product.dart';
import '../../widgets/see_all_category_card.dart';

class HomePage extends StatefulWidget {
  final PersistentTabController controller;
  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Cleansers';

  final Map<String, List<Map<String, String>>> _categoryProducts = {
    'Cleansers': [
      {'title': 'Gentle Balm', 'subtitle': 'Melts makeup.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Foaming Cleanser', 'subtitle': 'Deep cleanses.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Micellar Water', 'subtitle': 'Removes impurities.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Oil Cleanser', 'subtitle': 'Dissolves oil.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Cream Cleanser', 'subtitle': 'Nourishing formula.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
    ],
    'Moisturizers': [
      {'title': 'Daily Cream', 'subtitle': 'Lightweight hydration.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Night Cream', 'subtitle': 'Rich and nourishing.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Gel Moisturizer', 'subtitle': 'Oil-free formula.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Face Oil', 'subtitle': 'Deep nourishment.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Hydrating Lotion', 'subtitle': 'All-day moisture.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
    ],
    'Serums': [
      {'title': 'Vitamin C Serum', 'subtitle': 'Brightening power.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Hyaluronic Acid', 'subtitle': 'Intense hydration.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Retinol Serum', 'subtitle': 'Anti-aging formula.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Niacinamide', 'subtitle': 'Pore refining.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Peptide Serum', 'subtitle': 'Firming effect.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
    ],
    'SPF': [
      {'title': 'Daily SPF 50', 'subtitle': 'Broad spectrum.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Tinted Sunscreen', 'subtitle': 'Light coverage.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Mineral SPF', 'subtitle': 'Gentle protection.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'SPF Moisturizer', 'subtitle': 'Hydrate & protect.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
      {'title': 'Sport Sunscreen', 'subtitle': 'Water-resistant.', 'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400&q=80'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'mySkiincare',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
                CupertinoIcons.search,
                color: Colors.grey,
                size: 24
            ),
            onPressed: () {
              controller.jumpToTab(1);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // AI Expert Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  controller.jumpToTab(3);
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4F5F6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9AEFEF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.smart_toy_outlined,
                          color: Color(0xFF15ECEC),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ask a Skincare Expert',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Get personalized advice from our AI.',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Inter',
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade700,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),


            // Today's Top Picks
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Top Picks",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    )
                  ),

                  SizedBox(width: 2),

                  InkWell(
                    onTap: () {
                      context.read<NavigationProvider>().setIndex(1);
                    },
                    child: Text(
                        "See all",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          decorationThickness: 2,
                        )
                    ),
                  ),
                ],
              )
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (context, _) => const SizedBox(width: 16,),
                itemCount: mockTopPicks.length,
                itemBuilder: (context, index) {
                  final product = mockTopPicks[index];
                  return InkWell(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: ProductDetailsPage(product: product),
                        withNavBar: true, // ✅ keeps bottom nav visible
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );


                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => ProductDetailsPage(product: product),
                      //   )
                      // );
                    },
                    child: buildProductCard(
                        product.name,
                        product.subtitle,
                        Colors.grey.shade200,
                        product.image
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: 32),



            // Explore Categories
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Explore Categories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // tabs for categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryTab('Cleansers'),
                  const SizedBox(width: 24),
                  _buildCategoryTab('Moisturizers'),
                  const SizedBox(width: 24),
                  _buildCategoryTab('Serums'),
                  const SizedBox(width: 24),
                  _buildCategoryTab('SPF'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 30,
                  childAspectRatio: 0.60,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index == 5) {
                    return InkWell(
                      onTap: () {
                        context.read<NavigationProvider>().setIndex(1);
                        context.read<BrowseTabProvider>().setBrowseTab(1);
                      },
                        child: buildSeeAllCategoryCard(_selectedCategory)
                    );
                  }
                  final products = _categoryProducts[_selectedCategory]!;
                  final product = products[index];
                  final colors = [
                    Colors.grey.shade100,
                    const Color(0xFFB8E8DC),
                    const Color(0xFFE8D4C0),
                    const Color(0xFFD4E8F0),
                    const Color(0xFFFBE5D6)
                  ];
                  return buildCategoryProduct(
                      product['title']!,
                      product['subtitle']!,
                      colors[index % colors.length],
                      product['image']!
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label) {
    final bool isSelected = _selectedCategory == label;
    return InkWell(
      onTap: () => setState(
              () => _selectedCategory = label
      ),
      child: Column(
        children: [
          Text(
              label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontFamily: 'Inter',
                  color: isSelected ? Colors.black : const Color(0xFF6CEAD9)
              )
          ),
          const SizedBox(height: 8),
          if (isSelected) Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                  color: const Color(0xFF00E5CC),
                  borderRadius: BorderRadius.circular(2)
              )
          ),
        ],
      ),
    );
  }

}
