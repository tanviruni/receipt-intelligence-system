import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String get _label => switch (status) {
    'DONE' => 'Done',
    'FAILED' => 'Failed',
    _ => 'Pending',
  };

  Color get _backgroundColor => switch (status) {
    'DONE' => const Color(0xFF2E7D32),
    'FAILED' => const Color(0xFFB71C1C),
    _ => const Color(0xFFE0E0E0),
  };

  Color get _textColor => switch (status) {
    'DONE' => Colors.white,
    'FAILED' => Colors.white,
    _ => const Color(0xFF616161),
  };
}
