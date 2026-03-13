import '../../domain/entities/fund.dart';

/// Data model for [Fund] with JSON serialization.
///
/// Implements the Adapter pattern by separating API logic from domain.
class FundModel extends Fund {
  const FundModel({
    required super.id,
    required super.name,
    required super.minimumAmount,
    required super.category,
    super.isSubscribed,
    super.description,
    super.managedBy,
    super.returns,
    super.riskLevel,
    super.currency,
    super.createdAt,
  });

  /// Creates a [FundModel] from a domain [Fund].
  factory FundModel.fromEntity(Fund fund) {
    return FundModel(
      id: fund.id,
      name: fund.name,
      minimumAmount: fund.minimumAmount,
      category: fund.category,
      isSubscribed: fund.isSubscribed,
      description: fund.description,
      managedBy: fund.managedBy,
      returns: fund.returns,
      riskLevel: fund.riskLevel,
      currency: fund.currency,
      createdAt: fund.createdAt,
    );
  }

  /// Creates a [FundModel] from a JSON map.
  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'] as int,
      name: json['name'] as String,
      minimumAmount: (json['minimumAmount'] as num).toDouble(),
      category: _categoryFromString(json['category'] as String),
      isSubscribed: json['isSubscribed'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      managedBy: json['managedBy'] as String? ?? '',
      returns: (json['returns'] as num?)?.toDouble() ?? 0.0,
      riskLevel: _riskLevelFromString(json['riskLevel'] as String?),
      currency: json['currency'] as String? ?? 'COP',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  /// Converts this [FundModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minimumAmount': minimumAmount,
      'category': category == FundCategory.fpv ? 'fpv' : 'fic',
      'isSubscribed': isSubscribed,
      'description': description,
      'managedBy': managedBy,
      'returns': returns,
      'riskLevel': riskLevel.name,
      'currency': currency,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  static FundCategory _categoryFromString(String value) {
    return value == 'fpv' ? FundCategory.fpv : FundCategory.fic;
  }

  static RiskLevel _riskLevelFromString(String? value) {
    switch (value) {
      case 'low':
        return RiskLevel.low;
      case 'high':
        return RiskLevel.high;
      default:
        return RiskLevel.moderate;
    }
  }
}
