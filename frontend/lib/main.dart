import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'features/receipts/data/datasource/receipt_remote_datasource.dart';
import 'features/receipts/data/repositories/receipt_repository_impl.dart';
import 'features/receipts/domain/repositories/receipt_repository.dart';
import 'router.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const RisApp());
}

class RisApp extends StatelessWidget {
  const RisApp({super.key});

  @override
  Widget build(BuildContext context) {
    final datasource = ReceiptRemoteDatasource(ApiClient.instance);
    final repository = ReceiptRepositoryImpl(datasource);

    return RepositoryProvider<ReceiptRepository>(
      create: (_) => repository,
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Receipt Intelligence System',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2E7D32),
              ),
              useMaterial3: true,
            ),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('[bloc] ${bloc.runtimeType}: ${transition.event.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('[bloc:error] ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}
