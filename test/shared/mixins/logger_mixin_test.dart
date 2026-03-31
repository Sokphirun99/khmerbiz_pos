import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmerbiz_pos/shared/mixins/helpers.dart';

class LoggerTest with LoggerMixin {}

void main() {
  group('LoggerMixin', () {
    final logger = LoggerTest();

    test('debugLog does not throw error', () {
      expect(() => logger.debugLog('test message'), returnsNormally);
    });

    test('infoLog does not throw error', () {
      expect(() => logger.infoLog('test message'), returnsNormally);
    });

    test('warningLog does not throw error', () {
      expect(() => logger.warningLog('test message'), returnsNormally);
    });

    test('errorLog does not throw error', () {
      expect(() => logger.errorLog('test message', error: 'error object', stackTrace: StackTrace.current), returnsNormally);
    });

    test('kDebugMode is available', () {
        expect(kDebugMode, isTrue); // In tests, kDebugMode is usually true
    });
  });
}
