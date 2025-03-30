// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.uid;
  }

  // Wishlist Functions

  Future<void> addToWishlist(String productId) async {
    await _firestore
        .collection('wishlists')
        .doc('${userId}_$productId')
        .set({'userId': userId, 'productId': productId});
  }

  Future<void> removeFromWishlist(String productId) async {
    await _firestore
        .collection('wishlists')
        .doc('${userId}_$productId')
        .delete();
  }

  Stream<List<Map<String, dynamic>>> getWishlistStream() {
    return _firestore
        .collection('wishlists')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  // Cart Functions

  Future<void> addToCart(String productId, int quantity) async {
    await _firestore.collection('carts').doc('${userId}_$productId').set({
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
    });
  }

  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    await _firestore.collection('carts').doc('${userId}_$productId').update({
      'quantity': quantity,
    });
  }

  Future<void> removeFromCart(String productId) async {
    await _firestore.collection('carts').doc('${userId}_$productId').delete();
  }

  Stream<List<Map<String, dynamic>>> getCartStream() {
    return _firestore
        .collection('carts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }
}