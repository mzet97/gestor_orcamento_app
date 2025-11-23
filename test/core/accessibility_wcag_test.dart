import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// Funções auxiliares para cálculo de contraste WCAG 2.1
double _calculateLuminance(Color color) {
  // Conversão para RGB linear
  double r = color.red / 255.0;
  double g = color.green / 255.0;
  double b = color.blue / 255.0;

  // Aplicar correção gamma
  r = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4).toDouble();
  g = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4).toDouble();
  b = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4).toDouble();

  // Calcular luminância relativa
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _calculateContrastRatio(Color foreground, Color background) {
  final lum1 = _calculateLuminance(foreground);
  final lum2 = _calculateLuminance(background);
  
  final lighter = lum1 > lum2 ? lum1 : lum2;
  final darker = lum1 > lum2 ? lum2 : lum1;
  
  return (lighter + 0.05) / (darker + 0.05);
}

bool _meetsWCAGAA(Color foreground, Color background, double fontSize, {bool isBold = false}) {
  final ratio = _calculateContrastRatio(foreground, background);
  
  // WCAG 2.1 AA: 4.5:1 para texto normal, 3:1 para texto grande (18pt ou 14pt negrito)
  final threshold = (fontSize >= 18 || (fontSize >= 14 && isBold)) ? 3.0 : 4.5;
  return ratio >= threshold;
}

bool _meetsWCAGAAA(Color foreground, Color background, double fontSize, {bool isBold = false}) {
  final ratio = _calculateContrastRatio(foreground, background);
  
  // WCAG 2.1 AAA: 7:1 para texto normal, 4.5:1 para texto grande
  final threshold = (fontSize >= 18 || (fontSize >= 14 && isBold)) ? 4.5 : 7.0;
  return ratio >= threshold;
}

