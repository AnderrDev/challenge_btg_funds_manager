import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/funds/presentation/pages/funds_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';

/// Application router configuration using GoRouter.
///
/// Defines declarative routes for the funds management app.
/// Uses shell route with bottom navigation for main sections.
final GoRouter appRouter = GoRouter(
  initialLocation: '/funds',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(
          path: '/funds',
          name: 'funds',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FundsPage(),
          ),
        ),
        GoRoute(
          path: '/transactions',
          name: 'transactions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TransactionsPage(),
          ),
        ),
      ],
    ),
  ],
);

/// Shell widget that provides bottom navigation between sections.
class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Fondos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Historial',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/transactions')) return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('funds');
      case 1:
        context.goNamed('transactions');
    }
  }
}
