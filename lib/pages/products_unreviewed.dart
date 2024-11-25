// lib/screens/product_list.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../class/product.dart';
import 'products_reviewed.dart';

class UnreviewedProductScreen extends StatefulWidget {
  const UnreviewedProductScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UnreviewedProductScreenState createState() =>
      _UnreviewedProductScreenState();
}

class _UnreviewedProductScreenState extends State<UnreviewedProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService apiService = ApiService();
  final DatabaseService dbService = DatabaseService();
  Future<List<Product>>? futureProducts;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    try {
      futureProducts = apiService.fetchProducts();
      if (futureProducts != null) {
        futureProducts!.then((fetchedProducts) {
          setState(() {
            products = fetchedProducts.map((product) {
              product.isApproved = null; // Estado inicial sin aprobación
              return product;
            }).toList();
          });
        }).catchError((error) {});
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  void _viewReviewedProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewedProductsScreen(
          onProductDeleted: _onProductDeleted,
          onProductRestore: _onProductRestore,
        ),
      ),
    );
  }

  void _onProductDeleted(int productId) {
    setState(() {
      products.removeWhere((product) => product.id == productId);
    });
  }

  void _onProductRestore(Product product) {
    setState(() {
      product.isApproved = null; // Clear approval status
      products.add(product);
    });
  }

  void _viewProductList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UnreviewedProductScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Productos por revisar'),
        backgroundColor: const Color.fromARGB(255, 7, 102, 109),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 102, 109),
              ),
              accountName: Text("Javier Roque"),
              accountEmail: Text("javierroque2812@gmail.com"),
            ),
            ListTile(
              leading: const Icon(Icons.watch_later_outlined),
              title: const Text('Productos por revisar'),
              onTap: _viewProductList,
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Productos Revisados'),
              onTap: _viewReviewedProducts,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: products.map((product) {
                return Card(
                  elevation: 20,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          children: [
                            const Text('Aprobar'),
                            Checkbox(
                              value: product.isApproved == true,
                              onChanged: (isChecked) {
                                setState(() {
                                  product.isApproved = isChecked;
                                  dbService.insertProduct(product);
                                  if (isChecked != null) {
                                    _onProductDeleted(product.id);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          children: [
                            const Text('Rechazar'),
                            Checkbox(
                              value: product.isApproved == false,
                              onChanged: (isChecked) {
                                setState(() {
                                  product.isApproved = !isChecked!;
                                  dbService.insertProduct(product);
                                  // ignore: unnecessary_null_comparison
                                  if (isChecked != null) {
                                    _onProductDeleted(product.id);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewReviewedProducts,
        backgroundColor: const Color.fromARGB(255, 7, 102, 109),
        child: const Icon(Icons.checklist_rtl_rounded),
      ),
    );
  }
}
