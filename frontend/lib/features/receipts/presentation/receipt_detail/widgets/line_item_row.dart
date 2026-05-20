import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/line_item.dart';
import '../bloc/receipt_detail_bloc.dart';

class LineItemRow extends StatelessWidget {
  const LineItemRow({super.key, required this.item, required this.receiptId});

  final LineItem item;
  final String receiptId;

  static const _categories = [
    'LEBENSMITTEL',
    'HAUSHALT',
    'GASTRONOMIE',
    'GESUNDHEIT',
    'ELEKTRONIK',
    'SONSTIGES',
  ];

  static const _labels = {
    'LEBENSMITTEL': 'Lebensmittel',
    'HAUSHALT': 'Haushalt',
    'GASTRONOMIE': 'Gastronomie',
    'GESUNDHEIT': 'Gesundheit',
    'ELEKTRONIK': 'Elektronik',
    'SONSTIGES': 'Sonstiges',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(item.name, style: const TextStyle(fontSize: 14)),
              ),
              Text(
                item.price != null
                    ? '${item.price!.toStringAsFixed(2)} €'
                    : '—',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 160,
                child: DropdownButtonFormField<String>(
                  initialValue: _categories.contains(item.category)
                      ? item.category
                      : 'SONSTIGES',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                            _labels[c] ?? c,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newCategory) {
                    if (newCategory != null && newCategory != item.category) {
                      context.read<ReceiptDetailBloc>().add(
                        ReceiptDetailCategoryUpdated(
                          receiptId: receiptId,
                          itemId: item.id,
                          category: newCategory,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
