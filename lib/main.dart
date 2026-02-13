import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/core/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zeitune_gestor/l10n/app_localizations.dart';
import 'package:zeitune_gestor/main_app.dart';
import 'package:zeitune_gestor/services/budget_alert_service.dart';
import 'package:zeitune_gestor/repository/settings_repository.dart';
import 'package:zeitune_gestor/repository/bank_slip_repository.dart';
import 'package:zeitune_gestor/repository/budget_repository.dart';
import 'package:zeitune_gestor/bloc/settings/settings_bloc.dart';
import 'package:zeitune_gestor/bloc/settings/settings_event.dart';
import 'package:zeitune_gestor/bloc/settings/settings_state.dart';
import 'package:zeitune_gestor/bloc/category/category_bloc.dart';
import 'package:zeitune_gestor/bloc/category/category_event.dart';
import 'package:zeitune_gestor/bloc/bank_slip/bank_slip_bloc.dart';
import 'package:zeitune_gestor/bloc/bank_slip/bank_slip_event.dart';
import 'package:zeitune_gestor/bloc/monthly_budget/monthly_budget_bloc.dart';
import 'package:zeitune_gestor/bloc/monthly_budget/monthly_budget_event.dart';
import 'package:zeitune_gestor/bloc/budget/budget_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_event.dart';
import 'package:zeitune_gestor/repository/monthly_budget_repository.dart';
import 'package:zeitune_gestor/screens/salary_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await BudgetAlertService.initialize();
    final settings = SettingsRepository();
    final now = DateTime.now().toIso8601String();
    await settings.setString('debug_persist', now);
    final readBack = await settings.getString('debug_persist');
    debugPrint('Persist check write=' + now + ' read=' + (readBack ?? 'null'));
  } catch (e, stack) {
    debugPrint('Erro na inicializacao: $e');
    debugPrint('Stack: $stack');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc(repo: SettingsRepository())..add(const LoadSettings()),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(repo: BankSlipRepository())..add(const LoadCategories()),
        ),
        BlocProvider<BankSlipBloc>(
          create: (_) => BankSlipBloc(repo: BankSlipRepository())..add(const LoadBankSlips()),
        ),
        BlocProvider<MonthlyBudgetBloc>(
          create: (_) => MonthlyBudgetBloc(repo: MonthlyBudgetRepository())..add(const LoadMonthlyBudgets()),
        ),
        BlocProvider<BudgetBloc>(
          create: (_) => BudgetBloc(budgetRepository: BudgetRepository())..add(const LoadBudget()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          Locale _mapLanguageCodeToLocale(String? code) {
            switch (code) {
              case 'en-US':
                return const Locale('en');
              case 'es-ES':
                return const Locale('es');
              case 'pt-BR':
              default:
                return const Locale('pt', 'BR');
            }
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Zeitune Gestor de Orçamento',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.darkMode ? ThemeMode.dark : ThemeMode.light,
            locale: _mapLanguageCodeToLocale(settingsState.language),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en'),
              Locale('es'),
            ],
            routes: {
              '/salary': (context) => const SalaryFormScreen(),
            },
            home: const MainApp(),
          );
        },
      ),
    );
  }
}
