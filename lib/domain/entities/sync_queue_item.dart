import 'package:equatable/equatable.dart';

class SyncQueueItem extends Equatable {
  const SyncQueueItem({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.createdAt,
    this.attemptCount = 0,
    this.lastAttemptAt,
    this.status = 'pending',
    this.errorMessage,
    this.priority = 5,
  });
  final String id;
  final String operationType;
  final String entityType;
  final String entityId;
  final String payload;
  final int attemptCount;
  final DateTime? lastAttemptAt;
  final String status;
  final String? errorMessage;
  final int priority;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        operationType,
        entityType,
        entityId,
        payload,
        attemptCount,
        lastAttemptAt,
        status,
        errorMessage,
        priority,
        createdAt,
      ];
}
