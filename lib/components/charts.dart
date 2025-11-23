import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum LegendPosition { bottom, left }

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> data;
  final Duration? delay;
  final LegendPosition legendPosition;

  const ExpensePieChart({
    Key? key,
    required this.data,
    this.delay,
    this.legendPosition = LegendPosition.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (data.isEmpty) {
      return Center(
        child: Text(
          'Nenhum dado disponível',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final total = data.values.reduce((a, b) => a + b);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.error,
      theme.colorScheme.primaryContainer,
      theme.colorScheme.secondaryContainer,
    ];

    List<PieChartSectionData> sections = [];
    int index = 0;

    data.forEach((category, value) {
      final percentage = (value / total * 100);
      sections.add(
        PieChartSectionData(
          color: colors[index % colors.length],
          value: value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 80,
          titleStyle: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          badgeWidget: _ChartBadge(
            icon: _getCategoryIcon(category),
            color: colors[index % colors.length],
          ),
          badgePositionPercentageOffset: 1.3,
        ),
      );
      index++;
    });

    Widget buildChartWidget() => PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 40,
            sectionsSpace: 2,
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                // Handle touch interactions
              },
            ),
          ),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (legendPosition == LegendPosition.left) {
          final legendWidth = math.min(160.0, constraints.maxWidth * 0.4);
          final layout = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: legendWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _ChartLegend(data: data, colors: colors),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: buildChartWidget()),
            ],
          );
          return layout.animate().fadeIn(duration: 800.ms, delay: delay ?? 0.ms).scale();
        }

        final layout = Column(
          children: [
            Expanded(child: buildChartWidget()),
            const SizedBox(height: 16),
            _ChartLegend(data: data, colors: colors),
          ],
        );
        return layout.animate().fadeIn(duration: 800.ms, delay: delay ?? 0.ms).scale();
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'alimentação':
        return Icons.restaurant;
      case 'transporte':
        return Icons.directions_car;
      case 'moradia':
        return Icons.home;
      case 'lazer':
        return Icons.movie;
      case 'saúde':
        return Icons.medical_services;
      default:
        Icons.category;
    }
    return Icons.category;
  }
}

class MonthlyBarChart extends StatelessWidget {
  final List<double> monthlyData;
  final Duration? delay;

  const MonthlyBarChart({
    Key? key,
    required this.monthlyData,
    this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (monthlyData.isEmpty) {
      return Center(
        child: Text(
          'Nenhum dado disponível',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    final maxValue = monthlyData.reduce((a, b) => a > b ? a : b);

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < monthlyData.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: monthlyData[i],
              color: theme.colorScheme.primary,
              width: 16,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxValue,
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue * 1.2,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      'R\$ ${rod.toY.toStringAsFixed(2)}',
                      theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < months.length) {
                        return Text(
                          months[index],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 38,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: maxValue / 4,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        'R\$${value.toInt()}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                    reservedSize: 50,
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxValue / 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: delay ?? 0.ms).scale();
  }
}

class ExpenseTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Duration? delay;

  const ExpenseTimeline({
    Key? key,
    required this.transactions,
    this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma transação recente',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _TimelineItem(
          title: transaction['title'],
          amount: transaction['amount'],
          date: transaction['date'],
          category: transaction['category'],
          isIncome: transaction['isIncome'] ?? false,
        ).animate().fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: (delay?.inMilliseconds ?? 0) + (index * 100)),
        ).slideX(begin: -0.2, end: 0);
      },
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
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  });

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
              color: isIncome ? theme.colorScheme.primary : theme.colorScheme.error,
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
                  color: isIncome ? theme.colorScheme.primary : theme.colorScheme.error,
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

class _ChartBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ChartBadge({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> colors;

  const _ChartLegend({
    required this.data,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = data.values.reduce((a, b) => a + b);

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: data.entries.map((entry) {
        final index = data.keys.toList().indexOf(entry.key);
        final percentage = (entry.value / total * 100);
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors[index % colors.length].withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors[index % colors.length].withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.key,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}