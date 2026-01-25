import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../enums/day_of_week.dart';
import '../../enums/product_categories.dart';
import '../../enums/routine_type.dart';
import '../../models/product/product_model.dart';
import '../../providers/routine_provider.dart';
import '../product_details/product_details.dart';
import 'edit_routine.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {

  late RoutineType _selectedRoutineType;
  DayOfWeek _selectedDay = DayOfWeek.sunday;
  late int selectedDayIndex;
  late List<String> dayLetters;
  late List<int> dates;
  late List<DateTime> dateObjects;
  late List<DayOfWeek> dayOfWeekList;

  DateTime get selectedDate => dateObjects[selectedDayIndex];


  void _initializeDates() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    dayLetters = [];
    dates = [];
    dateObjects = [];
    dayOfWeekList = [];

    for (int i = 0; i < 7; i++) {
      DateTime date = startOfWeek.add(Duration(days: i));
      dateObjects.add(date);

      // Map to DayOfWeek enum
      DayOfWeek dayOfWeek = _mapToDayOfWeek(date.weekday % 7);
      dayOfWeekList.add(dayOfWeek);

      // Get day letter
      dayLetters.add(dayOfWeek.letterName);

      // Get date number
      dates.add(date.day);

      // Set selected index to today
      if (date.day == now.day && date.month == now.month &&
          date.year == now.year) {
        selectedDayIndex = i;
        _selectedDay = dayOfWeek;
      }
    }
  }

  DayOfWeek _mapToDayOfWeek(int weekday) {
    switch (weekday) {
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

  int getTotalSteps() {
    return context.read<RoutineProvider>().getTotalSteps(
      selectedDate,
      _selectedRoutineType,
    );
  }


  int getCompletedSteps() {
    return context.read<RoutineProvider>().getCompletedSteps(
      selectedDate,
      _selectedRoutineType,
    );
  }


  @override
  void initState() {
    super.initState();
    _initializeDates();
    _selectedRoutineType = RoutineType.morning;
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Routine',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
            iconSize: 20,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRoutinePage(
                    routineType: _selectedRoutineType,
                    day: _selectedDay,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<RoutineProvider>(
        builder: (context, routineProvider, child) {
          return Column(
            children: [

              // Day selector with dates
              Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(dayLetters.length, (index) {
                    bool isSelected = index == selectedDayIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                          _selectedDay = dayOfWeekList[index];
                        });
                      },
                      child: Column(
                        children: [

                          Text(
                            dayLetters[index],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFFFF9B7A)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${dates[index]}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.grey[500] : Colors.grey[400]),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: (dateObjects[index].day == DateTime.now().day &&
                                  dateObjects[index].month == DateTime.now().month &&
                                  dateObjects[index].year == DateTime.now().year &&
                                  (routineProvider.hasRoutineForDay(
                                    dayOfWeekList[index],
                                    RoutineType.morning,
                                  ) ||
                                      routineProvider.hasRoutineForDay(
                                        dayOfWeekList[index],
                                        RoutineType.evening,
                                      )))
                                  ? colorScheme.onSurface
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 8),

              // Morning/Evening toggle and routine content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  children: [

                    // Morning/Evening Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Row(
                        children: [

                          Expanded(
                            child: _buildRoutineTypeTab(
                              'Morning',
                              RoutineType.morning,
                              Icons.wb_sunny,
                              const Color(0xFFFF9B7A),
                            ),
                          ),

                          Expanded(
                            child: _buildRoutineTypeTab(
                              'Evening',
                              RoutineType.evening,
                              Icons.nightlight,
                                Colors.deepPurple
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Routine content
                    _buildDayRoutineView(routineProvider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }



  Widget _buildRoutineTypeTab(String title, RoutineType type, IconData icon, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedRoutineType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoutineType = type;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
              ? Colors.grey[700]
              : Colors.white)
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

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? accentColor
                  : (
                  isDark
                      ? Colors.grey[600]
                      : Colors.grey[300]
                  ),
              size: 20,
            ),

            const SizedBox(width: 12),

            Text(
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
          ],
        ),
      ),
    );
  }


  Widget _buildDayRoutineView(RoutineProvider provider) {
    final theme = Theme.of(context);
    final routine = provider.getDayRoutine(_selectedDay, _selectedRoutineType);

    if (routine == null || routine.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 80),

            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 16),

            Text(
              'No routine set for ${_selectedDay.displayName}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _selectedRoutineType == RoutineType.morning ? 'Morning' : 'Evening',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Get sorted steps from provider
    final sortedSteps = provider.getSortedStepsForDay(
        _selectedDay,
        _selectedRoutineType
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(
              '${_selectedDay.displayName} ${_selectedRoutineType == RoutineType.morning ? "Morning" : "Evening"}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            Stack(
              alignment: Alignment.center,
              children: [

                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: getTotalSteps() > 0
                        ? getCompletedSteps() / getTotalSteps()
                        : 0,
                    strokeWidth: 2,
                    backgroundColor: theme.brightness == Brightness.dark
                        ? Colors.grey[700]
                        : Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _selectedRoutineType.name == "morning"
                          ? Color(0xFFFF9B7A)
                          : Colors.deepPurple
                    ),
                  ),
                ),

                Text(
                  '${getCompletedSteps()}/${getTotalSteps()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),

              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        ...sortedSteps.entries.map((entry) {
          final category = entry.key;
          final products = entry.value;

          return _buildRoutineStep(
            category,
            products,
            sortedSteps.keys.toList().indexOf(category),
            sortedSteps.length,
          );
        }),
      ],
    );
  }


  Widget _buildRoutineStep(
      ProductCategory category,
      List<ProductModel> products,
      int index,
      int prod) {
    final theme = Theme.of(context);
    final categoryIcon = getCategoryIcon(
        category.name.isNotEmpty == true
            ? category.name
            : null
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      categoryIcon,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category.name[0].toUpperCase() +
                          category.name.substring(1).toLowerCase(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildProductCard(product),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProductCard(ProductModel product) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<RoutineProvider>(
      builder: (context, provider, child) {
        final isCompleted = provider.isProductCompleted(
          selectedDate,
          _selectedRoutineType,
          product.id!,
        );

        final isSkipped = provider.isProductSkipped(
          selectedDate,
          _selectedRoutineType,
          product.id!,
        );

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
            provider.toggleProductSkip(
              selectedDate,
              _selectedRoutineType,
              product.id!,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: isCompleted && !isSkipped
                  ? Border.all(
                  color: _selectedRoutineType.name == "morning"
                      ? Color(0xFFFF9B7A)
                  : Colors.deepPurple,
                  width: 1)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey[800]
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: product.image!.isNotEmpty
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

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSkipped || isCompleted
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                              : theme.colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        product.brandName!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: isSkipped || isCompleted
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),


                // Checkbox or Skipped Badge
                if (isSkipped)
                  GestureDetector(
                    onTap: () {
                      provider.toggleProductSkip(
                        selectedDate,
                        _selectedRoutineType,
                        product.id!,
                      );
                    },

                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedRoutineType.name == "morning"
                            ? Color(0xFFFF9B7A).withValues(alpha: 0.2)
                            : Color(0xFF9B7AFF).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Text(
                        'Skipped',
                        style: TextStyle(
                          color: _selectedRoutineType.name == "morning"
                              ? Color(0xFFFF9B7A)
                              : Color(0xFF9B7AFF),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  )

                else
                  GestureDetector(
                    onTap: () {
                      provider.toggleProductCompletion(
                        selectedDate,
                        _selectedRoutineType,
                        product.id!,
                      );
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? (_selectedRoutineType.name == "morning"
                            ? Color(0xFFFF9B7A)
                            : Colors.deepPurple
                        )
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? (_selectedRoutineType.name == "morning"
                              ? Color(0xFFFF9B7A)
                          : Colors.deepPurple
                          )
                              : (isDark ? Colors.grey[600]! : Colors.grey.shade400),
                          width: 1,
                        ),
                      ),

                      child: isCompleted
                          ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white
                      )
                          : null,
                    ),
                  ),

                const SizedBox(width: 12),

                Icon(
                    Icons.more_vert_outlined,
                    color: theme.iconTheme.color?.withValues(alpha: 0.5)
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

