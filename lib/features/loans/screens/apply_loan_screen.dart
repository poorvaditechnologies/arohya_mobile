import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/utils/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../auth/provider/auth_provider.dart';
import '../../home/provider/home_provider.dart';
import '../models/loan_application_model.dart';
import '../provider/apply_loan_provider.dart';
import '../widget/loan_type_field.dart';
import '../../../core/localization/app_localizations.dart';

/// Apply Loan screen, opened from a Financing Solutions card on the home tab.
///
/// [productId] is the stable identifier of the tapped financing solution.
class ApplyLoanScreen extends ConsumerStatefulWidget {
  final String? productId;

  const ApplyLoanScreen({super.key, this.productId});

  @override
  ConsumerState<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends ConsumerState<ApplyLoanScreen> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Letters (any script), spaces, dots, apostrophes and hyphens; must start
  /// with a letter. Combining marks (\p{M}) are allowed because scripts like
  /// Kannada write vowel signs and conjuncts with them (e.g. ರಾಜೇಶ್).
  static final _namePattern = RegExp(
    r"^\p{L}[\p{L}\p{M} .'-]*$",
    unicode: true,
  );

  final _formKey = GlobalKey<FormState>();

  // One key per field so we can scroll to the first invalid one on submit.
  final _firstNameKey = GlobalKey();
  final _lastNameKey = GlobalKey();
  final _mobileKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _loanTypeKey = GlobalKey();
  final _permanentAddressKey = GlobalKey();
  final _temporaryAddressKey = GlobalKey();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _temporaryAddressController = TextEditingController();
  final _emailController = TextEditingController();
  final _incomeController = TextEditingController();
  final _loanNeededDateController = TextEditingController();

  DateTime? _loanNeededDate;

