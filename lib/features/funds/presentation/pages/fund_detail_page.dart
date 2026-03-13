import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/fund.dart';
import '../bloc/fund_detail_bloc.dart';
import '../bloc/fund_detail_event.dart';
import '../bloc/fund_detail_state.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../widgets/subscribe_dialog.dart';

/// Screen displaying complete details for a specific fund.
class FundDetailPage extends StatelessWidget {
  const FundDetailPage({
    super.key,
    required this.fundId,
  });

  final int fundId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FundDetailBloc>()..add(LoadFundDetail(fundId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del Fondo'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<FundDetailBloc, FundDetailState>(
          builder: (context, state) {
            if (state is FundDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FundDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppTheme.error),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<FundDetailBloc>().add(LoadFundDetail(fundId)),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (state is FundDetailLoaded) {
              final fund = state.fund;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailHeader(fund: fund),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Sobre este fondo',
                      content: fund.description,
                    ),
                    const SizedBox(height: 24),
                    _DetailInfoGrid(fund: fund),
                    const SizedBox(height: 32),
                    _ActionSection(fund: fund),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.fund});
  final Fund fund;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFpv = fund.category == FundCategory.fpv;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: (isFpv ? AppTheme.accent : AppTheme.warning).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isFpv ? 'FPV' : 'FIC',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isFpv ? AppTheme.accent : AppTheme.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getRiskColor(fund.riskLevel).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Riesgo ${_getRiskLabel(fund.riskLevel)}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _getRiskColor(fund.riskLevel),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          fund.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Administrado por ${fund.managedBy}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low: return AppTheme.success;
      case RiskLevel.moderate: return AppTheme.warning;
      case RiskLevel.high: return AppTheme.error;
    }
  }

  String _getRiskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.low: return 'Bajo';
      case RiskLevel.moderate: return 'Moderado';
      case RiskLevel.high: return 'Alto';
    }
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.grey.shade800),
        ),
      ],
    );
  }
}

class _DetailInfoGrid extends StatelessWidget {
  const _DetailInfoGrid({required this.fund});
  final Fund fund;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _InfoTile(
          label: 'Monto Mínimo',
          value: formatCOP(fund.minimumAmount),
          icon: Icons.monetization_on_outlined,
        ),
        _InfoTile(
          label: 'Rentabilidad Anual',
          value: '${fund.returns}%',
          icon: Icons.trending_up,
          valueColor: AppTheme.success,
        ),
        _InfoTile(
          label: 'Moneda',
          value: fund.currency,
          icon: Icons.language,
        ),
        _InfoTile(
          label: 'Fecha Creación',
          value: fund.createdAt != null ? '${fund.createdAt!.day}/${fund.createdAt!.month}/${fund.createdAt!.year}' : 'N/A',
          icon: Icons.calendar_today_outlined,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade600)),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({required this.fund});
  final Fund fund;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: fund.isSubscribed
          ? OutlinedButton.icon(
              onPressed: () {
                context.read<FundsBloc>().add(
                  CancelFundSubscription(
                    fundId: fund.id,
                    fundName: fund.name,
                    fundMinimumAmount: fund.minimumAmount,
                  ),
                );
                context.pop();
              },
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('CANCELAR SUSCRIPCIÓN'),
            )
          : ElevatedButton.icon(
              onPressed: () async {
                final method = await SubscribeDialog.show(context, fundName: fund.name);
                if (method != null && context.mounted) {
                  context.read<FundsBloc>().add(
                    SubscribeToFundEvent(
                      fundId: fund.id,
                      fundName: fund.name,
                      fundMinimumAmount: fund.minimumAmount,
                      notificationMethod: method,
                    ),
                  );
                  context.pop();
                }
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('SUSCRIBIRSE AHORA'),
            ),
    );
  }
}
