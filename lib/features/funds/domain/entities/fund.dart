import 'package:equatable/equatable.dart';

/// Fund category types.
enum FundCategory { fpv, fic }

/// Risk level for a fund.
enum RiskLevel { low, moderate, high }

/// Represents an investment fund entity with full details.
///
/// Immutable value object — equality is based on [id].
/// Uses [Equatable] for value-based comparison.
class Fund extends Equatable {
  const Fund({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    this.isSubscribed = false,
    this.description = '',
    this.managedBy = '',
    this.returns = 0.0,
    this.riskLevel = RiskLevel.moderate,
    this.currency = 'COP',
    this.createdAt,
  });

  final int id;
  final String name;
  final double minimumAmount;
  final FundCategory category;
  final bool isSubscribed;
  final String description;
  final String managedBy;
  final double returns;
  final RiskLevel riskLevel;
  final String currency;
  final DateTime? createdAt;

  /// Creates a [Fund] from a JSON map (API response).
  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
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

  /// Converts this [Fund] to a JSON map.
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

  /// Creates a copy with the given fields replaced.
  Fund copyWith({
    int? id,
    String? name,
    double? minimumAmount,
    FundCategory? category,
    bool? isSubscribed,
    String? description,
    String? managedBy,
    double? returns,
    RiskLevel? riskLevel,
    String? currency,
    DateTime? createdAt,
  }) {
    return Fund(
      id: id ?? this.id,
      name: name ?? this.name,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      category: category ?? this.category,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      description: description ?? this.description,
      managedBy: managedBy ?? this.managedBy,
      returns: returns ?? this.returns,
      riskLevel: riskLevel ?? this.riskLevel,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        minimumAmount,
        category,
        isSubscribed,
        description,
        managedBy,
        returns,
        riskLevel,
        currency,
        createdAt,
      ];

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
