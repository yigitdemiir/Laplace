import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'category_detail_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryTile(context, Icons.checkroom, 'Clothing', '250+ items'),
          _buildCategoryTile(context, Icons.watch, 'Accessories', '100+ items'),
          _buildCategoryTile(context, Icons.sports_basketball, 'Sports', '150+ items'),
          _buildCategoryTile(context, Icons.devices, 'Electronics', '300+ items'),
          _buildCategoryTile(context, Icons.home, 'Home', '200+ items'),
          _buildCategoryTile(context, Icons.book, 'Books', '400+ items'),
          _buildCategoryTile(context, Icons.toys, 'Toys', '120+ items'),
          _buildCategoryTile(context, Icons.restaurant, 'Food', '180+ items'),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, IconData icon, String title, String itemCount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          itemCount,
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(categoryName: title),
            ),
          );
        },
      ),
    );
  }
} 