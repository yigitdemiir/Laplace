import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/user_model.dart';
import '../settings/settings_page.dart';
import '../orders/order_history_page.dart';
import '../address/address_list_page.dart';
import '../wishlist/wishlist_page.dart';
import '../bank_cards/bank_cards_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userModel = authProvider.userModel;
    final userEmail = authProvider.currentUser?.email ?? 'No email';
    final isSeller = userModel?.role == UserRole.seller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surface,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            if (isSeller && userModel?.storeName != null) ...[
              Text(
                userModel!.storeName!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ] else if (userModel?.displayName != null) ...[
              Text(
                userModel!.displayName!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              userEmail,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            // Profile Menu
            if (isSeller) ...[
              _buildMenuItem(
                icon: Icons.store,
                title: 'My Store',
                onTap: () {
                  // TODO: Navigate to store management page
                },
              ),
              _buildMenuItem(
                icon: Icons.inventory,
                title: 'My Products',
                onTap: () {
                  // TODO: Navigate to products management page
                },
              ),
              _buildMenuItem(
                icon: Icons.credit_card,
                title: 'Bank Cards',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BankCardsPage(),
                    ),
                  );
                },
              ),
            ] else ...[
              _buildMenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryPage(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.favorite_border,
                title: 'Wishlist',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistPage(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Shipping Addresses',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddressListPage(),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 