import 'package:flutter/material.dart';
import 'package:zeitune_gestor/core/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final buttonColor = color ?? colorScheme.primary;

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: buttonColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _buildContent(buttonColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: _buildContent(buttonColor),
            ),
    );
  }

  Widget _buildContent(Color buttonColor) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isOutlined ? buttonColor : Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isOutlined ? buttonColor : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: isOutlined ? buttonColor : Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: cs.onSurfaceVariant) : null,
        filled: true,
        fillColor: cs.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: tt.bodyLarge,
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final void Function()? onTap;
  final BorderRadius? borderRadius;

  const AppCard({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.elevation,
    this.onTap,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
      ),
      color: backgroundColor ?? cs.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingWidget({
    Key? key,
    this.message,
    this.size = 40,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? cs.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: cs.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 24),
            AppButton(
              text: buttonText!,
              onPressed: onButtonPressed!,
              isOutlined: true,
            ),
          ],
        ],
      ),
    );
  }
}