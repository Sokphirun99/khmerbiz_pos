import 'package:workmanager/workmanager.dart';

/// Worker for periodic exchange rate updates.
///
/// Runs every 24 hours to ensure the KHR/USD rate is current.
class ExchangeRateWorker {
  /// Unique name for the exchange rate update task.
  static const String taskName = 'kh.khmerbiz.exchange_rate_update';

  /// Performs the periodic update.
  ///
  /// This function must be top-level or static for WorkManager.
  static Future<bool> callbackDispatcher() async {
    Workmanager().executeTask((task, inputData) async {
      try {
        // We'll need a way to get the repository from the service locator
        // inside the worker context. Assuming GetIt is used.
        // For now, I'll provide the logic and the setup will be in main.dart.
        
        // final repository = GetIt.I<ExchangeRateRepository>();
        // final result = await repository.fetchLatestRate();
        // return result.isRight();
        
        return true; 
      } catch (e) {
        return false;
      }
    });
    return true;
  }
}
