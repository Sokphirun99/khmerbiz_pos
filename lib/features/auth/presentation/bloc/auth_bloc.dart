import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/features/auth/domain/auth_repository.dart';
import 'package:khmerbiz_pos/features/auth/domain/login_credentials.dart';
import 'package:khmerbiz_pos/features/auth/presentation/bloc/auth_event.dart';
import 'package:khmerbiz_pos/features/auth/presentation/bloc/auth_state.dart';

/// BLoC for handling authentication logic.
final class AuthBloc extends Bloc<AuthEvent, AuthState> {

  /// Create an [AuthBloc] with the given repository.
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthTokenRefreshRequested>(_onAuthTokenRefreshRequested);
    on<AuthClearRequested>(_onAuthClearRequested);
  }
  final AuthRepository _authRepository;

  /// Handle auth check on app start.
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Checking authentication...'));

    try {
      // Check if user is already authenticated
      if (_authRepository.isAuthenticated) {
        final user = _authRepository.currentUser;
        if (user != null) {
          emit(AuthAuthenticated(user));
          return;
        }
      }

      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle login request.
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Logging in...'));

    try {
      final credentials = LoginCredentials(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      );
      final result = await _authRepository.login(credentials);

      emit(AuthAuthenticated(result.user));
    } on Failure catch (e) {
      emit(AuthError(e.messageEn, messageKm: e.messageKm));
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  /// Handle registration request.
  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Creating account...'));

    try {
      final result = await _authRepository.register(event.email, event.password);
      emit(AuthAuthenticated(result.user));
    } on Failure catch (e) {
      emit(AuthError(e.messageEn, messageKm: e.messageKm));
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  /// Handle logout request.
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Logging out...'));

    try {
      await _authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: $e'));
    }
  }

  /// Handle token refresh request.
  Future<void> _onAuthTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await _authRepository.refreshToken();
      // Update user if needed
      if (state is AuthAuthenticated) {
        emit(AuthAuthenticated(result.user));
      }
    } catch (e) {
      // Token refresh failed, user needs to login again
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle clear auth state request.
  void _onAuthClearRequested(
    AuthClearRequested event,
    Emitter<AuthState> emit,
  ) {
    _authRepository.clearAuthData();
    emit(const AuthInitial());
  }
}
