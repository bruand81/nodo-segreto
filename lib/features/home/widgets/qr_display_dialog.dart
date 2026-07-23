import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrDisplayDialog extends StatelessWidget {
  const QrDisplayDialog({super.key, required this.data});

  final String data;

  static Future<void> show(BuildContext context, String data) {
    return showDialog<void>(
      context: context,
      builder: (_) => QrDisplayDialog(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('QR del messaggio'),
      content: SizedBox(
        width: 260,
        height: 260,
        child: PrettyQrView.data(
          data: data,
          decoration: const PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(color: Colors.black),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Chiudi'),
        ),
      ],
    );
  }
}
