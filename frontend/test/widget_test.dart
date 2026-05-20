import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/receipts/presentation/receipt_list/widgets/status_badge.dart';
import 'package:frontend/features/receipts/presentation/receipt_list/widgets/receipt_card.dart';
import 'package:frontend/features/receipts/domain/entities/receipt.dart';

void main() {
  group('StatusBadge', () {
    testWidgets('shows Done label with green background for DONE status', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: 'DONE')),
        ),
      );

      expect(find.text('Done'), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF2E7D32));
    });

    testWidgets('shows Failed label with red background for FAILED status', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: 'FAILED')),
        ),
      );

      expect(find.text('Failed'), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFB71C1C));
    });

    testWidgets('shows Pending label with grey background for PENDING status', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: 'PENDING')),
        ),
      );

      expect(find.text('Pending'), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFE0E0E0));
    });
  });

  group('ReceiptCard', () {
    // Minimal router needed because ReceiptCard uses context.push
    Widget buildWithRouter(Receipt receipt) {
      return MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => Scaffold(body: ReceiptCard(receipt: receipt)),
            ),
            GoRoute(
              path: '/receipts/:id',
              builder: (_, __) => const Scaffold(body: Text('Detail')),
            ),
          ],
        ),
      );
    }

    testWidgets('shows vendor name and date when status is DONE', (
      tester,
    ) async {
      const receipt = Receipt(
        id: 'test-1',
        imageUrl: '/uploads/test.jpg',
        status: 'DONE',
        currency: 'EUR',
        createdAt: '2026-05-20T10:00:00.000Z',
        vendorName: 'REWE',
        date: '20.05.2026',
        totalAmount: 12.99,
      );

      await tester.pumpWidget(buildWithRouter(receipt));
      await tester.pumpAndSettle();

      expect(find.text('REWE'), findsOneWidget);
      expect(find.text('20.05.2026'), findsOneWidget);
      expect(find.text('12.99 €'), findsOneWidget);
    });

    testWidgets('shows Processing... and extracting text when PENDING', (
      tester,
    ) async {
      const receipt = Receipt(
        id: 'test-2',
        imageUrl: '/uploads/test.jpg',
        status: 'PENDING',
        currency: 'EUR',
        createdAt: '2026-05-20T10:00:00.000Z',
      );

      await tester.pumpWidget(buildWithRouter(receipt));
      await tester.pumpAndSettle();

      expect(find.text('Processing...'), findsOneWidget);
      expect(find.text('Extracting receipt data...'), findsOneWidget);
    });

    testWidgets('shows Unknown vendor when DONE but vendorName is null', (
      tester,
    ) async {
      const receipt = Receipt(
        id: 'test-3',
        imageUrl: '/uploads/test.jpg',
        status: 'DONE',
        currency: 'EUR',
        createdAt: '2026-05-20T10:00:00.000Z',
        totalAmount: 5.50,
      );

      await tester.pumpWidget(buildWithRouter(receipt));
      await tester.pumpAndSettle();

      expect(find.text('Unknown vendor'), findsOneWidget);
    });

    testWidgets('shows StatusBadge with correct status', (tester) async {
      const receipt = Receipt(
        id: 'test-4',
        imageUrl: '/uploads/test.jpg',
        status: 'FAILED',
        currency: 'EUR',
        createdAt: '2026-05-20T10:00:00.000Z',
      );

      await tester.pumpWidget(buildWithRouter(receipt));
      await tester.pumpAndSettle();

      expect(find.text('Failed'), findsOneWidget);
    });
  });
}
