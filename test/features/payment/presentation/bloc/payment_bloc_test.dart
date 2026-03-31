import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/core/network/network_info.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/khqr_data.dart';
import 'package:khmerbiz_pos/domain/entities/merchant_info.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/khqr_repository.dart';
import 'package:khmerbiz_pos/features/payment/data/deep_link_helper.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_event.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_state.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────

class MockKhqrRepository extends Mock implements KhqrRepository {}

class MockExchangeRateRepository extends Mock
    implements ExchangeRateRepository {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockDeepLinkHelper extends Mock implements DeepLinkHelper {}

// ── Test Fixtures ─────────────────────────────────────────────────────────

final _now = DateTime(2026, 3, 30, 10);
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
  late MockDeepLinkHelper mockDeepLinkHelper;

  setUp(() {
    mockKhqrRepo = MockKhqrRepository();
    mockExchangeRateRepo = MockExchangeRateRepository();
    mockNetworkInfo = MockNetworkInfo();
    mockDeepLinkHelper = MockDeepLinkHelper();

    registerFallbackValue(MerchantInfo.placeholder);
  });

  PaymentBloc buildBloc() {
    return PaymentBloc(
      khqrRepository: mockKhqrRepo,
      exchangeRateRepository: mockExchangeRateRepo,
      networkInfo: mockNetworkInfo,
      deepLinkHelper: mockDeepLinkHelper,
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
        ),).thenAnswer((_) async => Right(_testKhqrData));
  }

  void stubQrGenerationFailure() {
    when(() => mockKhqrRepo.generateDynamicQR(
          amountKHR: any(named: 'amountKHR'),
          invoiceId: any(named: 'invoiceId'),
          merchantInfo: any(named: 'merchantInfo'),
        ),).thenAnswer((_) async => const Left(_testPaymentFailure));
  }

  // ═══════════════════════════════════════════════════════════════════════
  // INITIAL STATE
  // ═══════════════════════════════════════════════════════════════════════

  group('PaymentBloc initial state', () {
    test('should start with PaymentIdle', () {
      stubOnlineAndFreshRate();
      final bloc = buildBloc();
      expect(bloc.state, const PaymentIdle());
      bloc.close();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // INITIATE KHQR PAYMENT
  // ═══════════════════════════════════════════════════════════════════════

  group('InitiateKhqrPayment', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits [KhqrGenerating, KhqrReady] on success',
      build: () {
        stubOnlineAndFreshRate();
        stubQrGenerationSuccess();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-TEST-001',
      ),),
      expect: () => [
        const KhqrGenerating(),
        isA<KhqrReady>()
            .having((s) => s.qrString, 'qrString', _testKhqrData.qrString)
            .having((s) => s.amountKHR, 'amountKHR', _testKhqrData.amountKHR),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits [KhqrGenerating, PaymentFailed] when QR generation fails',
      build: () {
        stubOnlineAndFreshRate();
        stubQrGenerationFailure();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-TEST-001',
      ),),
      expect: () => [
        const KhqrGenerating(),
        isA<PaymentFailed>(),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentFailed] when device is offline',
      build: () {
        stubOffline();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateKhqrPayment(
        amountKHR: 50000,
        invoiceId: 'INV-TEST-001',
      ),),
      expect: () => [
        isA<PaymentFailed>().having((s) => s.failure.messageEn, 'messageEn',
            contains('Network connection required'),),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // DEEP LINK PAYMENTS
  // ═══════════════════════════════════════════════════════════════════════

  group('Deep Link Payments', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits ExternalAppLaunched for ABA',
      build: () {
        stubOnlineAndFreshRate();
        when(() => mockDeepLinkHelper.launchAbaPay(
              amount: any(named: 'amount'),
              invoiceId: any(named: 'invoiceId'),
              merchantId: any(named: 'merchantId'),
            ),).thenAnswer((_) async => true);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateAbaDeepLink(
        amountKHR: 100000,
        invoiceId: 'INV-ABA-001',
      ),),
      expect: () => [
        const ExternalAppLaunched(method: PaymentMethod.aba),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits ExternalAppLaunched for Wing',
      build: () {
        stubOnlineAndFreshRate();
        when(() => mockDeepLinkHelper.launchWingMoney(
              amount: any(named: 'amount'),
              invoiceId: any(named: 'invoiceId'),
              merchantPhone: any(named: 'merchantPhone'),
            ),).thenAnswer((_) async => true);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const InitiateWingDeepLink(
        amountKHR: 75000,
        invoiceId: 'INV-WING-001',
      ),),
      expect: () => [
        const ExternalAppLaunched(method: PaymentMethod.wing),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // MANUAL PAYMENT
  // ═══════════════════════════════════════════════════════════════════════

  group('MarkManualPayment', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentConfirmed with manual info',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const MarkManualPayment(
        method: PaymentMethod.cash,
        notes: 'Paid in cash',
      ),),
      expect: () => [
        const PaymentConfirmed(
          method: PaymentMethod.cash,
          reference: 'Paid in cash',
          amountKHR: 0, // In real test we'd set currentAmount
          md5Hash: '',
        ),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CANCEL & TIMER
  // ═══════════════════════════════════════════════════════════════════════

  group('Cancel & Timeout', () {
    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentCancelled on CancelPayment event',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const CancelPayment()),
      expect: () => [const PaymentCancelled()],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits PaymentTimeout on KhqrPaymentTimeout event',
      build: () {
        stubOnlineAndFreshRate();
        return buildBloc();
      },
      act: (bloc) => bloc.add(const KhqrPaymentTimeout()),
      expect: () => [const PaymentTimeout()],
    );
  });
}
