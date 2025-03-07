import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Address> _addresses = [];
  bool _isLoading = false;

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  Address? get defaultAddress => _addresses.firstWhere((address) => address.isDefault, orElse: () => _addresses.first);

  Future<void> loadAddresses(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('addresses')
          .where('userId', isEqualTo: userId)
          .get();

      _addresses = snapshot.docs
          .map((doc) => Address.fromMap(doc.id, doc.data()))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress(Address address) async {
    try {
      // If this is the first address, make it default
      if (_addresses.isEmpty) {
        address = address.copyWith(isDefault: true);
      }

      final docRef = await _firestore
          .collection('addresses')
          .add(address.toMap());

      final newAddress = address.copyWith(id: docRef.id);
      _addresses.add(newAddress);

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding address: $e');
      rethrow;
    }
  }

  Future<void> updateAddress(Address address) async {
    try {
      await _firestore
          .collection('addresses')
          .doc(address.id)
          .update(address.toMap());

      final index = _addresses.indexWhere((a) => a.id == address.id);
      if (index != -1) {
        _addresses[index] = address;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _firestore
          .collection('addresses')
          .doc(addressId)
          .delete();

      _addresses.removeWhere((address) => address.id == addressId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting address: $e');
      rethrow;
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    try {
      // Start a batch write
      final batch = _firestore.batch();

      // Remove default status from current default address
      final currentDefault = _addresses.firstWhere(
        (address) => address.isDefault,
        orElse: () => _addresses.first,
      );
      
      if (currentDefault.id != addressId) {
        batch.update(
          _firestore.collection('addresses').doc(currentDefault.id),
          {'isDefault': false},
        );
      }

      // Set new default address
      batch.update(
        _firestore.collection('addresses').doc(addressId),
        {'isDefault': true},
      );

      // Commit the batch
      await batch.commit();

      // Update local state
      for (var i = 0; i < _addresses.length; i++) {
        if (_addresses[i].id == currentDefault.id) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        } else if (_addresses[i].id == addressId) {
          _addresses[i] = _addresses[i].copyWith(isDefault: true);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error setting default address: $e');
      rethrow;
    }
  }
} 