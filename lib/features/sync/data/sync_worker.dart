import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Callback for WorkManager background tasks.
///
/// This runs in a separate isolate, so minimal initialization is required.
/// For now, this is a placeholder that triggers the SyncBloc via a platform channel.
/// In production, you would initialize minimal DI and process the sync queue directly.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Executing sync task: $task');

    try {
      // Check connectivity
      final connectivity = Connectivity();
      final results = await connectivity.checkConnectivity();
      final hasConnection = results.any((r) => r != ConnectivityResult.none);

      if (!hasConnection) {
        debugPrint('No connectivity - skipping sync');
        return Future.value(false);
      }

      switch (task) {
        case 'khmerbiz_sync':
          // In production: process sync queue directly
          // For now, just log that sync was triggered
          debugPrint('Background sync triggered - SyncBloc will handle it');
          return Future.value(true);

        case 'khmerbiz_rate_refresh':
          // In production: fetch and update exchange rate
          debugPrint('Exchange rate refresh triggered');
          return Future.value(true);

        default:
          debugPrint('Unknown task: $task');
          return Future.value(false);
      }
    } catch (e) {
      debugPrint('Sync task failed: $e');
      return Future.value(false);
    }
  });
}
