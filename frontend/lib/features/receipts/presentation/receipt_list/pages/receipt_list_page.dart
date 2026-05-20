import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/receipt_repository.dart';
import '../../upload_page/pages/upload_page.dart';
import '../bloc/receipt_list_bloc.dart';
import '../widgets/receipt_card.dart';

class ReceiptListPage extends StatelessWidget {
  const ReceiptListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReceiptListBloc(repository: context.read<ReceiptRepository>())
            ..add(const ReceiptListLoaded()),
      child: const _ReceiptListView(),
    );
  }
}

class _ReceiptListView extends StatelessWidget {
  const _ReceiptListView();

  void _openUploadDialog(BuildContext context) {
    final bloc = context.read<ReceiptListBloc>();
    showDialog(
      context: context,
      builder: (_) =>
          UploadPage(onSuccess: () => bloc.add(const ReceiptListRefreshed())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RIS', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => _openUploadDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Upload Receipt'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ReceiptListBloc, ReceiptListState>(
        builder: (context, state) {
          if (state is ReceiptListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReceiptListFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<ReceiptListBloc>().add(
                      const ReceiptListLoaded(),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ReceiptListSuccess) {
            if (state.receipts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No receipts yet',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload your first receipt to get started',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: state.receipts.length,
              itemBuilder: (_, index) =>
                  ReceiptCard(receipt: state.receipts[index]),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
