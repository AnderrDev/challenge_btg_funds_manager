import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../bloc/funds_state.dart';
import '../widgets/fund_card.dart';
import '../widgets/fund_card_skeleton.dart';
import '../widgets/subscribe_dialog.dart';
import '../../../../core/widgets/skeleton.dart';

/// Main page displaying available funds and current balance.
///
/// Uses [BlocBuilder] to rebuild on state changes and
/// [BlocListener] for showing snackbar feedback.
class FundsPage extends StatelessWidget {
  const FundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BTG Funds Manager'),
      ),
      body: BlocConsumer<FundsBloc, FundsState>(
        listener: (context, state) {
          if (state is FundsError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: AppTheme.error,
                  duration: const Duration(seconds: 4),
                ),
              );
          }
        },
        builder: (context, state) {
          return switch (state) {
            FundsInitial() => const _InitialView(),
            FundsLoading() => const _LoadingView(),
            FundsLoaded(:final funds, :final balance) =>
              _LoadedView(funds: funds, balance: balance),
            FundsError() => const _ErrorView(),
          };
        },
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    // Trigger initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FundsBloc>().add(const LoadFunds());
    });
    return const _LoadingView();
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Balance skeleton
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Skeleton(
              height: 120,
              borderRadius: 20,
              width: double.infinity,
            ),
          ),
        ),
        // Section title skeleton
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Skeleton(width: 200, height: 28),
          ),
        ),
        // List skeleton
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: FundCardSkeleton(),
            ),
            childCount: 4,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.error),
          const SizedBox(height: 16),
          const Text('Error al cargar los fondos'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<FundsBloc>().add(const LoadFunds());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.funds,
    required this.balance,
  });

  final List funds;
  final double balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FundsBloc>().add(const LoadFunds());
      },
      child: CustomScrollView(
        slivers: [
          // ── Balance header ──
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo disponible',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCOP(balance),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Section title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Fondos disponibles',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // ── Fund cards list ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final fund = funds[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FundCard(
                    fund: fund,
                    onSubscribe: () async {
                      final method = await SubscribeDialog.show(
                        context,
                        fundName: fund.name,
                      );
                      if (method != null && context.mounted) {
                        context.read<FundsBloc>().add(
                              SubscribeToFundEvent(
                                fundId: fund.id,
                                fundName: fund.name,
                                fundMinimumAmount: fund.minimumAmount,
                                notificationMethod: method,
                              ),
                            );
                      }
                    },
                    onCancel: () {
                      context.read<FundsBloc>().add(
                            CancelFundSubscription(
                              fundId: fund.id,
                              fundName: fund.name,
                              fundMinimumAmount: fund.minimumAmount,
                            ),
                          );
                    },
                  ),
                );
              },
              childCount: funds.length,
            ),
          ),

          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }
}
