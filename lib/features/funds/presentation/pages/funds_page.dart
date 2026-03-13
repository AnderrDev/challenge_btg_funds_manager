import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../bloc/funds_state.dart';
import '../../../../core/widgets/btg_error_view.dart';
import '../../../../core/widgets/btg_section_title.dart';
import '../widgets/balance_header.dart';
import '../widgets/fund_card.dart';
import '../widgets/fund_card_skeleton.dart';
import '../widgets/subscribe_dialog.dart';
import '../../../../core/widgets/skeleton.dart';

/// Main page displaying available funds and current balance.
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
                      const Icon(Icons.error_outline_rounded, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            FundsError(:final message) => BTGErrorView(
                message: message,
                onRetry: () => context.read<FundsBloc>().add(const LoadFunds()),
              ),
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
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Skeleton(height: 124, borderRadius: 24),
          ),
        ),
        const SliverToBoxAdapter(
          child: BTGSectionTitle(title: 'Fondos disponibles'),
        ),
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

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.funds,
    required this.balance,
  });

  final List funds;
  final double balance;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FundsBloc>().add(const LoadFunds());
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BalanceHeader(balance: balance),
          ),
          const SliverToBoxAdapter(
            child: BTGSectionTitle(title: 'Fondos disponibles'),
          ),
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
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}
