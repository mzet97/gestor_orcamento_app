// settings_screen.dart - Tela de configurações
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/components/base_components.dart';
import 'package:zeitune_gestor/repository/settings_repository.dart';
import 'package:zeitune_gestor/bloc/settings/settings_bloc.dart';
import 'package:zeitune_gestor/bloc/settings/settings_state.dart';
import 'package:zeitune_gestor/bloc/settings/settings_event.dart';
import 'package:zeitune_gestor/screens/salary_form_screen.dart';
import 'package:zeitune_gestor/services/export_service.dart';
import 'package:zeitune_gestor/repository/budget_repository.dart';
import 'package:zeitune_gestor/repository/bank_slip_repository.dart';
import 'package:zeitune_gestor/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _biometricAuth = false;
  String _currency = 'BRL';
  String _language = 'pt-BR';
  String _dateFormat = 'dd/MM/yyyy';
  final SettingsRepository _settingsRepo = SettingsRepository();
  // Controle para exibir/ocultar a seção de perfil
  final bool _showProfileSection = false;

  // Serviços e repositórios para exportação
  final ExportService _exportService = ExportService();
  final BudgetRepository _budgetRepo = BudgetRepository();
  final BankSlipRepository _bankRepo = BankSlipRepository();
  bool _isExporting = false;

  final List<Map<String, String>> _currencies = [
    {'code': 'BRL', 'name': 'Real Brasileiro (R\$)'},
    {'code': 'USD', 'name': 'Dólar Americano (\$)'},
    {'code': 'EUR', 'name': 'Euro (€)'},
    {'code': 'GBP', 'name': 'Libra Esterlina (£)'},
  ];

  final List<Map<String, String>> _languages = [
    {'code': 'pt-BR', 'name': 'Português (Brasil)'},
    {'code': 'en-US', 'name': 'English (US)'},
    {'code': 'es-ES', 'name': 'Español (España)'},
  ];

  final List<Map<String, String>> _dateFormats = [
    {'format': 'dd/MM/yyyy', 'name': 'DD/MM/AAAA'},
    {'format': 'MM/dd/yyyy', 'name': 'MM/DD/AAAA'},
    {'format': 'yyyy-MM-dd', 'name': 'AAAA-MM-DD'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ModernAppBar(
            title: AppLocalizations.of(context)!.settingsTitle,
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_showProfileSection) ...[
                // Seção de Perfil
                _buildSectionTitle('Perfil'),
                ModernCard(
                hasShadow: true,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perfil Zeitune',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'usuario@email.com',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: () => _showEditProfileDialog(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ],

              // Seção de Aparência
              _buildSectionTitle('Aparência'),
              ModernCard(
                hasShadow: true,
                child: Column(
                  children: [
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return _buildSwitchTile(
                          title: 'Modo Escuro',
                          subtitle: 'Ativar tema escuro',
                          value: state.darkMode,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(ToggleDarkMode(value));
                          },
                          icon: Icons.dark_mode_rounded,
                        );
                      },
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 24),

              

              // Seção de Segurança
              _buildSectionTitle('Segurança'),
              ModernCard(
                hasShadow: true,
                child: Column(
                  children: [
                    
                    _buildListTile(
                      title: AppLocalizations.of(context)!.exportData,
                      subtitle: AppLocalizations.of(context)!.exportDataSubtitle,
                      onTap: () => _showExportDialog(),
                      icon: Icons.backup_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Seção de Preferências
              _buildSectionTitle(AppLocalizations.of(context)!.preferences),
              ModernCard(
                hasShadow: true,
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppLocalizations.of(context)!.salaryMonthly,
                      subtitle: AppLocalizations.of(context)!.updateSalary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SalaryFormScreen(),
                          ),
                        );
                      },
                      icon: Icons.payments_rounded,
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Seção de Sobre
              _buildSectionTitle(AppLocalizations.of(context)!.about),
              ModernCard(
                hasShadow: true,
                child: Column(
                  children: [
                    _buildListTile(
                      title: AppLocalizations.of(context)!.appVersion,
                      subtitle: 'v1.0.0',
                      onTap: () {},
                      icon: Icons.info_rounded,
                    ),
                    ModernDivider(),
                    _buildListTile(
                      title: AppLocalizations.of(context)!.termsOfUse,
                      subtitle: 'Leia os termos e condições',
                      onTap: () => _showTermsDialog(),
                      icon: Icons.description_rounded,
                    ),
                    ModernDivider(),
                    _buildListTile(
                      title: 'Política de privacidade',
                      subtitle: 'Como protegemos seus dados',
                      onTap: () => _showPrivacyDialog(),
                      icon: Icons.privacy_tip_rounded,
                    ),
                    ModernDivider(),
                    _buildListTile(
                      title: 'Avaliar o aplicativo',
                      subtitle: 'Deixe sua opinião na loja',
                      onTap: () => _showRateDialog(),
                      icon: Icons.star_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return SwitchListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      onChanged: onChanged,
      secondary: Icon(
        icon,
        color: theme.colorScheme.primary,
        size: 24,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: const Text('Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ModernPrimaryButton(
            text: 'Salvar',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages[index];
              final currentLang = context.read<SettingsBloc>().state.language;
              final isSelected = language['code'] == currentLang;

              return RadioListTile<String>(
                title: Text(language['name']!),
                value: language['code']!,
                groupValue: currentLang,
                onChanged: (value) {
                  if (value == null) return;
                  context.read<SettingsBloc>().add(ChangeLanguage(value));
                  setState(() { _language = value; });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _showRemindersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurar Lembretes'),
        content: const Text('Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: const Text('Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ModernPrimaryButton(
            text: 'Alterar',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.exportDialogTitle),
        content: Text(AppLocalizations.of(context)!.exportDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ModernPrimaryButton(
            text: AppLocalizations.of(context)!.exportExcelButton,
            onPressed: () async {
              Navigator.pop(context);
              await _exportToExcel();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportToExcel() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final budget = await _budgetRepo.getBudget();
      final monthlyBudgets = budget.monthlyBudget ?? [];
      final bankSlips = budget.getAllBankSlips();
      final categories = await _bankRepo.getCategories();

      final filePath = await _exportService.exportToExcel(
        budget: budget,
        monthlyBudgets: monthlyBudgets,
        bankSlips: bankSlips,
        categories: categories,
        startDate: null,
        endDate: null,
      );

      // Tenta compartilhar/baixar o arquivo; em web pode não suportar compartilhar arquivos
      try {
        await _exportService.shareFile(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excel exportado e compartilhado com sucesso.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel gerado em: $filePath')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar Excel: $e')),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Moeda'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _currencies.length,
            itemBuilder: (context, index) {
              final currency = _currencies[index];
              final isSelected = currency['code'] == _currency;

              return RadioListTile<String>(
                title: Text(currency['name']!),
                value: currency['code']!,
                groupValue: _currency,
                onChanged: (value) {
                  setState(() {
                    _currency = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showDateFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Formato de Data'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _dateFormats.length,
            itemBuilder: (context, index) {
              final format = _dateFormats[index];
              final isSelected = format['format'] == _dateFormat;

              return RadioListTile<String>(
                title: Text(format['name']!),
                value: format['format']!,
                groupValue: _dateFormat,
                onChanged: (value) async {
                  if (value == null) return;
                  setState(() {
                    _dateFormat = value;
                  });
                  await _settingsRepo.setDateFormat(value);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Formato de data salvo.')),
                    );
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Categorias Padrão'),
        content: const Text('Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso'),
        content: const SingleChildScrollView(
          child: Text(
            'Termos e condições de uso do aplicativo Zeitune Gestor de Orçamento...\n\n'
            '1. Aceitação dos Termos\n'
            'Ao utilizar este aplicativo, você concorda com estes termos.\n\n'
            '2. Uso do Serviço\n'
            'O aplicativo é fornecido para uso pessoal e não comercial.\n\n'
            '3. Privacidade\n'
            'Respeitamos sua privacidade e protegemos seus dados.\n\n'
            '4. Responsabilidade\n'
            'Você é responsável pelo uso adequado do aplicativo.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidade'),
        content: const SingleChildScrollView(
          child: Text(
            'Política de privacidade do aplicativo Zeitune Gestor de Orçamento...\n\n'
            '1. Coleta de Dados\n'
            'Coletamos apenas dados necessários para funcionamento do app.\n\n'
            '2. Uso dos Dados\n'
            'Seus dados são usados apenas para fornecer funcionalidades.\n\n'
            '3. Proteção\n'
            'Implementamos medidas de segurança para proteger seus dados.\n\n'
            '4. Compartilhamento\n'
            'Não compartilhamos seus dados com terceiros.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showRateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avaliar Aplicativo'),
        content: const Text('Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ModernPrimaryButton(
            text: 'Avaliar',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza de que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ModernPrimaryButton(
            text: 'Sair',
            onPressed: () {
              Navigator.pop(context);
              // Implementar logout
            },
          ),
        ],
      ),
    );
  }
}