import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/screens/modern_dashboard.dart';
import 'package:zet_gestor_orcamento/screens/transactions_screen.dart';
import 'package:zet_gestor_orcamento/screens/categories_screen.dart';
import 'package:zet_gestor_orcamento/screens/reports_screen.dart';
import 'package:zet_gestor_orcamento/screens/settings_screen.dart';
import 'package:zet_gestor_orcamento/l10n/app_localizations.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isCompact = screenWidth < 360;
    final double barHeight = isCompact ? 74 : (screenWidth < 480 ? 84 : 90);
    final double labelFontSize = isCompact ? 10.0 : (screenWidth < 480 ? 11.0 : 12.0);
    final double iconSize = isCompact ? 18.0 : (screenWidth < 480 ? 20.0 : 22.0);
    final EdgeInsets tabPadding = isCompact
        ? const EdgeInsets.symmetric(horizontal: 4, vertical: 0)
        : (screenWidth < 480
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 2));

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ModernDashboard(),
          TransactionsScreen(),
          CategoriesScreen(),
          ReportsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Theme(
            data: theme.copyWith(
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(),
              labelPadding: EdgeInsets.zero,
              labelStyle: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                _buildTab(
                  icon: Icons.home_rounded,
                  label: AppLocalizations.of(context)!.tabHome,
                  isActive: _currentIndex == 0,
                  theme: theme,
                  screenWidth: screenWidth,
                  isCompact: isCompact,
                  iconSize: iconSize,
                  padding: tabPadding,
                ),
                _buildTab(
                  icon: Icons.receipt_long_rounded,
                  label: AppLocalizations.of(context)!.tabTransactions,
                  isActive: _currentIndex == 1,
                  theme: theme,
                  screenWidth: screenWidth,
                  isCompact: isCompact,
                  iconSize: iconSize,
                  padding: tabPadding,
                ),
                _buildTab(
                  icon: Icons.category_rounded,
                  label: AppLocalizations.of(context)!.tabCategories,
                  isActive: _currentIndex == 2,
                  theme: theme,
                  screenWidth: screenWidth,
                  isCompact: isCompact,
                  iconSize: iconSize,
                  padding: tabPadding,
                ),
                _buildTab(
                  icon: Icons.bar_chart_rounded,
                  label: AppLocalizations.of(context)!.tabReports,
                  isActive: _currentIndex == 3,
                  theme: theme,
                  screenWidth: screenWidth,
                  isCompact: isCompact,
                  iconSize: iconSize,
                  padding: tabPadding,
                ),
                _buildTab(
                  icon: Icons.settings_rounded,
                  label: AppLocalizations.of(context)!.tabSettings,
                  isActive: _currentIndex == 4,
                  theme: theme,
                  screenWidth: screenWidth,
                  isCompact: isCompact,
                  iconSize: iconSize,
                  padding: tabPadding,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required bool isActive,
    required ThemeData theme,
    required double screenWidth,
    required bool isCompact,
    required double iconSize,
    required EdgeInsets padding,
  }) {
    return Tab(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primaryContainer.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 56),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: isCompact ? 1 : 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isCompact ? 10 : (screenWidth < 480 ? 11 : 12),
                    height: 1.0,
                    fontWeight: FontWeight.w600,
                    color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}