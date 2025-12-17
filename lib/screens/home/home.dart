import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:myskiin/screens/product_details/product_details.dart';
import 'package:myskiin/screens/profile/profile_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/utils.dart';
import '../../enums/day_of_week.dart';
import '../../enums/routine_type.dart';
import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PersistentTabController _controller;
  int _selectedBottomNav = 0;
  String username = "";

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('_user');
    print("user in home: $user");

    if (user != null) {
      username = user;
    }
  }

  DayOfWeek _getCurrentDayOfWeek() {
    final now = DateTime.now();
    switch (now.weekday % 7) {
      case 0:
        return DayOfWeek.sunday;
      case 1:
        return DayOfWeek.monday;
      case 2:
        return DayOfWeek.tuesday;
      case 3:
        return DayOfWeek.wednesday;
      case 4:
        return DayOfWeek.thursday;
      case 5:
        return DayOfWeek.friday;
      case 6:
        return DayOfWeek.saturday;
      default:
        return DayOfWeek.sunday;
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekday = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'][now.weekday % 7];
    final month = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'][now.month - 1];
    return '$weekday, $month ${now.day}';
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);
    final currentDay = _getCurrentDayOfWeek();
    final today = DateTime.now();

    // Get routines with products organized by category
    final morningRoutine = routineProvider.getDayRoutine(currentDay, RoutineType.morning);
    final eveningRoutine = routineProvider.getDayRoutine(currentDay, RoutineType.evening);

    // Get products organized by category
    final morningProductsByCategory = morningRoutine?.stepsWithProducts ?? {};
    final eveningProductsByCategory = eveningRoutine?.stepsWithProducts ?? {};

    // Get completion data
    final morningCompleted = routineProvider.getCompletedSteps(today, RoutineType.morning);
    final morningTotal = routineProvider.getTotalSteps(today, RoutineType.morning);
    final eveningCompleted = routineProvider.getCompletedSteps(today, RoutineType.evening);
    final eveningTotal = routineProvider.getTotalSteps(today, RoutineType.evening);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child:
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'mySkiin',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Poppins',
                          letterSpacing: 2
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ProfilePage(controller: _controller)),
                        );
                        },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4D6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.userRound,
                          color: Color(0xFFFF9B7A),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              // Greeting
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16,12 ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      _getFormattedDate(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins"
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${_getGreeting()},',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        letterSpacing: 1
                      ),
                    ),

                    // if (username != null)
                      Text(
                        // username!,
                        "Ken",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                          letterSpacing: 1
                        ),
                      ),
                  ],
                ),
              ),

              // const SizedBox(height: 12),

              // Daily Skincare Focus
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: const Text(
                  'Daily Skincare Focus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    letterSpacing: 1
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Horizontal Scrollable Routines
              SizedBox(
                height: 280,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),

                  children: [
                    
                    _buildRoutineCard(
                      context,
                      'Morning Routine',
                      morningProductsByCategory,
                      morningCompleted,
                      morningTotal,
                      const Color(0xFFFF9B7A),
                      Color(0xEDF6FFFF),
                      // Colors.blue.shade50,
                      Icons.wb_sunny,
                      RoutineType.morning,
                      today,
                    ),

                    const SizedBox(width: 16),
                    _buildRoutineCard(
                      context,
                      'Evening Routine',
                      eveningProductsByCategory,
                      eveningCompleted,
                      eveningTotal,
                      const Color(0xFF9B7AFF),
                      Colors.blue.shade100,
                      Icons.nightlight,
                      RoutineType.evening,
                      today,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Product Discovery
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Text(
                  'Product Discovery',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [

                  _buildCategoryCard(
                    'Cleansers',
                    'Foundational care',
                    const Color(0xFFE3F2FD),
                    Icons.water_drop_outlined,
                    const Color(0xFF4FC3DC),
                  ),

                _buildCategoryCard(
                  'Toners',
                  'Balance & prep',
                  const Color(0xFFE1F5FE),
                  Icons.opacity_outlined,
                  const Color(0xFF4FC3DC),
                ),
                _buildCategoryCard(
                  'Serums',
                  'Targeted treatment',
                  const Color(0xFFF3E5FF),
                  Icons.science_outlined,
                  const Color(0xFF9B7AFF),
                ),
                _buildCategoryCard(
                  'Eye Care',
                  'Delicate area support',
                  const Color(0xFFFFF3E0),
                  Icons.remove_red_eye_outlined,
                  const Color(0xFFFFB74D),
                ),
                _buildCategoryCard(
                  'Moisturizers',
                  'Hydration lock',
                  const Color(0xFFE0F7FA),
                  Icons.water_outlined,
                  const Color(0xFF4FC3DC),
                ),
                _buildCategoryCard(
                  'Sun Care',
                  'Daily protection',
                  const Color(0xFFFFF3E0),
                  Icons.wb_sunny_outlined,
                  const Color(0xFFFFB74D),
                ),
                _buildCategoryCard(
                  'Masks',
                  'Weekly boost',
                  const Color(0xFFE8F5E9),
                  Icons.face_outlined,
                  const Color(0xFF66BB6A),
                ),
                _buildCategoryCard(
                  'Exfoliants',
                  'Skin renewal',
                  const Color(0xFFFCE4EC),
                  Icons.auto_awesome_outlined,
                  const Color(0xFFEC407A),
                ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

    );
  }


  Widget _buildRoutineCard(
      BuildContext context,
      String title,
      Map<dynamic, List<ProductModel>> productsByCategory,
      int stepsComplete,
      int totalSteps,
      Color accentColor,
      Color colors,
      IconData icon,
      RoutineType routineType,
      DateTime date,
      ) {
    final progress = totalSteps > 0 ? stepsComplete / totalSteps : 0.0;
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);

    // Flatten products in the order they appear in the map (preserves RoutineProvider order)
    final allProducts = productsByCategory.values
        .expand((products) => products)
        .toList();

    // Find the next product to display based on completion status
    ProductModel? currentProduct;
    int currentIndex = 0;

    for (int i = 0; i < allProducts.length; i++) {
      final product = allProducts[i];
      final isCompleted = routineProvider.isProductCompleted(date, routineType, product.id);
      final isSkipped = routineProvider.isProductSkipped(date, routineType, product.id);

      if (!isCompleted && !isSkipped) {
        currentProduct = product;
        currentIndex = i;
        break;
      }
    }

    // If all products are completed/skipped, show the last product
    if (currentProduct == null && allProducts.isNotEmpty) {
      currentProduct = allProducts.last;
      currentIndex = allProducts.length - 1;
    }

    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.white, Colors.white, colors],
          stops: const [0.75, 0.7, 0.0],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(icon, color: accentColor, size: 20),

              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",

                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            '$stepsComplete/$totalSteps steps complete',
            style: TextStyle(
              fontSize: 12,
              color: accentColor,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: accentColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 16),

          if (currentProduct != null) ...[
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductDetailsPage(product: currentProduct!)),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: const Color(0xFFF8F8F8),
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
              
                      decoration: BoxDecoration(
                        color: const Color(0xFF4FC3DC).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
              
                      child: currentProduct.image != null
                          ? ClipOval(
                              child: Image.network(
                                currentProduct.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.water_drop,
                                    color: const Color(0xFF4FC3DC),
                                  );
                                },
                              ),
                          )
                          : Icon(
                            Icons.water_drop,
                            color: const Color(0xFF4FC3DC),
                          ),
                    ),
              
                    const SizedBox(width: 12),
              
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
              
                          Text(
                            currentProduct.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
              
                          const SizedBox(height: 4),
              
              
                          if (currentProduct.brandName != null)
                            Text(
                              currentProduct.brandName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: "Poppins",
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
              
                    const SizedBox(width: 12),
              
                    GestureDetector(
                      onTap: () {
                        routineProvider.toggleProductCompletion(
                          date,
                          routineType,
                          currentProduct!.id,
                        );
                      },
              
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: routineProvider.isProductCompleted(date, routineType, currentProduct.id)
                          ? accentColor
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: routineProvider.isProductCompleted(date, routineType, currentProduct.id)
                                ? accentColor
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
              
                        child: routineProvider.isProductCompleted(date, routineType, currentProduct.id)
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add products to your routine',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 22),

          Wrap(
            spacing: 8, // Space between circles
            runSpacing: 8, // Space between rows if they wrap
            alignment: WrapAlignment.start,
            children: List.generate(
              allProducts.length,
                  (index) {
                final product = allProducts[index];
                final isCompleted = routineProvider.isProductCompleted(date, routineType, product.id);
                final isSkipped = routineProvider.isProductSkipped(date, routineType, product.id);
                final isCurrent = index == currentIndex;

                // Calculate circle size based on number of products
                double circleSize;
                double iconSize;
                if (allProducts.length <= 5) {
                  circleSize = 36;
                  iconSize = 18;
                } else if (allProducts.length <= 8) {
                  circleSize = 32;
                  iconSize = 16;
                } else if (allProducts.length <= 12) {
                  circleSize = 28;
                  iconSize = 14;
                } else {
                  circleSize = 24;
                  iconSize = 12;
                }

                // Get the category icon for this product
                final categoryIcon = getCategoryIcon(
                    product.categoryNames?.isNotEmpty == true
                        ? product.categoryNames!.first
                        : null
                );

                return Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF4FC3DC).withOpacity(0.2)
                        : isCurrent
                        ? accentColor.withOpacity(0.3)
                        : Colors.grey[200],
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: accentColor, width: 1)
                        : null,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check
                        : isSkipped
                        ? Icons.close
                        : categoryIcon, // Use category-specific icon
                    size: isCompleted || isSkipped ? iconSize : iconSize * 0.9,
                    color: isCompleted
                        ? const Color(0xFF4FC3DC)
                        : isCurrent
                        ? accentColor
                        : Colors.grey[400],
                  ),
                );
              },
            ),
          ),

        ],
      ),

    );

  }


  Widget _buildCategoryCard(
      String title,
      String subtitle,
      Color bgColor,
      IconData icon,
      Color iconColor,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins"
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: "Poppins"
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientCard(
      String name,
      String subtitle,
      Color color,
      ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





class _CurvedGradientPainter extends CustomPainter {
  final Color accentColor;

  _CurvedGradientPainter(this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw white background first
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), whitePaint);

    // Create curved gradient path
    final path = Path();
    path.moveTo(size.width * 0.4, 0); // Start from top
    path.quadraticBezierTo(
      size.width * 0.7, size.height * 0.3, // Control point
      size.width, size.height * 0.6, // End point on right side
    );
    path.lineTo(size.width, size.height); // Bottom right
    path.lineTo(size.width * 0.4, size.height); // Bottom left of gradient
    path.close();

    // Create radial gradient for smooth color spread
    final gradient = RadialGradient(
      center: Alignment.topRight,
      radius: 1.0,
      colors: [
        accentColor.withOpacity(0.12),
        accentColor.withOpacity(0.06),
        accentColor.withOpacity(0.02),
        Colors.transparent,
      ],
      stops: const [0.0, 0.4, 0.7, 1.0],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurvedGradientPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor;
  }
}
