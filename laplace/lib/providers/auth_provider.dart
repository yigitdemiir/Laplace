import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _userModel;

  bool get isAuthenticated => _auth.currentUser != null;
  User? get currentUser => _auth.currentUser;
  UserModel? get userModel => _userModel;
  bool get isSeller => _userModel?.role == UserRole.seller;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userModel = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.id, doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('Attempting to sign in with email: $email');
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Sign in successful');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          message = 'This user has been disabled.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign in.';
      }
      throw message;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
    String? displayName,
    String? phoneNumber,
    String? storeName,
    String? storeDescription,
  }) async {
    try {
      debugPrint('Attempting to create user with email: $email');
      
      // First create the authentication user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      
      // Then create the user document in Firestore
      final userModel = UserModel(
        id: user.uid,
        email: email,
        displayName: displayName,
        role: role,
        createdAt: DateTime.now(),
        phoneNumber: phoneNumber,
        storeName: storeName,
        storeDescription: storeDescription,
      );

      // Set the document with the user's UID as the document ID
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      
      // Update the display name in Firebase Auth if provided
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      // Load the user data
      await _loadUserData(user.uid);
      
      debugPrint('User creation successful');
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        default:
          message = e.message ?? 'An error occurred during registration.';
      }
      throw message;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      // If there's an error, try to clean up the auth user if it was created
      if (_auth.currentUser != null) {
        await _auth.currentUser!.delete().catchError((e) => debugPrint('Error deleting auth user: $e'));
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userModel = null;
      notifyListeners();
    } catch (e) {
      throw 'An error occurred while signing out.';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        default:
          message = e.message ?? 'An error occurred while resetting password.';
      }
      throw message;
    } catch (e) {
      throw 'An unexpected error occurred.';
    }
  }

  Future<void> updateUserInfo({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? storeName,
    String? storeDescription,
  }) async {
    try {
      if (_auth.currentUser != null && _userModel != null) {
        final updates = <String, dynamic>{};
        
        if (displayName != null) {
          await _auth.currentUser!.updateDisplayName(displayName);
          updates['displayName'] = displayName;
        }
        if (photoURL != null) {
          await _auth.currentUser!.updatePhotoURL(photoURL);
          updates['photoURL'] = photoURL;
        }
        if (phoneNumber != null) {
          updates['phoneNumber'] = phoneNumber;
        }
        if (_userModel!.role == UserRole.seller) {
          if (storeName != null) updates['storeName'] = storeName;
          if (storeDescription != null) updates['storeDescription'] = storeDescription;
        }

        if (updates.isNotEmpty) {
          await _firestore.collection('users').doc(_userModel!.id).update(updates);
          await _loadUserData(_userModel!.id);
        }
      }
    } catch (e) {
      throw 'An error occurred while updating user info.';
    }
  }
} 