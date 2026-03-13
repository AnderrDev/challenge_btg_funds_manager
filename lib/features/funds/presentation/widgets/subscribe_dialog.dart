import 'package:flutter/material.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../../core/theme/app_theme.dart';

/// Dialog for selecting a notification method when subscribing to a fund.
///
/// Presents Email and SMS options. Returns the selected [NotificationMethod]
/// or `null` if the user dismisses the dialog.
class SubscribeDialog extends StatefulWidget {
  const SubscribeDialog({
    super.key,
    required this.fundName,
  });

  final String fundName;

  /// Shows the dialog and returns the selected notification method.
  static Future<NotificationMethod?> show(
    BuildContext context, {
    required String fundName,
  }) {
    return showDialog<NotificationMethod>(
      context: context,
      builder: (_) => SubscribeDialog(fundName: fundName),
    );
  }

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  NotificationMethod? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Confirmar suscripción',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Desea suscribirse al fondo ${widget.fundName}?',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Seleccione método de notificación:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _NotificationOption(
            icon: Icons.email_outlined,
            label: 'Email',
            isSelected: _selectedMethod == NotificationMethod.email,
            onTap: () => setState(() {
              _selectedMethod = NotificationMethod.email;
            }),
          ),
          const SizedBox(height: 8),
          _NotificationOption(
            icon: Icons.sms_outlined,
            label: 'SMS',
            isSelected: _selectedMethod == NotificationMethod.sms,
            onTap: () => setState(() {
              _selectedMethod = NotificationMethod.sms;
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        ElevatedButton(
          onPressed: _selectedMethod == null
              ? null
              : () => Navigator.of(context).pop(_selectedMethod),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}

/// Selectable notification method option widget.
class _NotificationOption extends StatelessWidget {
  const _NotificationOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.08)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color:
                        isSelected ? AppTheme.primary : Colors.grey.shade700,
                  ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
