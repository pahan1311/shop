// lib/screens/wishlist_screen.dart

import 'package:shopngo/services/firebase_service.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getWishlistStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final wishlistItems = snapshot.data ?? [];

          if (wishlistItems.isEmpty) {
            return const Center(child: Text('Your wishlist is empty.'));
          }

          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              return ListTile(
                title: Text('Product ID: ${item['productId']}'), // Replace with product name/details
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      _firebaseService.removeFromWishlist(item['productId']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}