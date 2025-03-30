// lib/presentation/screens/seller_home_page.dart
import 'package:flutter/material.dart';
import '/screens/seller/add_item_screen.dart'; // Adjust path
import 'package:firebase_auth/firebase_auth.dart';

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({super.key});

  // Color palette
  static const Color backgroundColor = Color(0xFFFFF2F2); // #FFF2F2
  static const Color lightAccent = Color(0xFFA9B5DF); // #A9B5DF
  static const Color mediumAccent = Color(0xFF7886C7); // #7886C7
  static const Color darkAccent = Color(0xFF2D336B); // #2D336B

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        backgroundColor: darkAccent,
        foregroundColor: Colors.white, // Text/icon color
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Welcome, Seller!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Manage your products with ease.',
              style: TextStyle(
                fontSize: 16,
                color: mediumAccent,
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            _buildActionButton(
              context: context,
              title: 'Add New Item',
              icon: Icons.add,
              color: mediumAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddItemScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context: context,
              title: 'View My Items',
              icon: Icons.list,
              color: mediumAccent,
              onTap: () {
                Navigator.pushNamed(context, '/selleritems'); // Placeholder route
              },
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context: context,
              title: 'Manage Orders',
              icon: Icons.local_shipping,
              color: mediumAccent,
              onTap: () {
                Navigator.pushNamed(context, '/seller-orders'); // Placeholder route
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable button widget
  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50), // Full-width button
      ),
    );
  }
}