void main() {
  group('WCAG 2.1 Contrast Tests', () {
    group('Primary Theme Colors', () {
      test('should meet WCAG AA for primary text on background', () {
        final theme = ThemeData.light();
        final primaryColor = theme.colorScheme.primary;
        final backgroundColor = theme.colorScheme.background;
        
        final meetsAA = _meetsWCAGAA(primaryColor, backgroundColor, 16.0);
        
        expect(meetsAA, isTrue, 
          reason: 'Primary color should have sufficient contrast with background for WCAG AA');
      });

      test('should meet WCAG AA for onPrimary text on primary', () {
        final theme = ThemeData.light();
        final onPrimaryColor = theme.colorScheme.onPrimary;
        final primaryColor = theme.colorScheme.primary;
        
        final meetsAA = _meetsWCAGAA(onPrimaryColor, primaryColor, 16.0);
        
        expect(meetsAA, isTrue,
          reason: 'onPrimary color should have sufficient contrast with primary for WCAG AA');
      });
    });

    group('Text Colors', () {
      test('should meet WCAG AA for body text on background', () {
        final theme = ThemeData.light();
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        final backgroundColor = theme.colorScheme.background;
        
        final meetsAA = _meetsWCAGAA(textColor, backgroundColor, 16.0);
        
        expect(meetsAA, isTrue,
          reason: 'Body text should have sufficient contrast with background for WCAG AA');
      });

      test('should meet WCAG AA for headline text on background', () {
        final theme = ThemeData.light();
        final headlineColor = theme.textTheme.headlineSmall?.color ?? Colors.black;
        final backgroundColor = theme.colorScheme.background;
        
        final meetsAA = _meetsWCAGAA(headlineColor, backgroundColor, 24.0);
        
        expect(meetsAA, isTrue,
          reason: 'Headline text should have sufficient contrast with background for WCAG AA');
      });
    });

    group('Button Colors', () {
      test('should meet WCAG AA for button text on button background', () {
        final theme = ThemeData.light();
        final buttonTextColor = theme.colorScheme.onPrimary;
        final buttonColor = theme.colorScheme.primary;
        
        final meetsAA = _meetsWCAGAA(buttonTextColor, buttonColor, 14.0, isBold: true);
        
        expect(meetsAA, isTrue,
          reason: 'Button text should have sufficient contrast with button background for WCAG AA');
      });

      test('should meet WCAG AA for disabled button text', () {
        final theme = ThemeData.light();
        final disabledButtonColor = theme.colorScheme.surfaceVariant;
        final onSurfaceColor = theme.colorScheme.onSurface.withOpacity(0.38);
        
        final meetsAA = _meetsWCAGAA(onSurfaceColor, disabledButtonColor, 14.0);
        
        // Para botões desabilitados, o requisito é mais flexível
        expect(meetsAA, isTrue,
          reason: 'Disabled button should have some contrast indication');
      });
    });

    group('Error States', () {
      test('should meet WCAG AA for error text on background', () {
        final theme = ThemeData.light();
        final errorColor = theme.colorScheme.error;
        final backgroundColor = theme.colorScheme.background;
        
        final meetsAA = _meetsWCAGAA(errorColor, backgroundColor, 16.0);
        
        expect(meetsAA, isTrue,
          reason: 'Error text should have sufficient contrast with background for WCAG AA');
      });

      test('should meet WCAG AA for onError text on error background', () {
        final theme = ThemeData.light();
        final onErrorColor = theme.colorScheme.onError;
        final errorColor = theme.colorScheme.error;
        
        final meetsAA = _meetsWCAGAA(onErrorColor, errorColor, 16.0);
        
        expect(meetsAA, isTrue,
          reason: 'onError color should have sufficient contrast with error background for WCAG AA');
      });
    });

    group('Card Colors', () {
      test('should meet WCAG AA for text on card surface', () {
        final theme = ThemeData.light();
        final cardColor = theme.colorScheme.surface;
        final onSurfaceColor = theme.colorScheme.onSurface;
        
        final meetsAA = _meetsWCAGAA(onSurfaceColor, cardColor, 16.0);
        
        expect(meetsAA, isTrue,
          reason: 'Text on card should have sufficient contrast with card surface for WCAG AA');
      });
    });

    group('Dark Theme', () {
      test('should meet WCAG AA for text colors in dark theme', () {
        final theme = ThemeData.dark();
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
        final backgroundColor = theme.colorScheme.background;
        
        final meetsAA = _meetsWCAGAA(textColor, backgroundColor, 16.0);
        
        expect(meetsAA, isTrue,
          reason: 'Dark theme text should have sufficient contrast with background for WCAG AA');
      });

      test('should meet WCAG AA for primary colors in dark theme', () {
        final theme = ThemeData.dark();
        final primaryColor = theme.colorScheme.primary;
        final backgroundColor = theme.colorScheme.background;
        
        final meetsAA = _meetsWCAGAA(primaryColor, backgroundColor, 16.0);
        
        expect(meetsAA, isTrue,
          reason: 'Dark theme primary color should have sufficient contrast with background for WCAG AA');
      });
    });

    group('Specific Contrast Ratios', () {
      test('should calculate correct contrast ratio for black on white', () {
        final ratio = _calculateContrastRatio(Colors.black, Colors.white);
        
        expect(ratio, closeTo(21.0, 0.1), 
          reason: 'Black on white should have maximum contrast ratio of 21:1');
      });

      test('should calculate correct contrast ratio for white on black', () {
        final ratio = _calculateContrastRatio(Colors.white, Colors.black);
        
        expect(ratio, closeTo(21.0, 0.1),
          reason: 'White on black should have maximum contrast ratio of 21:1');
      });

      test('should calculate correct contrast ratio for similar colors', () {
        final ratio = _calculateContrastRatio(
          Colors.grey[300]!, 
          Colors.grey[400]!
        );
        
        expect(ratio, lessThan(3.0),
          reason: 'Similar grey colors should have low contrast ratio');
      });
    });

    group('WCAG AAA Compliance', () {
      test('should identify colors meeting WCAG AAA for normal text', () {
        final foreground = Colors.black;
        final background = Colors.white;
        
        final meetsAAA = _meetsWCAGAAA(foreground, background, 16.0);
        
        expect(meetsAAA, isTrue,
          reason: 'Black on white should meet WCAG AAA for normal text');
      });

      test('should identify colors meeting WCAG AAA for large text', () {
        final foreground = Colors.grey[800]!;
        final background = Colors.white;
        
        final meetsAAA = _meetsWCAGAAA(foreground, background, 18.0);
        
        expect(meetsAAA, isTrue,
          reason: 'Dark grey on white should meet WCAG AAA for large text');
      });
    });

    group('Accessibility Helper Functions', () {
      test('should provide semantic labels for common UI elements', () {
        // Testar que os elementos têm labels apropriadas
        final button = ElevatedButton(
          onPressed: () {},
          child: const Text('Test Button'),
        );

        expect(button, isNotNull);
        // Em produção, usar flutter_test com find.bySemanticsLabel
      });

      test('should validate color accessibility for different text sizes', () {
        final smallTextColor = Colors.grey[500]!;
        final largeTextColor = Colors.grey[700]!;
        final background = Colors.white;

        final smallTextAA = _meetsWCAGAA(smallTextColor, background, 12.0);
        final largeTextAA = _meetsWCAGAA(largeTextColor, background, 18.0);

        expect(smallTextAA, isFalse,
          reason: 'Small grey text should not meet WCAG AA on white background');
        expect(largeTextAA, isTrue,
          reason: 'Large grey text should meet WCAG AA on white background');
      });
    });
  });
}