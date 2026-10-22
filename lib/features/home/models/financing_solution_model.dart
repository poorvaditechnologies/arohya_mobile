class FinancingSolutionModel {
  final String id;
  final String slug;
  final String title;
  final String amountLabel;
  final String badgeText;
  final String badgeTone;
  final String rateLabel;
  final String? iconUrl;
  final String fallbackIconKey;
  final int sortOrder;
  final bool visibleInitially;
  final bool applicationEnabled;
  final String category;
  final bool active;

  const FinancingSolutionModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.amountLabel,
    required this.badgeText,
    required this.badgeTone,
    required this.rateLabel,
    this.iconUrl,
    required this.fallbackIconKey,
    required this.sortOrder,
    required this.visibleInitially,
    required this.applicationEnabled,
    required this.category,
    required this.active,
  });

  factory FinancingSolutionModel.fromJson(Map<String, dynamic> json) {
    return FinancingSolutionModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      amountLabel: json['amountLabel'] as String? ?? '',
      badgeText: json['badgeText'] as String? ?? '',
      badgeTone: json['badgeTone'] as String? ?? 'neutral',
      rateLabel: json['rateLabel'] as String? ?? '',
      iconUrl: json['iconUrl'] as String?,
      fallbackIconKey: json['fallbackIconKey'] as String? ?? 'generic',
      sortOrder: json['sortOrder'] as int? ?? 0,
      visibleInitially: json['visibleInitially'] as bool? ?? false,
      applicationEnabled: json['applicationEnabled'] as bool? ?? false,
      category: json['category'] as String? ?? 'loan',
      active: json['active'] as bool? ?? true,
    );
  }
}

class FinancingSolutionsCatalog {
  final int initialVisibleCount;
  final List<FinancingSolutionModel> products;

  const FinancingSolutionsCatalog({
    required this.initialVisibleCount,
    required this.products,
  });

  factory FinancingSolutionsCatalog.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'];
    final products = rawProducts is List
        ? rawProducts
              .whereType<Map>()
              .map(
                (item) => FinancingSolutionModel.fromJson(
                  item.cast<String, dynamic>(),
                ),
              )
              .where((item) => item.active)
              .toList()
        : <FinancingSolutionModel>[];
    products.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return FinancingSolutionsCatalog(
      initialVisibleCount: json['initialVisibleCount'] as int? ?? 5,
      products: products,
    );
  }
}
