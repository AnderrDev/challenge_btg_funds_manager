import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/fund.dart';

/// Reusable card widget displaying a fund's information.
///
/// Shows fund name, category, minimum amount, and subscription status.
/// Provides action buttons to subscribe or cancel.
class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.onSubscribe,
    required this.onCancel,
  });

  final Fund fund;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.goNamed(
          'fund_detail',
          pathParameters: {'id': fund.id.toString()},
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Category badge + Subscription indicator ──
              Row(
                children: [
                  _CategoryBadge(category: fund.category),
                  const Spacer(),
                  if (fund.isSubscribed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppTheme.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Vinculado',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Fund name ──
              Text(
                fund.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 8),

              // ── Minimum amount ──
              Row(
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Monto mínimo: ${formatCOP(fund.minimumAmount)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Action button ──
              SizedBox(
                width: double.infinity,
                child: fund.isSubscribed
                    ? OutlinedButton.icon(
                        onPressed: onCancel,
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancelar suscripción'),
                      )
                    : ElevatedButton.icon(
                        onPressed: onSubscribe,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Suscribirse'),
                      ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Ver detalles',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge widget showing the fund category (FPV or FIC).
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final FundCategory category;

  @override
  Widget build(BuildContext context) {
    final isFpv = category == FundCategory.fpv;
    final color = isFpv ? AppTheme.accent : AppTheme.warning;
    final label = isFpv ? 'FPV' : 'FIC';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
