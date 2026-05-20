import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_client.dart';
import '../../../domain/entities/receipt.dart';
import '../../../domain/repositories/receipt_repository.dart';
import '../../receipt_list/widgets/status_badge.dart';
import '../bloc/receipt_detail_bloc.dart';
import '../widgets/line_item_row.dart';

class ReceiptDetailPage extends StatelessWidget {
  const ReceiptDetailPage({super.key, required this.receiptId});

  final String receiptId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReceiptDetailBloc(repository: context.read<ReceiptRepository>())
            ..add(ReceiptDetailLoaded(id: receiptId)),
      child: Scaffold(
        body: BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
          builder: (context, state) {
            if (state is ReceiptDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReceiptDetailFailure) {
              return Center(child: Text(state.message));
            }
            if (state is ReceiptDetailSuccess) {
              return _DetailContent(receipt: state.receipt);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Back'),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          floating: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ImageCard(
                  imageUrl: receipt.imageUrl,
                  vendorName: receipt.vendorName,
                ),
                const SizedBox(height: 16),
                _DetailsCard(receipt: receipt),
                const SizedBox(height: 16),
                if (receipt.items.isNotEmpty) _LineItemsCard(receipt: receipt),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.imageUrl, this.vendorName});

  final String imageUrl;
  final String? vendorName;

  @override
  Widget build(BuildContext context) {
    final fullUrl = '${ApiClient.baseUrl}$imageUrl';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showImageDialog(context, fullUrl),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fullUrl,
                  height: 160,
                  width: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 160,
                      width: 120,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, _, _) => Container(
                    height: 160,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 36,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vendorName ?? '?',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.zoom_in, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    'Tap to view full image',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String fullUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Stack(
          children: [
            InteractiveViewer(
              child: Image.network(
                fullUrl,
                errorBuilder: (_, _, _) => Container(
                  height: 300,
                  color: Colors.grey.shade100,
                  child: Center(child: Text(vendorName ?? 'Receipt Image')),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Receipt Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _InfoField(
                    label: 'Vendor',
                    value: receipt.vendorName ?? '—',
                  ),
                ),
                Expanded(
                  child: _InfoField(label: 'Date', value: receipt.date ?? '—'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoField(
                    label: 'Total Amount',
                    value: receipt.totalAmount != null
                        ? '${receipt.totalAmount!.toStringAsFixed(2)} €'
                        : '—',
                  ),
                ),
                Expanded(
                  child: _InfoField(
                    label: 'Status',
                    value: '',
                    badge: StatusBadge(status: receipt.status),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value, this.badge});

  final String label;
  final String value;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        const SizedBox(height: 4),
        badge ?? Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _LineItemsCard extends StatelessWidget {
  const _LineItemsCard({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Line Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Item',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    'Price',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(width: 172),
                  Text(
                    'Category',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...receipt.items.map(
              (item) => LineItemRow(item: item, receiptId: receipt.id),
            ),
          ],
        ),
      ),
    );
  }
}
