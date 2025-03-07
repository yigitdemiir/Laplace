import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/address_provider.dart';
import '../../../models/address_model.dart';

class EditAddressPage extends StatefulWidget {
  final Address? address;

  const EditAddressPage({
    super.key,
    this.address,
  });

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _fullNameController.text = widget.address!.fullName;
      _addressLineController.text = widget.address!.addressLine;
      _cityController.text = widget.address!.city;
      _postalCodeController.text = widget.address!.postalCode;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser!.uid;

    try {
      if (widget.address != null) {
        // Update existing address
        final updatedAddress = Address(
          id: widget.address!.id,
          userId: userId,
          fullName: _fullNameController.text,
          addressLine: _addressLineController.text,
          city: _cityController.text,
          postalCode: _postalCodeController.text,
          isDefault: widget.address!.isDefault,
        );
        await addressProvider.updateAddress(updatedAddress);
      } else {
        // Add new address
        final newAddress = Address(
          id: '', // Will be set by Firestore
          userId: userId,
          fullName: _fullNameController.text,
          addressLine: _addressLineController.text,
          city: _cityController.text,
          postalCode: _postalCodeController.text,
        );
        await addressProvider.addAddress(newAddress);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving address: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressLineController,
              decoration: const InputDecoration(
                labelText: 'Address Line',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Postal Code',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your postal code';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveAddress,
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