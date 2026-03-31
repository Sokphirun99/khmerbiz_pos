import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/features/settings/presentation/bloc/settings_state.dart';

/// BLoC for managing application settings and exchange rates.
@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Creates a new [SettingsBloc] with the given [ExchangeRateRepository].
  SettingsBloc(this._repository) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<RefreshExchangeRate>(_onRefreshExchangeRate);
  }

  final ExchangeRateRepository _repository;

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    final result = await _repository.getLatestRate();

    result.fold(
      (failure) => emit(SettingsError(message: failure.messageKm)),
      (rate) => emit(SettingsLoaded(exchangeRate: rate)),
    );
  }

  Future<void> _onRefreshExchangeRate(
    RefreshExchangeRate event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentRate = (state as SettingsLoaded).exchangeRate;
      emit(SettingsLoaded(exchangeRate: currentRate, isRefreshing: true));
    } else {
      emit(const SettingsLoading());
    }

    final result = await _repository.fetchLatestRate();

    await result.fold(
      (failure) async => emit(SettingsError(message: failure.messageKm)),
      (_) async {
        final latestResult = await _repository.getLatestRate();
        latestResult.fold(
          (failure) => emit(SettingsError(message: failure.messageKm)),
          (rate) => emit(SettingsLoaded(exchangeRate: rate)),
        );
      },
    );
  }
}
