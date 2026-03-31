import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart' show Failure;

/// Base class for all use cases.
///
/// Use cases contain the business logic and are called by BLoCs.
/// They only depend on repository interfaces from the domain layer.
///
/// Usage:
/// ```dart
/// final useCase = sl<LoginUseCase>();
/// final result = await useCase.execute(credentials);
/// ```
abstract class UseCase<Type, Params> {
  /// Execute the use case business logic.
  ///
  /// [params] - Parameters needed for execution
  /// Returns [Type] on success
  /// Throws [Failure] subclasses on error
  Future<Type> call(Params params);
}

/// Use case for no parameters.
class NoParams extends Equatable {
  /// Creates [NoParams].
  const NoParams();

  @override
  List<Object?> get props => [];
}
