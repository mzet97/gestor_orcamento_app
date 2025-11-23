import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ToggleDarkMode extends SettingsEvent {
  final bool value;
  const ToggleDarkMode(this.value);
  @override
  List<Object?> get props => [value];
}

class ToggleNotifications extends SettingsEvent {
  final bool value;
  const ToggleNotifications(this.value);
  @override
  List<Object?> get props => [value];
}

class ToggleBiometric extends SettingsEvent {
  final bool value;
  const ToggleBiometric(this.value);
  @override
  List<Object?> get props => [value];
}

class ChangeCurrency extends SettingsEvent {
  final String code;
  const ChangeCurrency(this.code);
  @override
  List<Object?> get props => [code];
}

class ChangeLanguage extends SettingsEvent {
  final String code;
  const ChangeLanguage(this.code);
  @override
  List<Object?> get props => [code];
}

class ChangeDateFormat extends SettingsEvent {
  final String pattern;
  const ChangeDateFormat(this.pattern);
  @override
  List<Object?> get props => [pattern];
}