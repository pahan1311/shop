import 'package:flutter/material.dart';
import 'package:shopngo/services/firebase_service.dart';
import 'package:shopngo/widgets/bottom_navigation_bar.dart';

// Color Palette
class AppColors {
  static const Color backgroundColor = Color(0xFFFFF2F2);
  static const Color lightBlue = Color(0xFFA9B5DF);
  static const Color mediumBlue = Color(0xFF7886C7);
  static const Color darkBlue = Color(0xFF2D336B);
}

class CartScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  CartScreen({super.key});

   void _navigateToPage(BuildContext context, int index) {
    String routeName = '';

    if (index == 0) {
      routeName = '/home';
    } else if (index == 1) {
      routeName = '/category';
    } else if (index == 2) {
      routeName = '/wishlist';
    } else if (index == 3) {
      routeName = '/cart';
    }

    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: const Text('Cart', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getCartStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.darkBlue));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: AppColors.darkBlue),
              ),
            );
          }

          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(color: AppColors.mediumBlue, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: item['imageUrl'] != null && item['imageUrl'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                            },
                          ),
                        )
                      : const Icon(Icons.image, size: 50, color: AppColors.mediumBlue),
                  title: Text(
                    item['name'] ?? 'Unnamed Item',
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(color: Colors.green[700]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Qty: ', style: TextStyle(color: AppColors.mediumBlue)),
                          IconButton(
                            icon: const Icon(Icons.remove, color: AppColors.darkBlue),
                            onPressed: item['quantity'] > 1
                                ? () => _firebaseService.updateCartItemQuantity(
                                      item['itemId'],
                                      item['quantity'] - 1,
                                    )
                                : null,
                          ),
                          Text(
                            '${item['quantity'] ?? 1}',
                            style: const TextStyle(color: AppColors.darkBlue),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: AppColors.darkBlue),
                            onPressed: () => _firebaseService.updateCartItemQuantity(
                              item['itemId'],
                              item['quantity'] + 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _firebaseService.removeFromCart(item['itemId']),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3,
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
  }
}