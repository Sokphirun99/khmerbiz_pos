import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/exchange_rate.dart';
import 'package:khmerbiz_pos/features/settings/presentation/bloc/settings_bloc.dart' show SettingsBloc;

/// Events for [SettingsBloc].
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load the current settings (exchange rate, etc.).
final class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// Manually refresh the exchange rate from NBC or fallback.
final class RefreshExchangeRate extends SettingsEvent {
  const RefreshExchangeRate();
}

/// States for [SettingsBloc].
sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state, nothing loaded yet.
final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Settings are being loaded or refreshed.
final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Settings loaded successfully.
final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required this.exchangeRate,
    this.isRefreshing = false,
  });

  /// The current active exchange rate.
  final ExchangeRate exchangeRate;

  /// Whether a refresh is currently in progress.
  final bool isRefreshing;

  @override
  List<Object?> get props => [exchangeRate, isRefreshing];
}

/// Settings failed to load.
final class SettingsError extends SettingsState {
  const SettingsError({required this.message});

  /// The human-readable error message.
  final String message;

  @override
  List<Object?> get props => [message];
}
