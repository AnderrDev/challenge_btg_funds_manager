import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/funds/presentation/bloc/funds_bloc.dart';
import 'features/transactions/presentation/bloc/transactions_bloc.dart';

/// Application root widget.
///
/// Sets up [MultiBlocProvider] for global BLoC access and
/// configures [MaterialApp.router] with GoRouter and BTG theme.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FundsBloc>(create: (_) => sl<FundsBloc>()),
        BlocProvider<TransactionsBloc>(create: (_) => sl<TransactionsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'BTG Funds Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
