import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order $orderId'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStatus(),
            _buildOrderItems(),
            _buildShippingAddress(),
            _buildPaymentDetails(),
            _buildOrderSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusStep(
                  icon: Icons.shopping_cart,
                  title: 'Order Placed',
                  subtitle: 'Feb 20, 2024',
                  isCompleted: true,
                  isFirst: true,
                ),
              ),
              Expanded(
                child: _buildStatusStep(
                  icon: Icons.inventory_2,
                  title: 'Processing',
                  subtitle: 'Feb 21, 2024',
                  isCompleted: true,
                ),
              ),
              Expanded(
                child: _buildStatusStep(
                  icon: Icons.local_shipping,
                  title: 'Shipped',
                  subtitle: 'Feb 22, 2024',
                  isCompleted: false,
                ),
              ),
              Expanded(
                child: _buildStatusStep(
                  icon: Icons.check_circle,
                  title: 'Delivered',
                  subtitle: 'Expected Feb 24',
                  isCompleted: false,
                  isLast: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            if (!isFirst)
              Expanded(
                child: Container(
                  height: 2,
                  color: isCompleted ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
              child: Icon(
                icon,
                color: isCompleted ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
            ),
            if (!isLast)
              Expanded(
                child: Container(
                  height: 2,
                  color: isCompleted ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    // Simulated order items
    final List<Map<String, dynamic>> items = [
      {
        'name': 'Blue Denim Jacket',
        'size': 'L',
        'color': 'Blue',
        'quantity': 1,
        'price': 89.99,
      },
      {
        'name': 'White T-Shirt',
        'size': 'M',
        'color': 'White',
        'quantity': 2,
        'price': 29.99,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Size: ${item['size']} • Color: ${item['color']}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantity: ${item['quantity']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '\$${item['price']}',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '123 Main Street\nApt 4B\nNew York, NY 10001\nUnited States',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: +1 234 567 8900',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.credit_card),
                      const SizedBox(width: 8),
                      const Text(
                        '•••• •••• •••• 1234',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/images/visa.png',
                        width: 40,
                        height: 25,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.credit_card);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', '\$149.97'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Shipping', '\$5.99'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tax', '\$12.50'),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Total',
                    '\$168.46',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.primary : null,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
} 