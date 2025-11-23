# Estrutura de Telas do Zet Gestor de Orçamento

## Organização de Arquivos

Para manter o código organizado e manutenível, as telas serão separadas em arquivos individuais:

### Estrutura de Pastas
```
lib/
├── screens/
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   ├── dashboard_header.dart
│   │   ├── dashboard_metrics.dart
│   │   ├── dashboard_charts.dart
│   │   ├── dashboard_actions.dart
│   │   └── dashboard_transactions.dart
│   ├── transactions/
│   │   ├── transactions_screen.dart
│   │   ├── transaction_list.dart
│   │   ├── transaction_filters.dart
│   │   ├── transaction_item.dart
│   │   └── transaction_detail.dart
│   ├── budgets/
│   │   ├── budgets_screen.dart
│   │   ├── budget_overview.dart
│   │   ├── budget_list.dart
│   │   ├── budget_item.dart
│   │   └── budget_detail.dart
│   ├── reports/
│   │   ├── reports_screen.dart
│   │   ├── report_period_selector.dart
│   │   ├── report_chart_selector.dart
│   │   ├── report_chart.dart
│   │   └── report_insights.dart
│   ├── settings/
│   │   ├── settings_screen.dart
│   │   ├── profile_section.dart
│   │   ├── preferences_section.dart
│   │   ├── security_section.dart
│   │   ├── data_section.dart
│   │   └── about_section.dart
│   └── common/
│       ├── screen_scaffold.dart
│       ├── responsive_wrapper.dart
│       └── tab_navigation.dart
```

### Arquivos de Tela Principal

#### 1. Dashboard Screen (`dashboard_screen.dart`)
- **Responsabilidade**: Tela inicial com visão geral
- **Componentes**: Header, métricas, gráficos, ações rápidas, transações recentes
- **Estado**: Stateful para gerenciar dados dinâmicos

#### 2. Transactions Screen (`transactions_screen.dart`)
- **Responsabilidade**: Listagem e gerenciamento de transações
- **Componentes**: Lista de transações, filtros, busca, FAB para adicionar
- **Estado**: Stateful para filtros e busca

#### 3. Budgets Screen (`budgets_screen.dart`)
- **Responsabilidade**: Gerenciamento de orçamentos por categoria
- **Componentes**: Resumo do mês, lista de orçamentos, progresso por categoria
- **Estado**: Stateful para dados de orçamento

#### 4. Reports Screen (`reports_screen.dart`)
- **Responsabilidade**: Análises e relatórios financeiros
- **Componentes**: Seletores de período/tipo, gráficos, insights inteligentes
- **Estado**: Stateful para configurações de visualização

#### 5. Settings Screen (`settings_screen.dart`)
- **Responsabilidade**: Configurações do aplicativo
- **Componentes**: Perfil, preferências, segurança, dados, sobre
- **Estado**: Stateful para configurações do usuário

### Componentes Comuns

#### Screen Scaffold (`screen_scaffold.dart`)
```dart
class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  
  const ScreenScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: backgroundColor ?? theme.colorScheme.background,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: ModernAppBar(
        title: title,
        actions: actions,
      ),
      body: ResponsiveWrapper(
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
```

#### Responsive Wrapper (`responsive_wrapper.dart`)
```dart
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  
  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.maxWidth = 600,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? maxWidth : double.infinity,
            ),
            padding: padding,
            child: child,
          ),
        );
      },
    );
  }
}
```

### Implementação Progressiva

#### Fase 1: Estrutura Base
1. Criar arquivos de tela principais
2. Implementar navegação por abas
3. Adicionar componentes base

#### Fase 2: Dashboard Completo
1. Implementar dashboard com todos os componentes
2. Adicionar gráficos e métricas
3. Integrar com dados mock

#### Fase 3: Telas de Transações e Orçamentos
1. Implementar listagem de transações
2. Adicionar filtros e busca
3. Criar interface de orçamentos

#### Fase 4: Relatórios e Configurações
1. Implementar telas de relatórios
2. Adicionar configurações do usuário
3. Integrar com sistema de temas

### Padrões de Design

#### Consistência Visual
- Usar sempre `ModernCard` para cards
- Utilizar `ModernTextField` para inputs
- Aplicar `ModernPrimaryButton` e `ModernSecondaryButton`
- Manter espaçamentos consistentes (8, 16, 24, 32)

#### Responsividade
- Todos os componentes devem ser responsivos
- Usar `ResponsiveWrapper` para limitar largura em telas grandes
- Testar em diferentes tamanhos de tela

#### Acessibilidade
- Adicionar `Semantics` onde necessário
- Usar `tooltip` em botões e ícones
- Manter contraste adequado entre cores
- Suportar leitores de tela

#### Performance
- Usar `const` construtores onde possível
- Implementar lazy loading para listas grandes
- Otimizar rebuilds com `const` widgets
- Usar `keys` apropriadamente

### Próximos Passos

1. **Criar estrutura de pastas** no projeto Flutter
2. **Implementar telas principais** seguindo o design system
3. **Adicionar navegação por abas** no main.dart
4. **Integrar componentes base** em todas as telas
5. **Testar responsividade** em diferentes dispositivos
6. **Adicionar animações** e transições suaves
7. **Implementar temas claro/escuro**
8. **Adicionar testes de widget** para componentes

### Arquivos de Exemplo

Os arquivos de exemplo para cada tela estão disponíveis no arquivo `main_app.dart` criado anteriormente. Eles servem como base para a implementação completa das telas individuais.

### Observações Importantes

- Mantenha a consistência visual com o design original
- Use os componentes base sempre que possível
- Teste em dispositivos reais antes do deploy
- Documente componentes customizados
- Siga os padrões de nomenclatura do projeto