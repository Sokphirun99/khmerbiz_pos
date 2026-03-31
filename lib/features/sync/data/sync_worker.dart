import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:khmerbiz_pos/core/utils/app_logger.dart';
import 'package:workmanager/workmanager.dart';

/// Callback for WorkManager background tasks.
///
/// This runs in a separate isolate, so minimal initialization is required.
/// For now, this is a placeholder that triggers the SyncBloc via a platform channel.
/// In production, you would initialize minimal DI and process the sync queue directly.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    AppLogger.d('Executing sync task: $task', tag: 'SyncWorker');

    try {
      // Check connectivity
      final connectivity = Connectivity();
      final results = await connectivity.checkConnectivity();
      final hasConnection = results.any((r) => r != ConnectivityResult.none);

      if (!hasConnection) {
        AppLogger.d('No connectivity - skipping sync', tag: 'SyncWorker');
        return Future.value(false);
      }

      switch (task) {
        case 'khmerbiz_sync':
          // In production: process sync queue directly
          // For now, just log that sync was triggered
          AppLogger.d('Background sync triggered', tag: 'SyncWorker');
          return Future.value(true);

        case 'khmerbiz_rate_refresh':
          // In production: fetch and update exchange rate
          AppLogger.d('Exchange rate refresh triggered', tag: 'SyncWorker');
          return Future.value(true);

        default:
          AppLogger.w('Unknown task: $task', tag: 'SyncWorker');
          return Future.value(false);
      }
    } catch (e) {
      AppLogger.e('Sync task failed', tag: 'SyncWorker', error: e);
      return Future.value(false);
    }
  });
}
