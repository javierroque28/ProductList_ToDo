// lib/widgets/product_modal.dart

import 'package:flutter/material.dart';
import '../class/product.dart';

class ProductModal extends StatelessWidget {
  final Product product;

  const ProductModal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalles del Producto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ID: ${product.id}'),
          Text('Título: ${product.title}'),
          Text(
              'Estado: ${product.isApproved == null ? 'No asignado' : (product.isApproved! ? 'Aprobado' : 'Rechazado')}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
