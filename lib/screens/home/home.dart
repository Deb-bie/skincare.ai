import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:myskiin/screens/products/discover_product.dart';
import 'package:myskiin/screens/settings/settings_page.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../enums/day_of_week.dart';
import '../../enums/routine_type.dart';
import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';
import '../../services/data_manager/hive_models/user/hive_user_model.dart';
import '../product_details/product_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    final userBox = Hive.box<HiveUserModel>('users');
    final user = userBox.get('currentUser');
    if (user != null) {
      username = user.username!;
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final routineProvider = Provider.of<RoutineProvider>(context);
    final currentDay = _getCurrentDayOfWeek();
    final today = DateTime.now();

    final morningRoutine = routineProvider.getDayRoutine(currentDay, RoutineType.morning);
    final eveningRoutine = routineProvider.getDayRoutine(currentDay, RoutineType.evening);

    final morningProductsByCategory = morningRoutine?.stepsWithProducts ?? {};
    final eveningProductsByCategory = eveningRoutine?.stepsWithProducts ?? {};

    final morningCompleted = routineProvider.getCompletedSteps(today, RoutineType.morning);
    final morningTotal = routineProvider.getTotalSteps(today, RoutineType.morning);
    final eveningCompleted = routineProvider.getCompletedSteps(today, RoutineType.evening);
    final eveningTotal = routineProvider.getTotalSteps(today, RoutineType.evening);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      'mySkiin',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 3,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsPage()),
                        );
                      },

                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFFFF9B7A).withValues(alpha: 0.2)
                              : const Color(0xFFFFE4D6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.settings,
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      _getFormattedDate(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${_getGreeting()},',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 24,
                        letterSpacing: 1,
                      ),
                      maxLines: 1,
                    ),

                    if (username != '')

                      Text(
                        username[0].toUpperCase() + username.substring(1),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 24,
                          letterSpacing: 1,
                        ),
                      ),
                  ],
                ),
              ),


              const SizedBox(height: 10),

              // Daily Skincare Focus
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
                child: Text(
                  'Daily Skincare Focus',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 10),


              // Horizontal Scrollable Routines
              SizedBox(
                height: 290,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  children: [

                    _buildRoutineCard(
                      context,
                      'Morning Routine',
                      morningProductsByCategory,
                      morningCompleted,
                      morningTotal,
                      const Color(0xFFFF9B7A),
                      isDark
                          ? const Color(0xFFFF9B7A).withValues(alpha: 0.1)
                          : const Color(0xEDF6FFFF),
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
                      // const Color(0xFF9B7AFF),
                        Colors.deepPurple,
                      isDark
                          ? Colors.deepPurple.withValues(alpha: 0.1)
                          : Colors.blue.shade50,
                      Icons.nightlight,
                      RoutineType.evening,
                      today,
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 40),

              // Product Discovery
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Product Discovery',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
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
                  childAspectRatio: 1.1,
                  children: [

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Cleanser"),
                          ),
                        );
                      },

                      child: _buildCategoryCard(
                        'Cleansers',
                        'Foundational care',
                        isDark
                            ? Color(0xFF4FC3DC).withValues(alpha: 0.2)
                            : const Color(0xFFE3F2FD),
                        Icons.water_drop_outlined,
                        const Color(0xFF4FC3DC),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Toner"),
                          ),
                        );
                      },

                      child: _buildCategoryCard(
                        'Toners',
                        'Balance & prep',
                        isDark
                            ? Color(0xFF4FC3DC).withValues(alpha: 0.2)
                            : const Color(0xFFE1F5FE),
                        Icons.opacity_outlined,
                        const Color(0xFF4FC3DC),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Serum"),
                          ),
                        );
                      },
                      child: _buildCategoryCard(
                        'Serums',
                        'Targeted treatment',
                        isDark
                            ? Color(0xFF9B7AFF).withValues(alpha: 0.2)
                            : Color(0xFFF3E5FF),
                        Icons.science_outlined,
                        const Color(0xFF9B7AFF),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Eye Cream"),
                          ),
                        );
                      },

                      child: _buildCategoryCard(
                        'Eye Care',
                        'Delicate area support',
                        isDark
                            ? Color(0xFFFFB74D).withValues(alpha: 0.2)
                            : Color(0xFFFFF3E0),
                        Icons.remove_red_eye_outlined,
                        const Color(0xFFFFB74D),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Moisturizer"),
                          ),
                        );
                      },

                      child: _buildCategoryCard(
                        'Moisturizers',
                        'Hydration lock',
                        isDark
                            ? Color(0xFF4FC3DC).withValues(alpha: 0.2)
                            : Color(0xFFE0F7FA),
                        Icons.water_outlined,
                        const Color(0xFF4FC3DC),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Sunscreen"),
                          ),
                        );
                      },

                      child: _buildCategoryCard(
                        'Sun Care',
                        'Daily protection',
                        isDark
                            ? Color(0xFFFFB74D).withValues(alpha: 0.2)
                            : Color(0xFFFFF3E0),
                        Icons.wb_sunny_outlined,
                        const Color(0xFFFFB74D),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Face Mask"),
                          ),
                        );
                      },

                      child: _buildCategoryCard(
                        'Masks',
                        'Weekly boost',
                        isDark
                            ? Color(0xFF66BB6A).withValues(alpha: 0.2)
                            : Color(0xFFE8F5E9),
                        Icons.face_outlined,
                        const Color(0xFF66BB6A),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverProduct(category: "Exfoliant"),
                          ),
                        );
                      },

                      child: _buildCategoryCard(
                        'Exfoliants',
                        'Skin renewal',
                        isDark
                            ? Color(0xFFEC407A).withValues(alpha: 0.2)
                            : Color(0xFFFCE4EC),
                        Icons.auto_awesome_outlined,
                        const Color(0xFFEC407A),
                      ),
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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = totalSteps > 0 ? stepsComplete / totalSteps : 0.0;
    final routineProvider = Provider.of<RoutineProvider>(context, listen: false);

    final allProducts = productsByCategory.values.expand((products) => products).toList();

    ProductModel? currentProduct;
    int currentIndex = 0;

    for (int i = 0; i < allProducts.length; i++) {
      final product = allProducts[i];
      final isCompleted = routineProvider.isProductCompleted(date, routineType, product.id!);
      final isSkipped = routineProvider.isProductSkipped(date, routineType, product.id!);

      if (!isCompleted && !isSkipped) {
        currentProduct = product;
        currentIndex = i;
        break;
      }
    }

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
          colors: isDark
              ? [theme.cardTheme.color!, theme.cardTheme.color!, colors]
              : [Colors.white, Colors.white, colors],
          stops: const [0.75, 0.7, 0.0],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
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

              Icon(
                  icon,
                  color: accentColor,
                  size: 20
              ),

              const SizedBox(width: 8),

              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
              backgroundColor: accentColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 16),

          if (currentProduct != null) ...[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: currentProduct!),
                  ),
                );
              },

              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
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
                        color: const Color(0xFF4FC3DC).withValues(alpha: 0.2),
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
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          if (currentProduct.brandName != null)
                            Text(
                              currentProduct.brandName!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12,
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
                          currentProduct!.id!,
                        );
                      },

                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: routineProvider.isProductCompleted(date, routineType, currentProduct.id!)
                              ? accentColor
                              : (isDark ? Colors.grey[700] : Colors.grey[300]),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: routineProvider.isProductCompleted(date, routineType, currentProduct.id!)
                                ? accentColor
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: routineProvider.isProductCompleted(date, routineType, currentProduct.id!)
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
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
                color: isDark ? Colors.grey[800] : const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Center(
                child: Column(
                  children: [

                    Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 32,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Add products to your routine',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 22),


          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allProducts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final product = allProducts[index];
                final isCompleted = routineProvider.isProductCompleted(date, routineType, product.id!);
                final isSkipped = routineProvider.isProductSkipped(date, routineType, product.id!);
                final isCurrent = index == currentIndex;

                const circleSize = 36.0;
                const iconSize = 18.0;

                final categoryIcon = getCategoryIcon(
                    product.categoryNames?.isNotEmpty == true ? product.categoryNames!.first : null);

                return Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF4FC3DC).withValues(alpha: 0.2)
                        : isCurrent
                        ? accentColor.withValues(alpha: 0.3)
                        : (isDark ? Colors.grey[800] : Colors.grey[200]),
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: accentColor, width: 1) : null,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check
                        : isSkipped
                        ? Icons.close
                        : categoryIcon,
                    size: isCompleted || isSkipped ? iconSize : iconSize * 0.9,
                    color: isCompleted
                        ? const Color(0xFF4FC3DC)
                        : isCurrent
                        ? accentColor
                        : (isDark ? Colors.grey[600] : Colors.grey[400]),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
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
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
