import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'order_detail_page.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(context, 'active'),
                  _buildOrderList(context, 'completed'),
                  _buildOrderList(context, 'cancelled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, String status) {
    // Simulated orders data
    final List<Map<String, dynamic>> orders = [
      if (status == 'active')
        {
          'id': '#12345',
          'date': '2024-02-20',
          'status': 'Processing',
          'items': 3,
          'total': 149.99,
          'statusColor': AppColors.warning,
        },
      if (status == 'active')
        {
          'id': '#12346',
          'date': '2024-02-19',
          'status': 'Shipped',
          'items': 2,
          'total': 89.99,
          'statusColor': AppColors.info,
        },
      if (status == 'completed')
        {
          'id': '#12340',
          'date': '2024-02-15',
          'status': 'Delivered',
          'items': 4,
          'total': 199.99,
          'statusColor': AppColors.success,
        },
      if (status == 'completed')
        {
          'id': '#12339',
          'date': '2024-02-10',
          'status': 'Delivered',
          'items': 1,
          'total': 49.99,
          'statusColor': AppColors.success,
        },
      if (status == 'cancelled')
        {
          'id': '#12338',
          'date': '2024-02-05',
          'status': 'Cancelled',
          'items': 2,
          'total': 79.99,
          'statusColor': AppColors.error,
        },
    ];

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${status.toLowerCase()} orders',
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
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(
                orderId: order['id'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ${order['id']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order['statusColor'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: order['statusColor'],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    order['date'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${order['items']} items',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${order['total']}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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