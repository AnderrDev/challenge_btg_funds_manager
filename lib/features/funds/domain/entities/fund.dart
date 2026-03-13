import 'package:equatable/equatable.dart';

/// Fund category types.
enum FundCategory { fpv, fic }

/// Represents an investment fund entity.
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
  });

  final int id;
  final String name;
  final double minimumAmount;
  final FundCategory category;
  final bool isSubscribed;

  /// Creates a copy with the given fields replaced.
  Fund copyWith({
    int? id,
    String? name,
    double? minimumAmount,
    FundCategory? category,
    bool? isSubscribed,
  }) {
    return Fund(
      id: id ?? this.id,
      name: name ?? this.name,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      category: category ?? this.category,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  @override
  List<Object?> get props => [id, name, minimumAmount, category, isSubscribed];
}
