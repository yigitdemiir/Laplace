import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Orders'),
              Tab(text: 'Promotions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationList(context, 'all'),
            _buildNotificationList(context, 'orders'),
            _buildNotificationList(context, 'promotions'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, String type) {
    // Simulated notifications data
    final List<Map<String, dynamic>> notifications = [
      if (type == 'all' || type == 'orders')
        {
          'icon': Icons.local_shipping,
          'color': AppColors.primary,
          'title': 'Order Shipped',
          'message': 'Your order #12345 has been shipped and will arrive in 2-3 days.',
          'time': '2 hours ago',
          'type': 'order',
        },
      if (type == 'all' || type == 'orders')
        {
          'icon': Icons.check_circle,
          'color': AppColors.success,
          'title': 'Order Delivered',
          'message': 'Your order #12344 has been delivered successfully.',
          'time': '1 day ago',
          'type': 'order',
        },
      if (type == 'all' || type == 'promotions')
        {
          'icon': Icons.local_offer,
          'color': AppColors.secondary,
          'title': 'Special Offer',
          'message': 'Get 20% off on all electronics this weekend!',
          'time': '5 hours ago',
          'type': 'promotion',
        },
      if (type == 'all' || type == 'promotions')
        {
          'icon': Icons.card_giftcard,
          'color': AppColors.secondary,
          'title': 'New Collection',
          'message': 'Check out our new summer collection!',
          'time': '2 days ago',
          'type': 'promotion',
        },
    ];

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(
          icon: notification['icon'],
          color: notification['color'],
          title: notification['title'],
          message: notification['message'],
          time: notification['time'],
          type: notification['type'],
        );
      },
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    required String time,
    required String type,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Handle notification tap
        },
      ),
    );
  }
} 