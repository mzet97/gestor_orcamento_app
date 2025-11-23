# Sistema de Design - Zet Gestor de Orçamento

## Tokens de Design Base

### Cores Principais (Extraídas do Tema Atual)
- **Primary**: `#FF006E1C` (Verde financeiro moderno)
- **Secondary**: `#FF006874` (Azul petróleo)
- **Background**: Material You dinâmico
- **Surface**: Material You dinâmico
- **Error**: Vermelho padrão Material

### Tipografia (Google Fonts - Inter)
- **Display Large**: 57px, Regular
- **Headline Small**: 24px, SemiBold 600
- **Title Large**: 22px, SemiBold 600
- **Body Large**: 16px, Regular
- **Body Small**: 12px, Regular
- **Label Large**: 14px, Medium 500

### Espaçamentos
- **XS**: 4px
- **SM**: 8px
- **MD**: 16px
- **LG**: 24px
- **XL**: 32px

### Bordas e Raio
- **Card Radius**: 24px
- **Button Radius**: 12px
- **Icon Radius**: 12px
- **Container Radius**: 8px

### Elevações e Sombras
- **Card Elevation**: 0 (usa surface tint)
- **Button Elevation**: 0
- **AppBar Elevation**: 0

## Componentes Base

### Card Padrão (ModernCard)
```dart
// Estilo atual do dashboard
Container(
  decoration: BoxDecoration(
    color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(24),
    // surfaceTintColor aplicado automaticamente
  ),
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
)
```

### Botão Primário
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: theme.colorScheme.primary,
    foregroundColor: theme.colorScheme.onPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  child: Text('Ação', style: theme.textTheme.labelLarge),
)
```

### Input Field
```dart
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
    ),
    filled: true,
    fillColor: theme.colorScheme.surface,
  ),
  style: theme.textTheme.bodyLarge,
)
```

### Ícone com Fundo
```dart
Container(
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: theme.colorScheme.primary.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Icon(
    Icons.icon_name,
    color: theme.colorScheme.primary,
    size: 20,
  ),
)
```

## Navegação por Abas

### Estrutura do TabBar
```dart
BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: theme.colorScheme.surface,
  selectedItemColor: theme.colorScheme.primary,
  unselectedItemColor: theme.colorScheme.onSurfaceVariant,
  selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
    fontWeight: FontWeight.w600,
  ),
  unselectedLabelStyle: theme.textTheme.labelSmall,
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    // ... outros itens
  ],
)
```

### Animações Padrão
```dart
// Fade e Scale para cards
.animate().fade().scale()

// Delay sequencial
.animate().fade(delay: 200.ms).scale()

// Duração padrão
duration: Duration(milliseconds: 1000)
```

## Princípios de Responsividade

### Breakpoints
- **Mobile Pequeno**: < 360px
- **Mobile Padrão**: 360px - 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

### Adaptações por Tamanho
- **Cards**: Largura proporcional ao container
- **Grids**: Colunas adaptativas (1-2-3-4)
- **Textos**: Tamanhos escaláveis com `MediaQuery`
- **Espaçamentos**: Proporcionais à largura da tela

### Exemplo de Card Responsivo
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isTablet = constraints.maxWidth > 600;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: isTablet 
            ? CrossAxisAlignment.start 
            : CrossAxisAlignment.center,
          children: [
            // Conteúdo adaptativo
          ],
        ),
      ),
    );
  },
)
```

## Acessibilidade

### Contraste
- **Texto normal**: 4.5:1 mínimo
- **Texto grande**: 3:1 mínimo
- **Elementos interativos**: 3:1 mínimo

### Tamanhos de Toque
- **Mínimo**: 48px x 48px
- **Ideal**: 56px x 56px
- **Espaçamento**: 8px entre elementos

### Semântica
- Labels descritivos para leitores de tela
- Hierarquia de cabeçalhos
- Indicações de estado (pressed, focused, disabled)

## Sistema de Ícones

### Estilo
- **Família**: Material Icons Outlined (não selecionados)
- **Ativos**: Material Icons (Filled)
- **Tamanhos**: 
  - Pequeno: 20px
  - Médio: 24px
  - Grande: 32px

### Cores Contextuais
- **Primário**: theme.colorScheme.primary
- **Erro**: theme.colorScheme.error
- **Sucesso**: theme.colorScheme.tertiary
- **Neutro**: theme.colorScheme.onSurfaceVariant

## Estados de Componentes

### Botão
- **Default**: Cor primária, texto branco
- **Pressed**: Tom mais escuro da primária
- **Disabled**: Surface com 38% de opacidade
- **Loading**: Spinner branco no centro

### Card
- **Default**: Surface com elevation 0
- **Pressed**: Surface com leve overlay
- **Selected**: Borda primária de 2px

### Input
- **Default**: Outline variant
- **Focused**: Primary com 2px
- **Error**: Error color
- **Disabled**: Surface com texto reduzido

## Implementação Progressiva

### Fase 1: Componentes Base
1. ModernCard padronizado
2. Botões consistentes
3. Inputs modernos
4. Ícones padronizados

### Fase 2: Navegação
1. TabBar inferior
2. Transições suaves
3. Animações consistentes
4. Feedback tátil/sonoro

### Fase 3: Responsividade
1. Layouts adaptativos
2. Textos escaláveis
3. Grids flexíveis
4. Testes em múltiplos dispositivos

### Fase 4: Acessibilidade
1. Contraste WCAG 2.1
2. Navegação por teclado
3. Leitores de tela
4. Testes de usabilidade

Este sistema garante consistência visual total mantendo o estilo moderno e elegante da tela inicial já existente.