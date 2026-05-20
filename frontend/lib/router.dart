import 'package:go_router/go_router.dart';

import 'features/receipts/presentation/receipt_list/pages/receipt_list_page.dart';
import 'features/receipts/presentation/receipt_detail/pages/receipt_detail_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const ReceiptListPage()),
      GoRoute(
        path: '/receipts/:id',
        builder: (context, state) =>
            ReceiptDetailPage(receiptId: state.pathParameters['id']!),
      ),
    ],
  );
}
