import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myskiin/screens/main/main_page.dart';
import 'package:myskiin/screens/product_details/product_details.dart';
import 'package:myskiin/services/data_manager/data_manager.dart';
import 'package:provider/provider.dart';

import '../../enums/product_categories.dart';
import '../../enums/routine_type.dart';
import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';
import '../../services/data_manager/hive_models/hive_assessment_model.dart';
import '../../services/data_manager/hive_models/user/hive_user_model.dart';
import '../../services/skin_analysis/enhanced_analysis.dart';

class SuggestedRoutineScreen extends StatefulWidget {
  final HiveAssessmentModel? assessment;

  const SuggestedRoutineScreen({
    super.key, this.assessment,
  });

  @override
  State<SuggestedRoutineScreen> createState() => _SuggestedRoutineScreenState();
}

class _SuggestedRoutineScreenState extends State<SuggestedRoutineScreen> {
  final DataManager _dataManager = DataManager();

  int _selectedTab = 0;
  bool _isLoading = true;
  String? _errorMessage;

  // Analysis results
  Map<String, dynamic>? _analysisResults;
  List<Map<String, dynamic>> _morningRoutine = [];
  List<Map<String, dynamic>> _eveningRoutine = [];

  // Track added products by product ID (not category)
  final Set<String> _morningAddedProducts = {};
  final Set<String> _eveningAddedProducts = {};

  // Store products in order with their categories
  final List<MapEntry<ProductCategory, ProductModel>> _morningProductsInOrder = [];
  final List<MapEntry<ProductCategory, ProductModel>> _eveningProductsInOrder = [];

