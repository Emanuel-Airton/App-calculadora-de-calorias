import 'package:flutter/material.dart';

class AlertdialogMostrarResultado extends StatelessWidget {
  int? calorias;
  AlertdialogMostrarResultado({super.key, required this.calorias});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Calorias calculadas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sua necessidade calórica diária é:\n',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            '${calorias!.toStringAsFixed(0)} calorias',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
