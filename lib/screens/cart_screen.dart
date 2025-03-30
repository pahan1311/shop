// lib/screens/cart_screen.dart

import 'package:shopngo/services/firebase_service.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getCartStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                title: Text('Product ID: ${item['productId']}'), // Replace with product name/details
                subtitle: Row(
                  children: [
                    Text('Quantity: ${item['quantity']}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _firebaseService.updateCartItemQuantity(
                          item['productId'], item['quantity'] + 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => item['quantity'] > 1
                          ? _firebaseService.updateCartItemQuantity(
                              item['productId'], item['quantity'] - 1)
                          : null,
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      _firebaseService.removeFromCart(item['productId']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}