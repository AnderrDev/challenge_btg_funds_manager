import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/btg_empty_state.dart';
import '../../../../core/widgets/btg_error_view.dart';
import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../bloc/transactions_state.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/transaction_tile_skeleton.dart';

/// Page displaying the transaction history.
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionsBloc>().add(const LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de transacciones'),
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          return switch (state) {
            TransactionsInitial() || TransactionsLoading() => const _LoadingView(),
            TransactionsLoaded(:final transactions) => transactions.isEmpty
                ? const BTGEmptyState(
                    title: 'Sin transacciones',
                    message: 'Las suscripciones y cancelaciones aparecerán aquí.',
                    icon: Icons.history_rounded,
                  )
                : _LoadedView(transactions: transactions),
            TransactionsError(:final message) => BTGErrorView(
                message: message,
                onRetry: () => context.read<TransactionsBloc>().add(const LoadTransactions()),
              ),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 8,
      itemBuilder: (context, index) => const TransactionTileSkeleton(),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TransactionsBloc>().add(const LoadTransactions());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        itemCount: transactions.length,
        itemBuilder: (context, index) => TransactionTile(
          transaction: transactions[index],
        ),
      ),
    );
  }
}
