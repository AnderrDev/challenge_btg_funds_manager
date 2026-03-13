import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';
import 'package:intl/intl.dart';

/// Widget displaying a single transaction record.
///
/// Shows transaction type, fund name, amount, date, and notification method.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubscription = transaction.type == TransactionType.subscription;
    final typeColor = isSubscription ? AppTheme.success : AppTheme.error;
    final typeIcon = isSubscription
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    final typeLabel = isSubscription ? 'Suscripción' : 'Cancelación';
    final dateFormatted = DateFormat('dd/MM/yyyy HH:mm').format(transaction.date);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ── Type icon ──
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(typeIcon, color: typeColor, size: 24),
            ),

            const SizedBox(width: 14),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.fundName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          typeLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: typeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (transaction.notificationMethod != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          transaction.notificationMethod ==
                                  NotificationMethod.email
                              ? Icons.email_outlined
                              : Icons.sms_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormatted,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Amount ──
            Text(
              '${isSubscription ? '-' : '+'}${formatCOP(transaction.amount)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: typeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
