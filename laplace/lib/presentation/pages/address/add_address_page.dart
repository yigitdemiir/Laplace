import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isDefault = false;
  final _nameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  String _buildFullAddress() {
    final parts = [
      _streetController.text,
      if (_apartmentController.text.isNotEmpty) _apartmentController.text,
      '${_cityController.text}, ${_stateController.text} ${_zipController.text}',
      _countryController.text,
    ];
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Address Name',
                hintText: 'e.g. Home, Office',
                prefixIcon: Icon(Icons.place),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter recipient\'s full name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Street Address',
                hintText: 'Enter street address',
                prefixIcon: Icon(Icons.home),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter street address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _apartmentController,
              decoration: const InputDecoration(
                labelText: 'Apartment, Suite, etc. (optional)',
                hintText: 'Enter apartment or suite number',
                prefixIcon: Icon(Icons.apartment),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      hintText: 'Enter city',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      hintText: 'Enter state',
                      prefixIcon: Icon(Icons.map),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter state';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP Code',
                      hintText: 'Enter ZIP code',
                      prefixIcon: Icon(Icons.pin),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ZIP code';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      hintText: 'Enter country',
                      prefixIcon: Icon(Icons.public),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter country';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Set as Default Address'),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value;
                });
              },
              secondary: Icon(
                Icons.check_circle,
                color: _isDefault ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'address': _buildFullAddress(),
                    'phone': _phoneController.text,
                    'isDefault': _isDefault,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
} 