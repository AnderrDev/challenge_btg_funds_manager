import 'package:intl/intl.dart';

/// Formats a [double] amount as Colombian Pesos (COP).
///
/// Example: `formatCOP(75000)` returns `'COP \$75.000'`.
/// This is a pure function with no side effects.
String formatCOP(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: 'COP',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}