  @override
  void initState() {
    super.initState();
    _prefillFromAccount();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _permanentAddressController.dispose();
    _temporaryAddressController.dispose();
    _emailController.dispose();
    _incomeController.dispose();
    _loanNeededDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _selectLoanNeededDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _loanNeededDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 5, today.month, today.day),
    );
    if (selectedDate == null || !mounted) return;

    setState(() {
      _loanNeededDate = selectedDate;
      _loanNeededDateController.text = _formatDate(selectedDate);
    });
  }

  /// Saves the user retyping details we already know from their account.
  void _prefillFromAccount() {
    final auth = ref.read(authProvider);
    final fullName = (auth.user?.name ?? '').trim();
    if (fullName.isNotEmpty) {
      final space = fullName.indexOf(' ');
      _firstNameController.text = space == -1
          ? fullName
          : fullName.substring(0, space);
      _lastNameController.text = space == -1
          ? ''
          : fullName.substring(space + 1).trim();
    }
    final mobile = auth.user?.mobileNumber ?? '';
    if (RegExp(r'^\d{10}$').hasMatch(mobile)) _mobileController.text = mobile;
    _emailController.text = auth.email ?? '';
  }

  // --- Validators ---------------------------------------------

  String? _validateName(String? v, {required bool isFirst}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) {
      return isFirst
          ? context.tr('Enter first name')
          : context.tr('Enter last name');
    }
    if (value.length < 2 || !_namePattern.hasMatch(value)) {
      return isFirst
          ? context.tr('Enter a valid first name (letters only)')
          : context.tr('Enter a valid last name (letters only)');
    }
    return null;
  }

  String? _validateMobile(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return context.tr('Enter mobile number');
    if (value.length != 10) {
      return context.tr('Mobile number must be 10 digits');
    }
    if (!RegExp(r'^[6-9]').hasMatch(value)) {
      return context.tr('Mobile number must start with 6, 7, 8 or 9');
    }
    return null;
  }

  /// Email is optional, but if given it must look like an email address.
  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return null;
    return _emailPattern.hasMatch(value)
        ? null
        : context.tr('Enter a valid email address');
  }

  String? _validateAddress(String? v, {required bool isPermanent}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) {
      return isPermanent
          ? context.tr('Enter permanent address')
          : context.tr('Enter temporary address');
    }
    if (value.length < 10) {
      return context.tr('Address looks too short - add street, city and PIN');
    }
    return null;
  }

  String? _validateTemporaryAddress(String? v) {
    final sameAsPermanent = ref
        .read(applyLoanProvider(widget.productId))
        .sameAsPermanent;
    return sameAsPermanent ? null : _validateAddress(v, isPermanent: false);
  }

  String? _validateLoanType() {
    final productId = ref.read(applyLoanProvider(widget.productId)).productId;
    return productId == null ? context.tr('Please select a loan type') : null;
  }

  String _selectedProductTitle() {
    final productId = ref.read(applyLoanProvider(widget.productId)).productId;
    final products =
        ref.read(financingSolutionsProvider).asData?.value.products ?? const [];
    for (final product in products) {
      if (product.id == productId) return product.title;
    }
    return 'Loan';
  }

  /// Shows the first error in a snackbar and scrolls its field into view.
  /// Needed because the form is longer than the screen, so inline errors
  /// can be off-screen when the user taps Submit.
  void _revealFirstError() {
    final checks = <(GlobalKey, String? Function())>[
      (
        _firstNameKey,
        () => _validateName(_firstNameController.text, isFirst: true),
      ),
      (
        _lastNameKey,
        () => _validateName(_lastNameController.text, isFirst: false),
      ),
      (_mobileKey, () => _validateMobile(_mobileController.text)),
      (_emailKey, () => _validateEmail(_emailController.text)),
      (_loanTypeKey, _validateLoanType),
      (
        _permanentAddressKey,
        () => _validateAddress(
          _permanentAddressController.text,
          isPermanent: true,
        ),
      ),
      (
        _temporaryAddressKey,
        () => _validateTemporaryAddress(_temporaryAddressController.text),
      ),
    ];

    for (final (key, check) in checks) {
      final message = check();
      if (message == null) continue;
      AppSnackbar.showError(context, message);
      final fieldContext = key.currentContext;
      if (fieldContext != null) {
        Scrollable.ensureVisible(
          fieldContext,
          alignment: 0.1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      return;
    }
  }

  void _onSameAsPermanentChanged(bool? value) {
    final isSame = value ?? false;
    ref
        .read(applyLoanProvider(widget.productId).notifier)
        .setSameAsPermanent(isSame);
    if (isSame) {
      _temporaryAddressController.text = _permanentAddressController.text;
    }
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _revealFirstError();
      return;
    }

    final provider = applyLoanProvider(widget.productId);
    final formState = ref.read(provider);
    final application = LoanApplicationModel(
      productId: formState.productId!,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobile: _mobileController.text.trim(),
      permanentAddress: _permanentAddressController.text.trim(),
      temporaryAddress: formState.sameAsPermanent
          ? _permanentAddressController.text.trim()
          : _temporaryAddressController.text.trim(),
      email: _emailController.text.trim(),
      income: double.tryParse(_incomeController.text.trim()),
      loanNeededDate: _loanNeededDate,
    );

    try {
      final applicationNumber = await ref
          .read(provider.notifier)
          .submit(application);
      if (!mounted) return;
      AppSnackbar.showSuccess(
        context,
        context.tr(
          '{loanType} application {number} submitted.',
          args: {
            'loanType': context.tr(_selectedProductTitle()),
            'number': applicationNumber,
          },
        ),
      );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          context.tr('Submission failed: {error}', args: {'error': e}),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = applyLoanProvider(widget.productId);
    final formState = ref.watch(provider);
    final productsAsync = ref.watch(financingSolutionsProvider);
    final products = productsAsync.asData?.value.products ?? const [];
    String? selectedTitle;
    for (final product in products) {
      if (product.id == formState.productId) selectedTitle = product.title;
    }
    final isSubmitting = formState.status == ApplyLoanStatus.submitting;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Bar Navigation ──────────────────────────────────
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.onSurface,
                    onPressed: isSubmitting
                        ? null
                        : () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                  ),
                  appSpace(context, width: 4),
                  Expanded(
                    child: Text(
                      context.tr('Apply for Loan'),
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Form ────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedTitle != null
                            ? context.tr(selectedTitle)
                            : context.tr('Loan Application'),
                        style: AppTypography.headlineLgMobile.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      appSpace(context, height: 4),
                      Text(
                        context.tr(
                          'Tell us a little about yourself and our team will take it from here.',
                        ),
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      appSpace(context, height: 20),

                      // First & last name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              key: _firstNameKey,
                              label: context.tr('First Name'),
                              controller: _firstNameController,
                              hint: 'Rajesh',
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: (v) => _validateName(v, isFirst: true),
                            ),
                          ),
                          appSpace(context, width: 12),
                          Expanded(
                            child: AppTextField(
                              key: _lastNameKey,
                              label: context.tr('Last Name'),
                              controller: _lastNameController,
                              hint: 'Gowda',
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: (v) =>
                                  _validateName(v, isFirst: false),
                            ),
                          ),
                        ],
                      ),
                      appSpace(context, height: 16),

                      // Mobile number
                      AppTextField(
                        key: _mobileKey,
                        label: context.tr('Mobile Number'),
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                            appSpace(context, width: 4),
                            Text(
                              '+91',
                              style: AppTypography.bodyMd.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: AppColors.outlineVariant,
                            ),
                          ],
                        ),
                        validator: _validateMobile,
                      ),
                      appSpace(context, height: 16),

                      // Email
                      AppTextField(
                        key: _emailKey,
                        label: context.tr('Email Address (optional)'),
                        controller: _emailController,
                        hint: 'name@company.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),
                      appSpace(context, height: 16),

                      // Optional income
                      AppTextField(
                        label: context.tr('Income (optional)'),
                        controller: _incomeController,
                        hint: context.tr('Enter income amount'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        prefix: Text(
                          '₹',
                          style: AppTypography.bodyMd.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      appSpace(context, height: 16),

                      // Optional date by which the loan is needed
                      AppTextField(
                        label: context.tr('Loan Needed Date (optional)'),
                        controller: _loanNeededDateController,
                        hint: context.tr('Select a date'),
                        readOnly: true,
                        onTap: isSubmitting ? null : _selectLoanNeededDate,
                        suffix: const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: AppColors.outline,
                        ),
                      ),
                      appSpace(context, height: 16),

                      // Loan type — pre-selected from the tapped card
                      productsAsync.when(
                        loading: () =>
                            const AppShimmer(child: SkeletonBox(height: 58)),
                        error: (error, _) => OutlinedButton.icon(
                          onPressed: () =>
                              ref.invalidate(financingSolutionsProvider),
                          icon: const Icon(Icons.refresh),
                          label: Text(error.toString()),
                        ),
                        data: (catalog) {
                          final validValue =
                              catalog.products.any(
                                (product) => product.id == formState.productId,
                              )
                              ? formState.productId
                              : null;
                          return LoanTypeField(
                            key: _loanTypeKey,
                            initialValue: validValue,
                            products: catalog.products,
                            enabled: !isSubmitting,
                            onChanged: (value) =>
                                ref.read(provider.notifier).setProductId(value),
                          );
                        },
                      ),
                      // Permanent address
                      appSpace(context, height: 8),
                      AppTextField(
                        key: _permanentAddressKey,
                        label: context.tr('Permanent Address'),
                        controller: _permanentAddressController,
                        hint: context.tr(
                          'House / flat no., street, city, state, PIN',
                        ),
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        onChanged: (value) {
                          if (formState.sameAsPermanent) {
                            _temporaryAddressController.text = value;
                          }
                        },
                        validator: (v) =>
                            _validateAddress(v, isPermanent: true),
                      ),
                      appSpace(context, height: 16),

                      // Temporary address
                      AppTextField(
                        key: _temporaryAddressKey,
                        label: context.tr('Temporary Address'),
                        controller: _temporaryAddressController,
                        hint: context.tr('Where you currently stay'),
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        enabled: !formState.sameAsPermanent,
                        validator: _validateTemporaryAddress,
                      ),
                      appSpace(context, height: 8),
                      InkWell(
                        onTap: () => _onSameAsPermanentChanged(
                          !formState.sameAsPermanent,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: formState.sameAsPermanent,
                                  activeColor: AppColors.primaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  onChanged: _onSameAsPermanentChanged,
                                ),
                              ),
                              appSpace(context, width: 8),
                              Expanded(
                                child: Text(
                                  context.tr('Same as permanent address'),
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      appSpace(context, height: 28),

                      AppButton(
                        text: context.tr('Submit Application'),
                        icon: Icons.arrow_forward,
                        isLoading: isSubmitting,
                        onPressed: _handleSubmit,
                      ),
                      appSpace(context, height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
