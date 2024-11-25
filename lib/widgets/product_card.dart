// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import '../class/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onDetails;
  final Function(dynamic) onReject;
  final Function(dynamic) onAccept;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onDetails,
    required this.onReject,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: product.isApproved == true ? Colors.green : Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    color: const Color.fromARGB(255, 153, 182, 178),
                    onPressed: onDetails,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: const Color.fromARGB(118, 255, 0, 0),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
