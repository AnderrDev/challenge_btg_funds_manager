import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/btg_error_view.dart';
import '../../../../core/widgets/btg_section_title.dart';
import '../../domain/entities/fund.dart';
import '../bloc/fund_detail_bloc.dart';
import '../bloc/fund_detail_event.dart';
import '../bloc/fund_detail_state.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../widgets/subscribe_dialog.dart';
import '../widgets/fund_detail_skeleton.dart';

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
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<FundDetailBloc, FundDetailState>(
          builder: (context, state) {
            if (state is FundDetailLoading) {
              return const FundDetailSkeleton();
            }

            if (state is FundDetailError) {
              return BTGErrorView(
                message: state.message,
                onRetry: () => context.read<FundDetailBloc>().add(LoadFundDetail(fundId)),
              );
            }

            if (state is FundDetailLoaded) {
              final fund = state.fund;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _DetailHeader(fund: fund),
                    ),
                    const BTGSectionTitle(title: 'Sobre este fondo', padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        fund.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              color: Colors.grey.shade700,
                            ),
                      ),
                    ),
                    const BTGSectionTitle(title: 'Información clave', padding: EdgeInsets.fromLTRB(20, 24, 20, 12)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _DetailInfoGrid(fund: fund),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _ActionSection(fund: fund),
                    ),
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
            _Tag(
              label: isFpv ? 'FPV' : 'FIC',
              color: isFpv ? AppTheme.accent : AppTheme.warning,
            ),
            const SizedBox(width: 8),
            _Tag(
              label: 'Riesgo ${_getRiskLabel(fund.riskLevel)}',
              color: _getRiskColor(fund.riskLevel),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          fund.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppTheme.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.business_rounded, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              'Administrado por ${fund.managedBy}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
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

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
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
      childAspectRatio: 2.2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      children: [
        _InfoTile(
          label: 'Monto Mínimo',
          value: formatCOP(fund.minimumAmount),
          icon: Icons.monetization_on_outlined,
        ),
        _InfoTile(
          label: 'Rentabilidad Anual',
          value: '${fund.returns}%',
          icon: Icons.trending_up_rounded,
          valueColor: AppTheme.success,
        ),
        _InfoTile(
          label: 'Moneda',
          value: fund.currency,
          icon: Icons.language_rounded,
        ),
        _InfoTile(
          label: 'Fecha Creación',
          value: fund.createdAt != null ? '${fund.createdAt!.day}/${fund.createdAt!.month}/${fund.createdAt!.year}' : 'N/A',
          icon: Icons.calendar_today_rounded,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppTheme.primary,
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
      height: 56,
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
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.error),
                foregroundColor: AppTheme.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
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
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
    );
  }
}
