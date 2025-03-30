// lib/screens/categories_screen.dart

import 'package:shopngo/utils/constants.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
    // List of categories with names and icons
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Electronics',
        'icon': Icons.devices_other,
      },
      {
        'name': 'Fashion',
        'icon': Icons.checkroom,
      },
      {
        'name': 'Home',
        'icon': Icons.home,
      },
      {
        'name': 'Beauty',
        'icon': Icons.spa,
      },
      {
        'name': 'Sports',
        'icon': Icons.sports_esports,
      },
      {
        'name': 'Toys',
        'icon': Icons.toys,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kBackgroundColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 categories per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0, // Adjust as needed
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              // Navigate to the category details page
              print('Category tapped: ${category['name']}');
              // You'll implement the navigation later
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'],
                    size: 50.0,
                    color: kAccentColor,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    category['name'],
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
  }
}