import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/auth_provider.dart';
import '../product/product_detail_page.dart';
import '../categories/category_detail_page.dart';
import '../search/search_page.dart';
import '../notifications/notifications_page.dart';
import '../product/add_product_form.dart';
import 'dart:convert';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'icon': Icons.checkroom, 'label': 'Clothing'},
    {'icon': Icons.watch, 'label': 'Accessories'},
    {'icon': Icons.sports_basketball, 'label': 'Sports'},
    {'icon': Icons.devices, 'label': 'Electronics'},
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.category, 'label': 'General'},
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    debugPrint('Auth status: ${authProvider.isAuthenticated ? 'Logged in' : 'Not logged in'}');
    if (authProvider.currentUser != null) {
      debugPrint('Current user ID: ${authProvider.currentUser!.uid}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(authProvider.isSeller ? 'My Store' : 'Laplace'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: authProvider.isSeller ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ) : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!authProvider.isSeller) ...[
              // Categories for buyers
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: categories
                            .map((category) => _buildCategoryItem(
                                  context,
                                  category['icon'] as IconData,
                                  category['label'] as String,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Products section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.isSeller ? 'My Products' : 'All Products',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      final products = authProvider.isSeller
                          ? productProvider.sellerProducts
                          : productProvider.products.values.toList();
                      
                      if (products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                authProvider.isSeller ? Icons.store : Icons.shopping_bag,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                authProvider.isSeller
                                    ? 'You haven\'t added any products yet'
                                    : 'No products available',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                              if (authProvider.isSeller) ...[
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddProductForm(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Product'),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(context, products[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailPage(categoryName: label),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: product.imageBase64.isNotEmpty
                    ? Image.memory(
                        base64Decode(product.imageBase64),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image,
                          size: 50,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : const Icon(
                        Icons.image,
                        size: 50,
                        color: AppColors.textSecondary,
                      ),
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 