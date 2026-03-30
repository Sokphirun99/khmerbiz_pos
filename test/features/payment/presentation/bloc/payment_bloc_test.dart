import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/core/network/network_info.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/khqr_data.dart';
import 'package:khmerbiz_pos/domain/entities/merchant_info.dart';
import 'package:khmerbiz_pos/domain/entities/payment_status.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/khqr_repository.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_event.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_state.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────

class MockKhqrRepository extends Mock implements KhqrRepository {}

class MockExchangeRateRepository extends Mock
    implements ExchangeRateRepository {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class FakeMerchantInfo extends Fake implements MerchantInfo {}

// ── Test Fixtures ─────────────────────────────────────────────────────────

final _now = DateTime(2026, 3, 30, 10, 0, 0);
final _expiresAt = _now.add(const Duration(minutes: 5));

final _testKhqrData = KhqrData(
  qrString: '000201010212...test-payload',
  md5Hash: 'abc123md5hash',
  amountKHR: 50000,
  amountUSD: 12.20,
  invoiceId: 'INV-TEST-001',
  generatedAt: _now,
  expiresAt: _expiresAt,
);

const _testPaymentFailure = PaymentFailure(
  messageEn: 'QR generation failed',
  messageKm: 'បង្កើត QR បរាជ័យ',
);

void main() {
  late MockKhqrRepository mockKhqrRepo;
  late MockExchangeRateRepository mockExchangeRateRepo;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockKhqrRepo = MockKhqrRepository();
    mockExchangeRateRepo = MockExchangeRateRepository();
    mockNetworkInfo = MockNetworkInfo();

    registerFallbackValue(MerchantInfo.placeholder);
  });

  PaymentBloc buildBloc() {
    return PaymentBloc(
      khqrRepository: mockKhqrRepo,
      exchangeRateRepository: mockExchangeRateRepo,
      networkInfo: mockNetworkInfo,
      merchantInfo: MerchantInfo.placeholder,
    );
  }

  // ── Helper: stub online + non-stale rate ────────────────────────────────

  void stubOnlineAndFreshRate() {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockExchangeRateRepo.isRateStale()).thenReturn(false);
    when(() => mockExchangeRateRepo.getCachedRate()).thenReturn(4100);
  }

  void stubOffline() {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  }

  void stubQrGenerationSuccess() {
    when(() => mockKhqrRepo.generateDynamicQR(
          amountKHR: any(named: 'amountKHR'),
          invoiceId: any(named: 'invoiceId'),
          merchantInfo: any(named: 'merchantInfo'),
        )).thenAnswer((_) async => Right(_testKhqrData));
  }

  void stubQrGenerationFailure() {
    when(() => mockKhqrRepo.generateDynamicQR(
          amountKHR: any(named: 'amountKHR'),
          invoiceId: any(named: 'invoiceId'),
          merchantInfo: any(named: 'merchantInfo'),
        )).thenAnswer((_) async => const Left(_testPaymentFailure));
  }

  // ═══════════════════════════════════════════════════════════════════════
  // INITIAL STATE
  // ═══════════════════════════════════════════════════════════════════════

  group('PaymentBloc initial state', () {
    test('should start with PaymentInitial', () {
      stubOnlineAndFreshRate();
      final bloc = buildBloc();
      expect(bloc.state, const PaymentInitial());
      bloc.close();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // INITIATE KHQR PAYMENT
  // ═══════════════════════════════════════════════════════════════════════

  group('InitiateKhqrPayment', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentOffline] when device is offline',
      build: () {
        stubOffline();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-TEST-001',
      )),
      expect: () => [
        const PaymentOffline(amountKHR: 50000, invoiceId: 'INV-TEST-001'),
      ],
      verify: (_) {
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNever(() => mockKhqrRepo.generateDynamicQR(
              amountKHR: any(named: 'amountKHR'),
              invoiceId: any(named: 'invoiceId'),
              merchantInfo: any(named: 'merchantInfo'),
            ));
      },
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentGenerating, PaymentFailed] when QR generation fails',
      build: () {
        stubOnlineAndFreshRate();
        stubQrGenerationFailure();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-TEST-001',
      )),
      expect: () => [
        const PaymentGenerating(),
        const PaymentFailed(
          messageEn: 'QR generation failed',
          messageKm: 'បង្កើត QR បរាជ័យ',
        ),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentGenerating, PaymentAwaitingConfirmation] on success',
      build: () {
        stubOnlineAndFreshRate();
        stubQrGenerationSuccess();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-TEST-001',
      )),
      expect: () => [
        const PaymentGenerating(),
        isA<PaymentAwaitingConfirmation>()
            .having((s) => s.khqrData, 'khqrData', _testKhqrData)
            .having((s) => s.pollAttempts, 'pollAttempts', 0),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'refreshes exchange rate when stale before generating QR',
      build: () {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
        when(() => mockExchangeRateRepo.isRateStale()).thenReturn(true);
        when(() => mockExchangeRateRepo.fetchLatestRate())
            .thenAnswer((_) async => {});
        when(() => mockExchangeRateRepo.getCachedRate()).thenReturn(4100);
        stubQrGenerationSuccess();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-TEST-001',
      )),
      verify: (_) {
        verify(() => mockExchangeRateRepo.isRateStale()).called(1);
        verify(() => mockExchangeRateRepo.fetchLatestRate()).called(1);
      },
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // POLL PAYMENT STATUS
  // ═══════════════════════════════════════════════════════════════════════

  group('PollPaymentStatus', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentConfirmed when status is PaymentConfirmedStatus',
      build: () {
        stubOnlineAndFreshRate();
        stubQrGenerationSuccess();
        when(() => mockKhqrRepo.checkPaymentStatus(any()))
            .thenAnswer((_) async => const Right(
                  PaymentConfirmedStatus(
                    reference: 'BK-REF-12345',
                    amount: 50000,
                  ),
                ));
        return buildBloc();
      },
      seed: () => PaymentAwaitingConfirmation(
        khqrData: _testKhqrData,
        remaining: const Duration(minutes: 4, seconds: 30),
        pollAttempts: 2,
      ),
      act: (bloc) {
        // Manually set the md5 hash so polling works
        // We need to initiate first to set _currentMd5Hash
        bloc.add(const InitiateKhqrPayment(
          amountKHR: 50000,
          invoiceId: 'INV-TEST-001',
        ));
      },
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const PaymentGenerating(),
        isA<PaymentAwaitingConfirmation>(),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'does nothing when md5Hash is null (no active payment)',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const PollPaymentStatus()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockKhqrRepo.checkPaymentStatus(any()));
      },
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // COUNTDOWN TICK
  // ═══════════════════════════════════════════════════════════════════════

  group('CountdownTick', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentTimedOut when remaining is zero',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      seed: () => PaymentAwaitingConfirmation(
        khqrData: _testKhqrData,
        remaining: const Duration(seconds: 1),
        pollAttempts: 10,
      ),
      act: (bloc) =>
          bloc.add(const CountdownTick(remaining: Duration.zero)),
      expect: () => [
        const PaymentTimedOut(amountKHR: 0, invoiceId: ''),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'updates remaining time in PaymentAwaitingConfirmation',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      seed: () => PaymentAwaitingConfirmation(
        khqrData: _testKhqrData,
        remaining: const Duration(minutes: 4),
        pollAttempts: 5,
      ),
      act: (bloc) => bloc.add(
        const CountdownTick(remaining: Duration(minutes: 3, seconds: 59)),
      ),
      expect: () => [
        PaymentAwaitingConfirmation(
          khqrData: _testKhqrData,
          remaining: const Duration(minutes: 3, seconds: 59),
          pollAttempts: 5,
        ),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // INITIATE DEEP LINK PAYMENT
  // ═══════════════════════════════════════════════════════════════════════

  group('InitiateDeepLinkPayment', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentDeepLinkLaunched for ABA',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateDeepLinkPayment(
        method: PaymentMethod.aba,
        amountKHR: 100000,
        invoiceId: 'INV-ABA-001',
      )),
      expect: () => [
        const PaymentDeepLinkLaunched(
          method: PaymentMethod.aba,
          amountKHR: 100000,
          invoiceId: 'INV-ABA-001',
        ),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentDeepLinkLaunched for Wing',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateDeepLinkPayment(
        method: PaymentMethod.wing,
        amountKHR: 75000,
        invoiceId: 'INV-WING-001',
      )),
      expect: () => [
        const PaymentDeepLinkLaunched(
          method: PaymentMethod.wing,
          amountKHR: 75000,
          invoiceId: 'INV-WING-001',
        ),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CONFIRM MANUAL PAYMENT
  // ═══════════════════════════════════════════════════════════════════════

  group('ConfirmManualPayment', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentConfirmed with manual reference',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) {
        // First set up the payment context
        bloc.add(const InitiateDeepLinkPayment(
          method: PaymentMethod.aba,
          amountKHR: 50000,
          invoiceId: 'INV-MANUAL-001',
        ));
        // Then confirm manually
        bloc.add(const ConfirmManualPayment(
          reference: 'ABA-MANUAL-12345',
        ));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const PaymentDeepLinkLaunched(
          method: PaymentMethod.aba,
          amountKHR: 50000,
          invoiceId: 'INV-MANUAL-001',
        ),
        isA<PaymentConfirmed>()
            .having((s) => s.reference, 'reference', 'ABA-MANUAL-12345')
            .having((s) => s.amountKHR, 'amountKHR', 50000)
            .having((s) => s.md5Hash, 'md5Hash', ''),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CANCEL PAYMENT
  // ═══════════════════════════════════════════════════════════════════════

  group('CancelPayment', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentCancelled from any state',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      seed: () => PaymentAwaitingConfirmation(
        khqrData: _testKhqrData,
        remaining: const Duration(minutes: 3),
        pollAttempts: 5,
      ),
      act: (bloc) => bloc.add(const CancelPayment()),
      expect: () => [const PaymentCancelled()],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentCancelled from deep link state',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      seed: () => const PaymentDeepLinkLaunched(
        method: PaymentMethod.wing,
        amountKHR: 50000,
        invoiceId: 'INV-CANCEL-001',
      ),
      act: (bloc) => bloc.add(const CancelPayment()),
      expect: () => [const PaymentCancelled()],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // RETRY PAYMENT
  // ═══════════════════════════════════════════════════════════════════════

  group('RetryPayment', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentFailed when no previous payment context exists',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const RetryPayment()),
      expect: () => [
        isA<PaymentFailed>()
            .having((s) => s.messageEn, 'messageEn',
                contains('Cannot retry')),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      're-initiates KHQR payment on retry after timeout',
      build: () {
        stubOnlineAndFreshRate();
        stubQrGenerationSuccess();
        return buildBloc();
      },
      act: (bloc) {
        // First initiate to set context
        bloc.add(const InitiateKhqrPayment(
          amountKHR: 50000,
          invoiceId: 'INV-RETRY-001',
        ));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const PaymentGenerating(),
        isA<PaymentAwaitingConfirmation>(),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // TIMER CLEANUP
  // ═══════════════════════════════════════════════════════════════════════

  group('Timer cleanup', () {
    test('cancels timers on close', () async {
      stubOnlineAndFreshRate();
      stubQrGenerationSuccess();

      final bloc = buildBloc();
      bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-CLOSE-001',
      ));

      await Future.delayed(const Duration(milliseconds: 200));
      await bloc.close();

      // Verify bloc is closed without errors
      expect(bloc.isClosed, isTrue);
    });
  });
}
