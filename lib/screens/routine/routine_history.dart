import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/routine_type.dart';
import '../../providers/routine_provider.dart';
import '../../services/data_manager/hive_models/routines/hive_routine_completion.dart';

class RoutineHistoryScreen extends StatefulWidget {
  const RoutineHistoryScreen({super.key});

  @override
  State<RoutineHistoryScreen> createState() => _RoutineHistoryScreenState();
}


class _RoutineHistoryScreenState extends State<RoutineHistoryScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Routine History',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<RoutineProvider>(
        builder: (context, provider, child) {
          final stats = provider.getStatistics(days: 30);
          final monthHistory = provider.getMonthHistory(
            _selectedMonth.year,
            _selectedMonth.month,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(stats),

                const SizedBox(height: 24),
                _buildMonthSelector(),

                const SizedBox(height: 16),
                _buildCalendarHeatmap(provider),

                const SizedBox(height: 24),
                _buildHistoryList(monthHistory, provider),
              ],
            ),
          );
        },
      ),
    );
  }



  Widget _buildStatsSection(Map<String, dynamic> stats) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Current Streak',
                '${stats['currentStreak']} days',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Completion',
                '${stats['completionRate']}%',
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Completed',
                '${stats['completedRoutines']}',
                Icons.task_alt,
                Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Best Streak',
                '${stats['longestStreak']} days',
                Icons.star,
                Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildStatCard(
      String label,
      String value,
      IconData icon,
      Color color,
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
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMonthSelector() {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getMonthYearString(_selectedMonth),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: theme.iconTheme.color),
              onPressed: () {
                setState(() {
                  _selectedMonth = DateTime(
                    _selectedMonth.year,
                    _selectedMonth.month - 1,
                  );
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: theme.iconTheme.color),
              onPressed: () {
                final now = DateTime.now();
                if (_selectedMonth.year < now.year ||
                    (_selectedMonth.year == now.year &&
                        _selectedMonth.month < now.month)) {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month + 1,
                    );
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildCalendarHeatmap(RoutineProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final heatmapData = provider.getHeatmapData(firstDay, lastDay);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildHeatmapGrid(heatmapData, firstDay, lastDay),
          const SizedBox(height: 12),
          _buildHeatmapLegend(),
        ],
      ),
    );
  }


  Widget _buildHeatmapGrid(Map<DateTime, double> heatmapData, DateTime firstDay, DateTime lastDay) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];

    for (int i = 0; i < firstDay.weekday % 7; i++) {
      currentWeek.add(DateTime(1970));
    }

    for (var date = firstDay;
    date.isBefore(lastDay.add(const Duration(days: 1)));
    date = date.add(const Duration(days: 1))) {
      currentWeek.add(date);

      if (currentWeek.length == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }

    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    return Column(
      children: weeks.map((week) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: week.map((date) {
              if (date.year == 1970) {
                return const SizedBox(width: 32, height: 32);
              }

              final completion = heatmapData[date] ?? 0.0;
              final isToday = _isToday(date);

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getHeatmapColor(completion, isDark),
                  borderRadius: BorderRadius.circular(4),
                  border: isToday
                      ? Border.all(color: Colors.teal, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: completion > 0.3
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildHeatmapLegend() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Less',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 8),
        ...[0.0, 0.25, 0.5, 0.75, 1.0].map((value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getHeatmapColor(value, isDark),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          'More',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
          ),
        ),
      ],
    );
  }


  Widget _buildHistoryList(
      List<HiveRoutineCompletion> history,
      RoutineProvider provider,
      ) {
    final theme = Theme.of(context);

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No history for this month',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'History',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...history.map((completion) => _buildHistoryItem(completion, provider)),
      ],
    );
  }



  Widget _buildHistoryItem(HiveRoutineCompletion completion, RoutineProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dayOfWeek = provider.getDayOfWeekFromDate(completion.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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

      child: Row(
        children: [

          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: completion.isFullyCompleted
                  ? (isDark
                  ? Colors.teal.shade900.withValues(alpha: 0.3)
                  : Colors.teal.shade50)
                  : (isDark ? Colors.grey[800] : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  _getMonthAbbreviation(completion.date.month),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                  ),
                ),

                Text(
                  '${completion.date.day}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dayOfWeek.displayName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: completion.routineType == RoutineType.morning.name
                            ? (isDark
                            ? Colors.deepOrangeAccent.withValues(alpha: 0.3)
                            : Colors.orange.shade100)
                            : (isDark
                            ? Colors.indigo.shade500.withOpacity(0.3)
                            : Colors.indigo.shade100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        completion.routineType == RoutineType.morning.name
                            ? 'Morning'
                            : 'Evening',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: completion.routineType == RoutineType.morning.name
                              ? Colors.orange.shade700
                              : Colors.indigo.shade700,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  '${completion.completedProductIds.length}/${completion.totalProducts} products completed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                  ),
                ),
                if (completion.completedAt != null)
                  Text(
                    'Completed at ${_formatTime(completion.completedAt!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: completion.completionPercentage,
                    strokeWidth: 3,
                    backgroundColor: isDark
                        ? Colors.grey[700]
                        : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completion.isFullyCompleted
                          ? Colors.teal
                          : Colors.orange,
                    ),
                  ),
                ),
                Text(
                  '${(completion.completionPercentage * 100).toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Color _getHeatmapColor(double completion, bool isDark) {
    if (completion == 0) {
      return isDark ? Colors.grey[800]! : Colors.grey.shade200;
    }
    if (isDark) {
      if (completion < 0.25) return Colors.teal.shade900.withOpacity(0.4);
      if (completion < 0.5) return Colors.teal.shade800.withOpacity(0.6);
      if (completion < 0.75) return Colors.teal.shade700.withOpacity(0.8);
      return Colors.teal.shade600;
    } else {
      if (completion < 0.25) return Colors.teal.shade100;
      if (completion < 0.5) return Colors.teal.shade300;
      if (completion < 0.75) return Colors.teal.shade500;
      return Colors.teal.shade700;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    const abbr = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return abbr[month - 1];
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
