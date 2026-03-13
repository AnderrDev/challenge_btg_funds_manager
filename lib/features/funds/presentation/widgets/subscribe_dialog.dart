import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/btg_text_field.dart';
import '../../../transactions/domain/entities/transaction.dart';

/// Dialog for selecting a notification method and providing contact info when subscribing.
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
      barrierDismissible: false,
      builder: (_) => SubscribeDialog(fundName: fundName),
    );
  }

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  NotificationMethod? _selectedMethod;
  late final SharedPreferences _prefs;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = sl<SharedPreferences>();
    _emailController.text = _prefs.getString('last_email') ?? '';
    _phoneController.text = _prefs.getString('last_phone') ?? '';
    setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedMethod == NotificationMethod.email) {
        _prefs.setString('last_email', _emailController.text.trim());
      } else {
        _prefs.setString('last_phone', _phoneController.text.trim());
      }
      Navigator.of(context).pop(_selectedMethod);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese su email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese su teléfono';
    if (value.length < 10) return 'Mínimo 10 dígitos';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Confirmar suscripción',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppTheme.primary,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¿Desea suscribirse al fondo ${widget.fundName}?',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              Text(
                'Notificar por:',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _NotificationOption(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      isSelected: _selectedMethod == NotificationMethod.email,
                      onTap: () => setState(() {
                        _selectedMethod = NotificationMethod.email;
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _NotificationOption(
                      icon: Icons.sms_outlined,
                      label: 'SMS',
                      isSelected: _selectedMethod == NotificationMethod.sms,
                      onTap: () => setState(() {
                        _selectedMethod = NotificationMethod.sms;
                      }),
                    ),
                  ),
                ],
              ),
              if (_selectedMethod != null) ...[
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedMethod == NotificationMethod.email
                      ? BTGTextField(
                          key: const ValueKey('email_field'),
                          controller: _emailController,
                          label: 'Correo electrónico',
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          autofillHints: const [AutofillHints.email],
                        )
                      : BTGTextField(
                          key: const ValueKey('phone_field'),
                          controller: _phoneController,
                          label: 'Número de celular',
                          icon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade600)),
        ),
        ElevatedButton(
          onPressed: _selectedMethod == null ? null : _onConfirm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Completar'),
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
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color:
                        isSelected ? AppTheme.primary : Colors.grey.shade700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
