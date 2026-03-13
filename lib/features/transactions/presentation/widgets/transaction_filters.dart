import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../../domain/entities/transaction.dart';

class TransactionFilters extends StatefulWidget {
  const TransactionFilters({
    super.key,
    required this.query,
    required this.selectedType,
  });

  final String? query;
  final TransactionType? selectedType;

  @override
  State<TransactionFilters> createState() => _TransactionFiltersState();
}

class _TransactionFiltersState extends State<TransactionFilters> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre de fondo...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              context.read<TransactionsBloc>().add(FilterTransactions(query: value));
            },
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Suscripciones',
                  selected: widget.selectedType == TransactionType.subscription,
                  onSelected: (_) {
                    context.read<TransactionsBloc>().add(
                          const FilterTransactions(type: TransactionType.subscription),
                        );
                  },
                  color: AppTheme.success,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Cancelaciones',
                  selected: widget.selectedType == TransactionType.cancellation,
                  onSelected: (_) {
                    context.read<TransactionsBloc>().add(
                          const FilterTransactions(type: TransactionType.cancellation),
                        );
                  },
                  color: AppTheme.error,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.color,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : color,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: color,
      checkmarkColor: Colors.white,
      backgroundColor: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
    );
  }
}
