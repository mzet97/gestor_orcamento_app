import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'charts.dart' as charts;

// Alias para expor LegendPosition sem precisar importar charts.dart diretamente
typedef LegendPosition = charts.LegendPosition;

class LazyExpensePieChart extends StatefulWidget {
  final Map<String, double> data;
  final Duration? delay;
  final LegendPosition legendPosition;

  const LazyExpensePieChart({
    Key? key,
    required this.data,
    this.delay,
    this.legendPosition = charts.LegendPosition.bottom,
  }) : super(key: key);

  @override
  State<LazyExpensePieChart> createState() => _LazyExpensePieChartState();
}

class _LazyExpensePieChartState extends State<LazyExpensePieChart> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VisibilityDetector(
      key: Key('pie_chart_${widget.data.hashCode}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible
          ? _buildChart(theme)
          : Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildChart(ThemeData theme) {
    return charts.ExpensePieChart(
      data: widget.data,
      legendPosition: widget.legendPosition,
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: widget.delay ?? 0.ms)
        .scale();
  }
}

class LazyMonthlyBarChart extends StatefulWidget {
  final List<double> monthlyData;
  final Duration? delay;

  const LazyMonthlyBarChart({
    Key? key,
    required this.monthlyData,
    this.delay,
  }) : super(key: key);

  @override
  State<LazyMonthlyBarChart> createState() => _LazyMonthlyBarChartState();
}

class _LazyMonthlyBarChartState extends State<LazyMonthlyBarChart> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VisibilityDetector(
      key: Key('bar_chart_${widget.monthlyData.hashCode}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible
          ? _buildChart(theme)
          : Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildChart(ThemeData theme) {
    return charts.MonthlyBarChart(monthlyData: widget.monthlyData)
        .animate()
        .fadeIn(duration: 800.ms, delay: widget.delay ?? 0.ms)
        .scale();
  }
}

class LazyExpenseTimeline extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Duration? delay;

  const LazyExpenseTimeline({
    Key? key,
    required this.transactions,
    this.delay,
  }) : super(key: key);

  @override
  State<LazyExpenseTimeline> createState() => _LazyExpenseTimelineState();
}

class _LazyExpenseTimelineState extends State<LazyExpenseTimeline> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.transactions.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma transação recente',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return VisibilityDetector(
      key: Key('timeline_${widget.transactions.hashCode}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible
          ? ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transaction = widget.transactions[index];
                return _TimelineItem(
                  title: transaction['title'],
                  amount: transaction['amount'],
                  date: transaction['date'],
                  category: transaction['category'],
                  isIncome: transaction['isIncome'] ?? false,
                )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(
                          milliseconds: (widget.delay?.inMilliseconds ?? 0) +
                              (index * 100)),
                    )
                    .slideX(begin: -0.2, end: 0);
              },
            )
          : Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final double amount;
  final String date;
  final String category;
  final bool isIncome;

  const _TimelineItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isIncome
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIncome
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isIncome
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}