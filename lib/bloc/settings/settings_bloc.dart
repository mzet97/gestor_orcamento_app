import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/settings/settings_event.dart';
import 'package:zet_gestor_orcamento/bloc/settings/settings_state.dart';
import 'package:zet_gestor_orcamento/repository/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repo;

  SettingsBloc({required this.repo}) : super(SettingsState.initial()) {
    on<LoadSettings>(_onLoad);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ToggleNotifications>(_onToggleNotifications);
    on<ToggleBiometric>(_onToggleBiometric);
    on<ChangeCurrency>(_onChangeCurrency);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeDateFormat>(_onChangeDateFormat);
  }

  Future<void> _onLoad(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(loading: true));
    final dark = await repo.getBool(SettingsRepository.keyDarkMode) ?? state.darkMode;
    final notif = await repo.getBool(SettingsRepository.keyNotifications) ?? state.notifications;
    final bio = await repo.getBool(SettingsRepository.keyBiometric) ?? state.biometricAuth;
    final curr = await repo.getString(SettingsRepository.keyCurrency) ?? state.currency;
    final lang = await repo.getString(SettingsRepository.keyLanguage) ?? state.language;
    final date = await repo.getDateFormatOrDefault();
    emit(state.copyWith(
      darkMode: dark,
      notifications: notif,
      biometricAuth: bio,
      currency: curr,
      language: lang,
      dateFormat: date,
      loading: false,
    ));
  }

  Future<void> _onToggleDarkMode(ToggleDarkMode event, Emitter<SettingsState> emit) async {
    await repo.setBool(SettingsRepository.keyDarkMode, event.value);
    emit(state.copyWith(darkMode: event.value));
  }

  Future<void> _onToggleNotifications(ToggleNotifications event, Emitter<SettingsState> emit) async {
    await repo.setBool(SettingsRepository.keyNotifications, event.value);
    emit(state.copyWith(notifications: event.value));
  }

  Future<void> _onToggleBiometric(ToggleBiometric event, Emitter<SettingsState> emit) async {
    await repo.setBool(SettingsRepository.keyBiometric, event.value);
    emit(state.copyWith(biometricAuth: event.value));
  }

  Future<void> _onChangeCurrency(ChangeCurrency event, Emitter<SettingsState> emit) async {
    await repo.setString(SettingsRepository.keyCurrency, event.code);
    emit(state.copyWith(currency: event.code));
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) async {
    await repo.setString(SettingsRepository.keyLanguage, event.code);
    emit(state.copyWith(language: event.code));
  }

  Future<void> _onChangeDateFormat(ChangeDateFormat event, Emitter<SettingsState> emit) async {
    await repo.setDateFormat(event.pattern);
    emit(state.copyWith(dateFormat: event.pattern));
  }
}