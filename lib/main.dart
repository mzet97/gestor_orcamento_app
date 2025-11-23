import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zet_gestor_orcamento/core/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zet_gestor_orcamento/l10n/app_localizations.dart';

import 'package:zet_gestor_orcamento/main_app.dart';
import 'package:zet_gestor_orcamento/services/budget_alert_service.dart';
import 'package:zet_gestor_orcamento/repository/settings_repository.dart';
import 'package:zet_gestor_orcamento/repository/bank_slip_repository.dart';
import 'package:zet_gestor_orcamento/repository/budget_repository.dart';
import 'package:zet_gestor_orcamento/bloc/settings/settings_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/settings/settings_event.dart';
import 'package:zet_gestor_orcamento/bloc/settings/settings_state.dart';
import 'package:zet_gestor_orcamento/bloc/category/category_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/category/category_event.dart';
import 'package:zet_gestor_orcamento/bloc/bank_slip/bank_slip_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/bank_slip/bank_slip_event.dart';
import 'package:zet_gestor_orcamento/bloc/monthly_budget/monthly_budget_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/monthly_budget/monthly_budget_event.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_event.dart';
import 'package:zet_gestor_orcamento/repository/monthly_budget_repository.dart';
import 'package:zet_gestor_orcamento/screens/salary_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BudgetAlertService.initialize();
  // Persistência básica: gravar e ler um valor de teste
  final settings = SettingsRepository();
  final now = DateTime.now().toIso8601String();
  await settings.setString('debug_persist', now);
  final readBack = await settings.getString('debug_persist');
  debugPrint('Persist check write=' + now + ' read=' + (readBack ?? 'null'));
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
            title: 'Zet Gestor de Orçamento',
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