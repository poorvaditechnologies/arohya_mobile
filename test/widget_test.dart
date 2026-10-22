import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arohya/app.dart';
import 'package:arohya/core/widgets/app_button.dart';
import 'package:arohya/features/home/widget/financing_solutions_grid.dart';
import 'package:arohya/features/home/models/financing_solution_model.dart';
import 'package:arohya/features/home/provider/home_provider.dart';
import 'package:arohya/features/loans/models/loan_application_model.dart';
import 'package:arohya/features/onboarding/models/onboarding_model.dart';
import 'package:arohya/features/onboarding/widget/expandable_value_props.dart';

void main() {
  testWidgets('ArohyaApp loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ArohyaApp()));

    // Verify that the initial frame renders
    expect(find.byType(ArohyaApp), findsOneWidget);
  });

  testWidgets('Google sign-in button renders search.svg', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Continue with Google',
            variant: AppButtonVariant.google,
          ),
        ),
      ),
    );

    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('ExpandableValueProps expands and collapses on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ExpandableValueProps(
                valueProps: [
                  ValuePropModel(
                    icon: Icons.verified,
                    iconBg: Colors.blue,
                    iconColor: Colors.white,
                    title: 'Test Title 1',
                    subtitle: 'Test Subtitle 1',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Read more'), findsOneWidget);
    expect(find.text('Test Title 1'), findsNothing);

    await tester.tap(find.text('Read more'));
    await tester.pumpAndSettle();

    expect(find.text('Show less'), findsOneWidget);
    expect(find.text('Test Title 1'), findsOneWidget);

    await tester.tap(find.text('Show less'));
    await tester.pumpAndSettle();

    expect(find.text('Read more'), findsOneWidget);
    expect(find.text('Test Title 1'), findsNothing);
  });

  testWidgets('Financing solutions show the revised expanded offerings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          financingSolutionsProvider.overrideWith(
            (ref) async => _financingCatalog,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FinancingSolutionsGrid()),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Gold Loan'), findsNothing);
    expect(find.text('Working Capital'), findsNothing);
    expect(find.text('Machinery Loan'), findsNothing);
    expect(find.text('SHCG'), findsNothing);
    expect(find.text('Insurance'), findsNothing);

    await tester.ensureVisible(find.text('View More Solutions (3 more)'));
    await tester.tap(find.text('View More Solutions (3 more)'));
    await tester.pumpAndSettle();

    expect(find.text('SHCG'), findsOneWidget);
    expect(find.text('Insurance'), findsOneWidget);
    expect(find.text('Gold Loan'), findsNothing);
    expect(find.text('Working Capital'), findsNothing);
    expect(find.text('Machinery Loan'), findsNothing);
  });

  test('Loan application serializes optional income and needed date', () {
    final neededDate = DateTime(2026, 12, 15);
    final application = LoanApplicationModel(
      productId: 'product_shcg',
      firstName: 'Rajesh',
      lastName: 'Gowda',
      mobile: '9845012849',
      permanentAddress: 'Bengaluru, Karnataka',
      temporaryAddress: 'Bengaluru, Karnataka',
      email: 'rajesh@example.com',
      income: 75000,
      loanNeededDate: neededDate,
    );

    final decoded = LoanApplicationModel.fromJson(application.toJson());

    expect(decoded.income, 75000);
    expect(decoded.loanNeededDate, neededDate);
  });
}

const _financingCatalog = FinancingSolutionsCatalog(
  initialVisibleCount: 2,
  products: [
    FinancingSolutionModel(
      id: 'personal',
      slug: 'personal-loan',
      title: 'Personal Loan',
      amountLabel: 'Up to ₹25L',
      badgeText: 'Popular',
      badgeTone: 'primary',
      rateLabel: 'From 10.5%',
      fallbackIconKey: 'personal',
      sortOrder: 1,
      visibleInitially: true,
      applicationEnabled: true,
      category: 'loan',
      active: true,
    ),
    FinancingSolutionModel(
      id: 'home',
      slug: 'home-loan',
      title: 'Home Loan',
      amountLabel: 'Up to ₹5Cr',
      badgeText: 'Low rate',
      badgeTone: 'success',
      rateLabel: 'From 8.5%',
      fallbackIconKey: 'home',
      sortOrder: 2,
      visibleInitially: true,
      applicationEnabled: true,
      category: 'loan',
      active: true,
    ),
    FinancingSolutionModel(
      id: 'invoice',
      slug: 'invoice-discounting',
      title: 'Invoice Discounting',
      amountLabel: 'Flexible',
      badgeText: 'Fast',
      badgeTone: 'neutral',
      rateLabel: 'Custom',
      fallbackIconKey: 'invoice',
      sortOrder: 3,
      visibleInitially: false,
      applicationEnabled: true,
      category: 'loan',
      active: true,
    ),
    FinancingSolutionModel(
      id: 'shcg',
      slug: 'shcg',
      title: 'SHCG',
      amountLabel: 'Flexible',
      badgeText: 'New',
      badgeTone: 'primary',
      rateLabel: 'Custom',
      fallbackIconKey: 'group',
      sortOrder: 4,
      visibleInitially: false,
      applicationEnabled: true,
      category: 'loan',
      active: true,
    ),
    FinancingSolutionModel(
      id: 'insurance',
      slug: 'insurance',
      title: 'Insurance',
      amountLabel: 'Multiple plans',
      badgeText: 'Protection',
      badgeTone: 'success',
      rateLabel: 'Custom',
      fallbackIconKey: 'insurance',
      sortOrder: 5,
      visibleInitially: false,
      applicationEnabled: true,
      category: 'insurance',
      active: true,
    ),
  ],
);