  final EnhancedSkinAnalysisService _analysisService = EnhancedSkinAnalysisService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }


  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final assessment = widget.assessment;

      if (assessment == null) {
        throw Exception('No assessment found. Please complete the skin assessment first.');
      }

      // Check for empty/null fields
      if (assessment.skinType == null || assessment.skinType!.isEmpty) {
        debugPrint('Warning: No skin type found');
      }
      if (assessment.skinConcerns == null || assessment.skinConcerns!.isEmpty) {
        debugPrint('Warning: No skin concerns found');
      }
      if (assessment.currentRoutine == null) {
        debugPrint('Warning: No routine level found');
      }

      final results = await _analysisService.analyzeAndRecommendWithProducts(assessment);

      setState(() {
        _analysisResults = results;
        _morningRoutine = List<Map<String, dynamic>>.from(
            results['routine']?['morning'] ?? []
        );
        _eveningRoutine = List<Map<String, dynamic>>.from(
            results['routine']?['evening'] ?? []
        );
        _isLoading = false;
      });

      _autoAddAllProducts();

    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      setState(() {
        _errorMessage = 'Failed to load recommendations: $e';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }


  void _autoAddAllProducts() {
    // Clear previous data
    _morningProductsInOrder.clear();
    _eveningProductsInOrder.clear();
    _morningAddedProducts.clear();
    _eveningAddedProducts.clear();

    // Auto-add all morning products IN ORDER
    for (var step in _morningRoutine) {
      try {
        final product = step['product'];
        if (product == null) {
          continue;
        }

        final ProductModel productModel = product as ProductModel;
        final String stepName = step['step'] ?? '';

        if (productModel.id == null || productModel.id!.isEmpty) {
          continue;
        }

        final category = _getCategoryFromStep(stepName);

        _morningAddedProducts.add(productModel.id!);
        _morningProductsInOrder.add(MapEntry(category, productModel));
      } catch (e) {
        debugPrint("error: $e");
      }
    }

    // Auto-add all evening products IN ORDER
    for (var step in _eveningRoutine) {
      try {
        final product = step['product'];
        if (product == null) {
          continue;
        }

        final ProductModel productModel = product as ProductModel;
        final String stepName = step['step'] ?? '';

        if (productModel.id == null || productModel.id!.isEmpty) {
          continue;
        }

        final category = _getCategoryFromStep(stepName);

        _eveningAddedProducts.add(productModel.id!);
        _eveningProductsInOrder.add(MapEntry(category, productModel));
      } catch (e) {
        debugPrint('Error adding evening product: $e');
      }
    }
    setState(() {});
  }


  ProductCategory _getCategoryFromStep(String stepName) {
    final lowerStep = stepName.toLowerCase();

    if (lowerStep.contains('cleanser') || lowerStep.contains('cleanse')) {
      return ProductCategory.cleanser;
    } else if (lowerStep.contains('toner')) {
      return ProductCategory.toner;
    } else if (lowerStep.contains('serum') || lowerStep.contains('treatment')) {
      return ProductCategory.serum;
    } else if (lowerStep.contains('moisturizer') || lowerStep.contains('moisturiz')) {
      return ProductCategory.moisturizer;
    } else if (lowerStep.contains('sunscreen') || lowerStep.contains('spf') || lowerStep.contains('protect')) {
      return ProductCategory.sunscreen;
    } else if (lowerStep.contains('eye')) {
      return ProductCategory.eyeCream;
    } else if (lowerStep.contains('exfoliat')) {
      return ProductCategory.exfoliator;
    } else if (lowerStep.contains('mask')) {
      return ProductCategory.faceMask;
    } else {
      return ProductCategory.serum;
    }
  }


  Set<String> get _currentAddedProducts {
    return _selectedTab == 0 ? _morningAddedProducts : _eveningAddedProducts;
  }


  List<MapEntry<ProductCategory, ProductModel>> get _currentProductsInOrder {
    return _selectedTab == 0 ? _morningProductsInOrder : _eveningProductsInOrder;
  }


  List<Map<String, dynamic>> get _currentRoutine {
    return _selectedTab == 0 ? _morningRoutine : _eveningRoutine;
  }


  void _toggleProduct(ProductModel product, String stepName, {ProductModel? alternative}) {
    final category = _getCategoryFromStep(stepName);
    final productToToggle = alternative ?? product;

    setState(() {
      if (_currentAddedProducts.contains(productToToggle.id)) {
        // Remove product
        _currentAddedProducts.remove(productToToggle.id);
        _currentProductsInOrder.removeWhere((entry) => entry.value.id == productToToggle.id);
      } else {
        // Add product
        _currentAddedProducts.add(productToToggle.id!);

        int insertIndex = _findInsertPosition(category);
        _currentProductsInOrder.insert(insertIndex, MapEntry(category, productToToggle));
      }
    });
  }


  int _findInsertPosition(ProductCategory category) {
    final categoryOrder = [
      ProductCategory.cleanser,
      ProductCategory.toner,
      ProductCategory.serum,
      ProductCategory.eyeCream,
      ProductCategory.moisturizer,
      ProductCategory.sunscreen,
      ProductCategory.exfoliator,
      ProductCategory.faceMask,
    ];

    final categoryIndex = categoryOrder.indexOf(category);

    // Find the last product with a category that comes before or at the same position
    for (int i = _currentProductsInOrder.length - 1; i >= 0; i--) {
      final existingCategoryIndex = categoryOrder.indexOf(_currentProductsInOrder[i].key);
      if (existingCategoryIndex <= categoryIndex) {
        return i + 1;
      }
    }

    return 0;
  }


  Future<void> _saveRoutine() async {
    // Validate that at least one routine has products
    if (_morningProductsInOrder.isEmpty && _eveningProductsInOrder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one product to your routine'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Convert to Map<ProductCategory, List<ProductModel>>
    final morningMap = _convertToProductMap(_morningProductsInOrder);
    final eveningMap = _convertToProductMap(_eveningProductsInOrder);

    // This is what your provider expects
    final typeWithProducts = {
      RoutineType.morning: morningMap,
      RoutineType.evening: eveningMap,
    };


    try {
      // Save both types at once
      await context.read<RoutineProvider>().saveInitialRoutine(typeWithProducts);

      if (mounted) {
        final userBox = Hive.box<HiveUserModel>('users');
        final user = userBox.get('currentUser');
        if (user != null) {
          _dataManager.syncRoutineAfterLogin(user.uid);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage()
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save routine: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  // Convert List<MapEntry> to Map<ProductCategory, List<ProductModel>>
  Map<ProductCategory, List<ProductModel>> _convertToProductMap(List<MapEntry<ProductCategory, ProductModel>> productsInOrder) {
    final result = <ProductCategory, List<ProductModel>>{};
    for (var entry in productsInOrder) {
      result.putIfAbsent(entry.key, () => []);
      result[entry.key]!.add(entry.value);
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Suggested Skincare Routine',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.iconTheme.color),
            onPressed: _loadRecommendations,
          ),
        ],
      ),

      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        )
            : _errorMessage != null
            ? _buildErrorView()
            : _buildMainContent(),
      ),
    );
  }

  Widget _buildErrorView() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadRecommendations,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progression = _analysisResults?['routine']['progression'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 2),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Complexity level badge
                  if (progression != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A59).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF7A59).withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Text(
                        '${progression['message']} (${progression['productCount']})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF7A59),
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  Text(
                    "Here's a personalized routine based on your skin assessment. Products are auto-added but you can customize.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Tab selector
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildTab('Morning', 0)),
                        Expanded(child: _buildTab('Evening', 1)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Routine steps
                  _currentRoutine.isEmpty
                      ? Center(
                    child: Text(
                      'No products recommended for this routine',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  )
                      : Column(
                    children: List.generate(
                      _currentRoutine.length,
                          (index) => _buildRoutineStep(
                        index + 1,
                        _currentRoutine[index],
                        index,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveRoutine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A59),
                  foregroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Suggested Routine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int tabIndex) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedTab == tabIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tabIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.grey[700] : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildRoutineStep(int stepNumber, Map<String, dynamic> step, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ProductModel product = step['product'];
    final List<ProductModel> alternatives =
        (step['alternatives'] as List<dynamic>?)?.cast<ProductModel>() ?? [];
    final String stepName = step['step'];
    final String instruction = step['instruction'] ?? '';
    final bool isOptional = step['optional'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF7A59),
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
              if (index < _currentRoutine.length - 1)
                Container(
                  width: 1,
                  height: (1 + alternatives.length) * 250.0,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stepName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isOptional)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50.withValues(alpha: isDark ? 0.2 : 1.0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Optional',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                  ],
                ),
                if (instruction.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    instruction,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _buildProductCard(
                  product,
                  stepName,
                  _currentAddedProducts.contains(product.id),
                  isRecommended: true,
                ),
                if (alternatives.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Alternatives',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...alternatives.map((alt) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildProductCard(
                      alt,
                      stepName,
                      _currentAddedProducts.contains(alt.id),
                      isAlternative: true,
                      mainProduct: product,
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProductCard(
      ProductModel product,
      String stepName,
      bool isAdded, {
        bool isRecommended = false,
        bool isAlternative = false,
        ProductModel? mainProduct
      }) {
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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: isRecommended
              ? Border.all(color: const Color(0xFFFF7A59), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
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
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: product.image != null && product.image!.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('🧴', style: TextStyle(fontSize: 35)),
                        );
                      },
                    ),
                  )
                      : const Center(
                    child: Text('🧴', style: TextStyle(fontSize: 35)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.brandName?.toUpperCase() ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _toggleProduct(
                      product,
                      stepName,
                      alternative: isAlternative ? product : null,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isAdded
                          ? (isDark ? Colors.red[700]!.withValues(alpha: 0.3) : Colors.red.shade50)
                          : (isDark ? Colors.green[900]!.withValues(alpha: 0.3) : const Color(0xFFE8F5E9)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAdded ? Icons.close : Icons.add,
                          color: isAdded ? Colors.red.shade700 : const Color(0xFF4CAF50),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAdded ? 'Remove' : 'Add',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isAdded ? Colors.red.shade700 : const Color(0xFF4CAF50),
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (product.description != null && product.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                product.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (product.keyIngredients != null && product.keyIngredients!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: product.keyIngredients!.take(3).map((ingredient) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.blue[900]!.withValues(alpha: 0.3)
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ingredient,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                        fontFamily: "Poppins",
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (isRecommended) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A59).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 14, color: Color(0xFFFF7A59)),
                    SizedBox(width: 4),
                    Text(
                      'Top Match',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF7A59),
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
