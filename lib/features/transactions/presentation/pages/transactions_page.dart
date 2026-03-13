import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../bloc/transactions_state.dart';
import '../widgets/transaction_tile.dart';

/// Page displaying the transaction history.
///
/// Loads transactions on first build and supports pull-to-refresh.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de transacciones'),
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          return switch (state) {
            TransactionsInitial() => const _InitialView(),
            TransactionsLoading() => const _LoadingView(),
            TransactionsLoaded(:final transactions) => transactions.isEmpty
                ? const _EmptyView()
                : _LoadedView(transactions: transactions),
            TransactionsError(:final message) => _ErrorView(message: message),
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
      context.read<TransactionsBloc>().add(const LoadTransactions());
    });
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando transacciones...'),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Sin transacciones',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Las suscripciones y cancelaciones\naparecerán aquí.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<TransactionsBloc>().add(const LoadTransactions());
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
  const _LoadedView({required this.transactions});

  final List transactions;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TransactionsBloc>().add(const LoadTransactions());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: transactions.length,
        itemBuilder: (context, index) => TransactionTile(
          transaction: transactions[index],
        ),
      ),
    );
  }
}
