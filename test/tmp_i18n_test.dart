import 'package:arohya/app.dart';
import 'package:arohya/core/localization/app_localizations.dart';
import 'package:arohya/core/localization/kannada_strings.dart';
import 'package:arohya/core/router/app_router.dart';
import 'package:arohya/core/api/api_endpoints.dart';
import 'package:arohya/core/api/api_provider.dart';
import 'package:arohya/core/api/api_response.dart';
import 'package:arohya/core/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('language switch works across onboarding, login, home, apply', (
    tester,
  ) async {
    final old = FlutterError.onError;
    FlutterError.onError = (d) {
      // wide fallback font in tests causes unrelated overflow noise
      if (d.exceptionAsString().contains('overflowed')) return;
      old?.call(d);
    };
    addTearDown(() => FlutterError.onError = old);
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiServiceProvider.overrideWithValue(_TestApiService())],
        child: const ArohyaApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pump(const Duration(milliseconds: 500));

    // ── Onboarding ──
    expect(find.text('Get Started / Create Account'), findsOneWidget);
    expect(find.text('English / ಕನ್ನಡ'), findsOneWidget);

    await tester.tap(find.text('English / ಕನ್ನಡ'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('ಪ್ರಾರಂಭಿಸಿ / ಖಾತೆ ತೆರೆಯಿರಿ'), findsOneWidget);
    expect(find.text('ಕನ್ನಡ / English'), findsOneWidget);
    expect(find.text('ಬಿಟ್ಟುಬಿಡಿ'), findsOneWidget); // Skip
    expect(find.text('ಭಾರತೀಯ ಉದ್ಯಮಗಳಿಗೆ ಸಾರ್ವಭೌಮ ಬಂಡವಾಳ'), findsOneWidget);

    // Expand value props (data-driven strings)
    await tester.tap(find.text('ಇನ್ನಷ್ಟು ಓದಿ')); // Read more
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('ಅಕೌಂಟ್ ಅಗ್ರಿಗೇಟರ್ ನೇರ ಏಕೀಕರಣ'), findsOneWidget);

    // back to English and forth
    await tester.tap(find.text('ಕನ್ನಡ / English'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Get Started / Create Account'), findsOneWidget);
    await tester.tap(find.text('English / ಕನ್ನಡ'));
    await tester.pump(const Duration(milliseconds: 400));

    // ── Login (Kannada) incl. focusing a field -> Material localizations ──
    appRouter.go('/login');
    // The swipe CTA intentionally has a repeating idle animation, so use a
    // bounded pump instead of waiting for every animation to settle.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('ಮರಳಿ ಸ್ವಾಗತ'), findsOneWidget);
    expect(find.text('ಇಮೇಲ್ OTP'), findsOneWidget); // tab
    expect(find.text('ಸುರಕ್ಷಿತ OTP ಪಡೆಯಿರಿ'), findsOneWidget); // swipe label
    await tester.tap(find.byType(TextField).first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    // ── Home ──
    appRouter.go('/home');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('ಮುಖಪುಟ'), findsOneWidget); // nav: Home
    expect(find.text('ಹಣಕಾಸು ಪರಿಹಾರಗಳು'), findsOneWidget);
    expect(find.text('ಗೃಹ ಸಾಲ'), findsOneWidget);

    // home pill toggles to English and back
    await tester.tap(find.text('EN'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Financing Solutions'), findsOneWidget);
    await tester.tap(find.text('ಕನ್ನಡ'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(find.text('ಹಣಕಾಸು ಪರಿಹಾರಗಳು'), findsOneWidget);

    // other tabs
    await tester.tap(find.text('ಸಾಲಗಳು'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('ಸಕ್ರಿಯ ಸೌಲಭ್ಯಗಳು ಮತ್ತು ಇತಿಹಾಸ'), findsOneWidget);
    await tester.tap(find.text('ಬೆಂಬಲ'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('ಫಿಡ್ಯೂಷಿಯರಿ ಬೆಂಬಲ ಡೆಸ್ಕ್'), findsOneWidget);
    expect(find.text('ಸಾಂಸ್ಥಿಕ ಸಹಾಯವಾಣಿ'), findsOneWidget);
    await tester.tap(find.text('ಪ್ರೊಫೈಲ್'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('ಭದ್ರತೆ ಮತ್ತು ಒಪ್ಪಿಗೆ'), findsOneWidget);
    expect(find.text('ಬಯೋಮೆಟ್ರಿಕ್ ಅನ್‌ಲಾಕ್'), findsOneWidget);
    await tester.tap(find.text('ಮುಖಪುಟ'));
    await tester.pump(const Duration(milliseconds: 300));

    // ── Apply loan from a card (type stays English internally) ──
    await tester.ensureVisible(find.text('ಗೃಹ ಸಾಲ'));
    await tester.tap(find.text('ಗೃಹ ಸಾಲ'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('ಸಾಲಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'), findsOneWidget);
    expect(find.text('ಗೃಹ ಸಾಲ'), findsNWidgets(2)); // heading + dropdown
    expect(find.text('ಆದಾಯ (ಐಚ್ಛಿಕ)'), findsOneWidget);
    expect(find.text('ಸಾಲ ಅಗತ್ಯವಿರುವ ದಿನಾಂಕ (ಐಚ್ಛಿಕ)'), findsOneWidget);

    // dropdown opens (needs MaterialLocalizations) and lists Kannada names
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('SHCG').last);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('SHCG'), findsWidgets);

    // validation message in Kannada
    await tester.ensureVisible(find.text('ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'));
    await tester.tap(find.text('ಅರ್ಜಿ ಸಲ್ಲಿಸಿ'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('ಮೊದಲ ಹೆಸರನ್ನು ನಮೂದಿಸಿ'), findsWidgets);

    // ── Fallback & placeholders ──
    final l10n = const AppLocalizations(AppLocalizations.kannada);
    expect(
      l10n.tr('Some text with no translation'),
      'Some text with no translation',
    );
    expect(
      l10n.tr('Verification code sent to {email}', args: {'email': 'a@b.com'}),
      'a@b.com ಗೆ ಪರಿಶೀಲನಾ ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ',
    );
    expect(kannadaStrings.length, greaterThan(200));
    expect(tester.takeException(), isNull);
  });
}

class _TestApiService extends ApiService {
  @override
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, Object?>? queryParameters,
    bool authenticated = true,
    String languageCode = 'en',
    T Function(Object? json)? decodeData,
    Duration timeout = ApiService.defaultTimeout,
  }) async {
    final Object? data;
    switch (endpoint) {
      case ApiEndpoints.dashboard:
        data = {
          'user': {
            'firstName': 'Rajesh',
            'kycStatus': 'verified',
            'tierLabel': 'Prime',
          },
          'activeApplication': null,
          'unreadNotificationCount': 0,
        };
      case ApiEndpoints.financingSolutions:
        data = {
          'initialVisibleCount': 5,
          'products': [
            _product('personal', 'Personal Loan', 1, 'personal'),
            _product('business', 'Business Loan', 2, 'business'),
            _product('home', 'Home Loan', 3, 'home'),
            _product('vehicle', 'Vehicle Loan', 4, 'vehicle'),
            _product('property', 'Loan Against Property', 5, 'property'),
            _product('invoice', 'Invoice Discounting', 6, 'invoice', false),
            _product('shcg', 'SHCG', 7, 'group', false),
            _product('insurance', 'Insurance', 8, 'insurance', false),
          ],
        };
      case ApiEndpoints.loanFacilities:
        data = {
          'items': [
            {
              'id': 'facility_01',
              'title': 'Working Capital Line',
              'sanctionedAmount': 2500000,
              'currency': 'INR',
              'nextEmiAmount': 58450,
              'nextEmiDate': '2026-11-05',
              'status': 'active',
              'statusLabel': 'Active',
              'autoDebitActive': true,
            },
          ],
        };
      case ApiEndpoints.support:
        data = {
          'relationshipManager': {
            'id': 'rm_01',
            'name': 'Vikram Krishnamurthy',
            'title': 'Senior Fiduciary Relationship Manager',
            'initials': 'VK',
            'available': true,
            'availabilityLabel': 'Available 09:00 - 19:00 IST',
          },
          'channels': [
            {
              'id': 'helpline',
              'type': 'phone',
              'title': 'Institutional Helpline',
              'subtitle': '+91 80 4920 1800 (Toll Free)',
              'fallbackIconKey': 'phone',
              'sortOrder': 1,
            },
          ],
        };
      case ApiEndpoints.profile:
        data = {
          'id': 'user_01',
          'fullName': 'Rajesh Kumar Gowda',
          'email': 'rajesh.gowda@example.com',
          'mobileNumber': '9845012849',
          'businessType': 'Sole Proprietorship',
          'panMasked': 'ABCDE****F',
          'gstinStatus': 'verified',
          'gstinMasked': 'AAACB****F1Z5',
          'accountAggregator': {
            'status': 'linked',
            'handle': '9845012849@finvu',
          },
          'kycStatus': 'verified',
          'preferences': {'biometricEnabled': true},
        };
      default:
        data = null;
    }
    final decoded = data == null
        ? null
        : decodeData != null
        ? decodeData(data)
        : data as T;
    return ApiResponse<T>(success: true, message: 'OK', data: decoded);
  }

  static Map<String, Object?> _product(
    String id,
    String title,
    int sortOrder,
    String iconKey, [
    bool visibleInitially = true,
  ]) {
    return {
      'id': id,
      'slug': id,
      'title': title,
      'amountLabel': 'Flexible amount',
      'badgeText': 'Available',
      'badgeTone': 'primary',
      'rateLabel': 'Custom rate',
      'fallbackIconKey': iconKey,
      'sortOrder': sortOrder,
      'visibleInitially': visibleInitially,
      'applicationEnabled': true,
      'category': 'loan',
      'active': true,
    };
  }
}
