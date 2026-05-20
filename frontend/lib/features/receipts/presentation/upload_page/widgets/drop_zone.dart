import 'package:flutter/material.dart';

class DropZone extends StatelessWidget {
  const DropZone({
    super.key,
    required this.onTap,
    this.filename,
    this.fileSize,
  });

  final VoidCallback onTap;
  final String? filename;
  final int? fileSize;

  bool get _hasFile => filename != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: _hasFile ? const Color(0xFF2E7D32) : Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Center(
          child: _hasFile
              ? _FileSelected(filename: filename!, fileSize: fileSize)
              : _EmptyZone(),
        ),
      ),
    );
  }
}

class _EmptyZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.upload_outlined, size: 36, color: Colors.grey.shade500),
        const SizedBox(height: 8),
        const Text('Drop your receipt here'),
        Text(
          'or click to browse',
          style: TextStyle(color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          'Accepts JPEG and PNG only',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }
}

class _FileSelected extends StatelessWidget {
  const _FileSelected({required this.filename, this.fileSize});

  final String filename;
  final int? fileSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 36,
          color: Color(0xFF2E7D32),
        ),
        const SizedBox(height: 8),
        Text(filename, style: const TextStyle(fontWeight: FontWeight.w500)),
        if (fileSize != null)
          Text(
            '${(fileSize! / 1024).toStringAsFixed(1)} KB',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
      ],
    );
  }
}
