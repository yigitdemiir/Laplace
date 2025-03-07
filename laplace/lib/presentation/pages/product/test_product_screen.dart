import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../providers/product_provider.dart';
import 'add_product_form.dart';

class TestProductScreen extends StatelessWidget {
  const TestProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final products = provider.products.values.toList();
          
          if (products.isEmpty) {
            return const Center(
              child: Text('No products available'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageBase64.isNotEmpty
                    ? SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.memory(
                          base64Decode(product.imageBase64),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : const Icon(Icons.image),
                title: Text(product.name),
                subtitle: Text(
                  '${product.description}\nPrice: \$${product.price.toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await productProvider.removeProduct(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product removed successfully!'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error removing product: $e'),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 