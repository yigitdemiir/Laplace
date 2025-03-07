import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/address_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  String _selectedPaymentMethod = 'card';
  String? _selectedAddressId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultAddress = Provider.of<AddressProvider>(context, listen: false).defaultAddress;
      if (defaultAddress != null) {
        setState(() {
          _selectedAddressId = defaultAddress.id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 0 && _selectedAddressId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a shipping address'),
                ),
              );
              return;
            }
            if (_currentStep < 2) {
              setState(() {
                _currentStep++;
              });
            } else {
              _processOrder();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          steps: [
            // Shipping Address Step
            Step(
              title: const Text('Shipping Address'),
              content: Column(
                children: [
                  ...addressProvider.addresses.map((address) => RadioListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(address.addressLine),
                        Text('${address.city}, ${address.postalCode}'),
                      ],
                    ),
                    value: address.id,
                    groupValue: _selectedAddressId,
                    onChanged: (value) {
                      setState(() {
                        _selectedAddressId = value.toString();
                      });
                    },
                    secondary: address.isDefault
                        ? Chip(
                            label: const Text('Default'),
                            backgroundColor: Theme.of(context).primaryColor,
                            labelStyle: const TextStyle(color: Colors.white),
                          )
                        : null,
                  )),
                ],
              ),
              isActive: _currentStep >= 0,
            ),
            // Payment Method Step
            Step(
              title: const Text('Payment Method'),
              content: Column(
                children: [
                  RadioListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.credit_card),
                        SizedBox(width: 16),
                        Text('Credit/Debit Card'),
                      ],
                    ),
                    value: 'card',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value.toString();
                      });
                    },
                  ),
                  if (_selectedPaymentMethod == 'card') ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Expiry Date',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              prefixIcon: Icon(Icons.security),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              isActive: _currentStep >= 1,
            ),
            // Order Summary Step
            Step(
              title: const Text('Order Summary'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedAddressId != null) ...[
                    const Text(
                      'Shipping Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addressProvider.addresses
                                  .firstWhere((a) => a.id == _selectedAddressId)
                                  .fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              addressProvider.addresses
                                  .firstWhere((a) => a.id == _selectedAddressId)
                                  .addressLine,
                            ),
                            Text(
                              '${addressProvider.addresses.firstWhere((a) => a.id == _selectedAddressId).city}, '
                              '${addressProvider.addresses.firstWhere((a) => a.id == _selectedAddressId).postalCode}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...cart.items.values.map((item) => ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
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
                    title: Text(item.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  )),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }

  void _processOrder() {
    if (_formKey.currentState!.validate() && _selectedAddressId != null) {
      // TODO: Process payment and create order
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Clear cart and navigate back
      Provider.of<CartProvider>(context, listen: false).clear();
      Navigator.of(context).pop();
    }
  }
} 