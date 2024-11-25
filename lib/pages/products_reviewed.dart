// lib/screens/reviewed_products.dart

import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../class/product.dart';
import '../widgets/product_card.dart';
import '../widgets/product_modal.dart';

class ReviewedProductsScreen extends StatefulWidget {
  final Function(int) onProductDeleted;
  final Function(Product) onProductRestore;

  const ReviewedProductsScreen({
    super.key,
    required this.onProductDeleted,
    required this.onProductRestore,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ReviewedProductsScreenState createState() => _ReviewedProductsScreenState();
}

class _ReviewedProductsScreenState extends State<ReviewedProductsScreen> {
  final DatabaseService dbService = DatabaseService();
  List<Product> reviewedProducts = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  final int productsPerPage = 7;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreReviewedProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreReviewedProducts();
      }
    });
  }

  Future<void> _loadMoreReviewedProducts() async {
    if (!isLoading && hasMore) {
      setState(() {
        isLoading = true;
      });
      List<Product> newProducts = await dbService.fetchReviewedProducts(
        offset: (currentPage - 1) * productsPerPage,
        limit: productsPerPage,
      );
      setState(() {
        reviewedProducts.addAll(newProducts);
        isLoading = false;
        if (newProducts.length < productsPerPage) {
          hasMore = false;
        } else {
          currentPage++;
        }
      });
    }
  }

  void _deleteProduct(int id) {
    dbService.deleteProduct(id).then((_) {
      setState(() {
        final deletedProduct =
            reviewedProducts.firstWhere((product) => product.id == id);
        reviewedProducts.removeWhere((product) => product.id == id);
        widget.onProductDeleted(id);
        // Restore product to the initial list without approval or rejection
        deletedProduct.isApproved = null;
        widget.onProductRestore(deletedProduct);
      });
    });
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductModal(product: product);
      },
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context); // Go back to the previous screen
    return false; // Prevent the default behavior of popping the drawer
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Productos Revisados'),
          backgroundColor: const Color.fromARGB(255, 7, 102, 109),
        ),
        body: ListView.builder(
          controller: _scrollController,
          itemCount: reviewedProducts.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < reviewedProducts.length) {
              return ProductCard(
                product: reviewedProducts[index],
                onDelete: () => _deleteProduct(reviewedProducts[index].id),
                onDetails: () => _showProductDetails(reviewedProducts[index]),
                onReject: (isChecked) {},
                onAccept: (isChecked) {},
              );
            } else if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
