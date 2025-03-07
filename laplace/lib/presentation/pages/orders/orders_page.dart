import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock orders data
    final List<Map<String, dynamic>> mockOrders = [
      {
        'id': 'ORD001',
        'customerName': 'John Doe',
        'date': '2024-03-15',
        'status': 'Pending',
        'total': 149.99,
        'items': [
          {'name': 'Blue T-Shirt', 'quantity': 2, 'price': 29.99},
          {'name': 'Black Jeans', 'quantity': 1, 'price': 89.99},
        ],
      },
      {
        'id': 'ORD002',
        'customerName': 'Jane Smith',
        'date': '2024-03-14',
        'status': 'Shipped',
        'total': 199.99,
        'items': [
          {'name': 'Running Shoes', 'quantity': 1, 'price': 199.99},
        ],
      },
      {
        'id': 'ORD003',
        'customerName': 'Mike Johnson',
        'date': '2024-03-14',
        'status': 'Delivered',
        'total': 79.98,
        'items': [
          {'name': 'Cotton Shorts', 'quantity': 2, 'price': 39.99},
        ],
      },
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Shipped'),
              Tab(text: 'Delivered'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(mockOrders.where((order) => order['status'] == 'Pending').toList()),
            _buildOrderList(mockOrders.where((order) => order['status'] == 'Shipped').toList()),
            _buildOrderList(mockOrders.where((order) => order['status'] == 'Delivered').toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('No orders found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _showOrderDetails(context, order),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order['id']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      _buildStatusChip(order['status']),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order['customerName'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${order['date']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: \$${order['total'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'shipped':
        color = Colors.blue;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order['id']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusChip(order['status']),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Customer Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                order['customerName'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                (order['items'] as List).length,
                (index) {
                  final item = order['items'][index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['quantity']}x ${item['name']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${order['total'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (order['status'] == 'Pending')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement order acceptance
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Accept Order'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implement order rejection
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Reject Order'),
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