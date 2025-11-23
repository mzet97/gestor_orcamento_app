import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Classe para gerenciar acessibilidade e WCAG 2.1 compliance
class AccessibilityHelper {
  static const double _minimumContrastRatio = 4.5;
  static const double _largeTextContrastRatio = 3.0;

  /// Verifica se o contraste entre duas cores atende aos padrões WCAG
  static bool checkContrast(Color foreground, Color background, {bool isLargeText = false}) {
    final contrastRatio = _calculateContrastRatio(foreground, background);
    return contrastRatio >= (isLargeText ? _largeTextContrastRatio : _minimumContrastRatio);
  }

  /// Calcula a razão de contraste entre duas cores
  static double _calculateContrastRatio(Color foreground, Color background) {
    final foregroundLuminance = _getRelativeLuminance(foreground);
    final backgroundLuminance = _getRelativeLuminance(background);
    
    final lighter = foregroundLuminance > backgroundLuminance ? foregroundLuminance : backgroundLuminance;
    final darker = foregroundLuminance > backgroundLuminance ? backgroundLuminance : foregroundLuminance;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calcula a luminância relativa de uma cor
  static double _getRelativeLuminance(Color color) {
    final r = _linearizeColorComponent(color.red / 255.0);
    final g = _linearizeColorComponent(color.green / 255.0);
    final b = _linearizeColorComponent(color.blue / 255.0);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Lineariza o componente de cor
  static double _linearizeColorComponent(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    } else {
      return pow((component + 0.055) / 1.055, 2.4) as double;
    }
  }

  /// Retorna uma cor de texto apropriada baseada no background
  static Color getAppropriateTextColor(Color background) {
    return _getRelativeLuminance(background) > 0.5 ? Colors.black : Colors.white;
  }

  /// Verifica se uma cor é segura para daltonismo
  static bool isColorBlindSafe(Color color) {
    // Evitar combinações problemáticas para daltonismo
    final hsl = HSLColor.fromColor(color);
    final hue = hsl.hue;
    
    // Evitar vermelho-puro e verde-puro (problemas com protanopia e deuteranopia)
    return !((hue >= 0 && hue <= 30) || (hue >= 90 && hue <= 150));
  }

  /// Sugere uma paleta de cores acessível
  static List<Color> getAccessibleColorPalette() {
    return [
      const Color(0xFF1F77B4), // Azul
      const Color(0xFFFF7F0E), // Laranja
      const Color(0xFF2CA02C), // Verde escuro
      const Color(0xFFD62728), // Vermelho escuro
      const Color(0xFF9467BD), // Roxo
      const Color(0xFF8C564B), // Marrom
      const Color(0xFFE377C2), // Rosa
      const Color(0xFF7F7F7F), // Cinza
    ];
  }
}

/// Widget com acessibilidade aprimorada para botões
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final ButtonStyle? style;
  final bool autofocus;
  final FocusNode? focusNode;

  const AccessibleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.semanticLabel,
    this.style,
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      ),
    );
  }
}

/// Widget com acessibilidade aprimorada para cartões
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String semanticLabel;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AccessibleCard({
    Key? key,
    required this.child,
    this.onTap,
    required this.semanticLabel,
    this.color,
    this.margin,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardColor;
    
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      enabled: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Card(
          color: cardColor,
          margin: margin ?? const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Widget para entrada de formulário com acessibilidade
class AccessibleTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? helperText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const AccessibleTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hint,
    this.helperText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint ?? 'Campo de entrada para $label',
      textField: true,
      enabled: enabled,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: enabled ? null : Colors.grey.shade100,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
      ),
    );
  }
}

/// Widget para imagens com descrição alternativa
class AccessibleImage extends StatelessWidget {
  final ImageProvider image;
  final String semanticLabel;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const AccessibleImage({
    Key? key,
    required this.image,
    required this.semanticLabel,
    this.width,
    this.height,
    this.fit,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }
}

/// Extensão para ThemeData com acessibilidade
extension AccessibleTheme on ThemeData {
  /// Verifica se o tema atual tem contraste adequado
  bool get hasAccessibleContrast {
    return AccessibilityHelper.checkContrast(
      colorScheme.onBackground,
      colorScheme.background,
    );
  }

  /// Retorna um tema com cores acessíveis
  ThemeData get accessibleTheme {
    final isLight = brightness == Brightness.light;
    
    return copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorScheme.primary,
        brightness: brightness,
        // Garantir contraste adequado
        primary: _ensureContrast(colorScheme.primary, isLight),
        onPrimary: _ensureContrast(colorScheme.onPrimary, !isLight),
        secondary: _ensureContrast(colorScheme.secondary, isLight),
        onSecondary: _ensureContrast(colorScheme.onSecondary, !isLight),
        background: _ensureContrast(colorScheme.background, isLight),
        onBackground: _ensureContrast(colorScheme.onBackground, !isLight),
      ),
    );
  }

  Color _ensureContrast(Color color, bool isLightBackground) {
    final targetContrast = isLightBackground ? Colors.black : Colors.white;
    
    if (AccessibilityHelper.checkContrast(color, targetContrast)) {
      return color;
    }
    
    // Ajustar a cor para garantir contraste
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(isLightBackground ? 0.2 : 0.8).toColor();
  }
}

/// Widget para fornecer feedback sonoro
class AudioFeedback {
  static void playSuccessSound() {
    // Feedback tátil em dispositivos que suportam
    HapticFeedback.lightImpact();
  }

  static void playErrorSound() {
    HapticFeedback.mediumImpact();
  }

  static void playNavigationSound() {
    HapticFeedback.selectionClick();
  }
}

/// Widget para layout responsivo com acessibilidade
class AccessibleResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;

  const AccessibleResponsiveLayout({
    Key? key,
    required this.child,
    this.maxContentWidth = 1200,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final effectiveWidth = isLargeScreen 
            ? min(constraints.maxWidth * 0.9, maxContentWidth)
            : constraints.maxWidth;

        return Center(
          child: Container(
            width: effectiveWidth,
            padding: padding,
            child: child,
          ),
        );
      },
    );
  }
}

/// Função auxiliar para min
T min<T extends num>(T a, T b) => a < b ? a : b;

/// Função auxiliar para pow
num pow(num x, num exponent) {
  if (exponent == 0) return 1;
  if (exponent == 1) return x;
  
  num result = 1;
  num base = x;
  num exp = exponent.abs();
  
  while (exp > 0) {
    if (exp % 2 == 1) {
      result *= base;
    }
    base *= base;
    exp ~/= 2;
  }
  
  return exponent < 0 ? 1 / result : result;
}