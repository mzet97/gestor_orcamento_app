import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool darkMode;
  final bool notifications;
  final bool biometricAuth;
  final String currency;
  final String language;
  final String dateFormat;
  final bool loading;

  const SettingsState({
    required this.darkMode,
    required this.notifications,
    required this.biometricAuth,
    required this.currency,
    required this.language,
    required this.dateFormat,
    this.loading = false,
  });

  factory SettingsState.initial() => const SettingsState(
        darkMode: false,
        notifications: true,
        biometricAuth: false,
        currency: 'BRL',
        language: 'pt-BR',
        dateFormat: 'dd/MM/yyyy',
        loading: true,
      );

  SettingsState copyWith({
    bool? darkMode,
    bool? notifications,
    bool? biometricAuth,
    String? currency,
    String? language,
    String? dateFormat,
    bool? loading,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
      biometricAuth: biometricAuth ?? this.biometricAuth,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        darkMode,
        notifications,
        biometricAuth,
        currency,
        language,
        dateFormat,
      ];
}