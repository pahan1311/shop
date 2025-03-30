import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopngo/models/item_model.dart';
import 'package:shopngo/screens/buyer/profile_screen.dart';
import 'package:shopngo/screens/category_items_screen.dart';
import 'package:shopngo/screens/buyer/item_detail_screen.dart';
import 'package:shopngo/utils/constants.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../all_item_screen.dart';

class AppColors {
  static const Color backgroundColor = Color(0xFFFFF2F2);
  static const Color lightBlue = Color(0xFFA9B5DF);
  static const Color mediumBlue = Color(0xFF7886C7);
  static const Color darkBlue = Color(0xFF2D336B);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  // Predefined categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Beauty', 'icon': Icons.face_retouching_natural},
    {'name': 'Sports', 'icon': Icons.sports_basketball},
    {'name': 'Clothing', 'icon': Icons.checkroom},
    {'name': 'Books', 'icon': Icons.book},
    {'name': 'Toys', 'icon': Icons.toys},
    {'name': 'Others', 'icon': Icons.category},
  ];

  // Helper method to build category items
  Widget _buildCategoryItem(IconData icon, String title) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryItemsScreen(category: title),
        ),
      );
    },
    child: Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.mediumBlue),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
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

  // Search function
  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Search categories
    final categoryResults = _categories
        .where((cat) => cat['name'].toLowerCase().contains(query.toLowerCase()))
        .map((cat) => {'type': 'category', 'name': cat['name']})
        .toList();

    // Search items
    final itemSnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(5) // Limit to avoid too many results
        .get();

    final itemResults = itemSnapshot.docs
        .map((doc) => {
              'type': 'item',
              'item': ItemModel.fromFirestore(doc),
            })
        .toList();

    setState(() {
      _searchResults = [...categoryResults, ...itemResults];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        backgroundColor: AppColors.darkBlue,
        toolbarHeight: 100,
        title: const Text(
          "ShopNgo",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products or categories...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: AppColors.mediumBlue),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (value) => _performSearch(value),
                  ),
                ),

                // Banner/Featured Section
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Featured Banner',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Category Section
                Text(
  'Categories',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkBlue,
  ),
),
const SizedBox(height: 10),
SizedBox(
  height: 80,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: _categories.map((cat) => _buildCategoryItem(cat['icon'], cat['name'])).toList(),
  ),
),
                const SizedBox(height: 20),

                // Product Section
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllItemsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('items')
                      .orderBy('createdAt', descending: true)
                      .limit(8)
                      .snapshots(),
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
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No popular products available',
                          style: TextStyle(color: AppColors.mediumBlue),
                        ),
                      );
                    }

                    final items = snapshot.data!.docs.map((doc) => ItemModel.fromFirestore(doc)).toList();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(item: item),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: item.imageUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            child: Image.network(
                                              item.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Center(
                                                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                                );
                                              },
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(Icons.image, size: 40, color: Colors.grey),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${item.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Search Results Overlay
          if (_isSearching && _searchResults.isNotEmpty)
            Positioned(
              top: 70, // Adjust based on your app bar and search bar height
              left: 16,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return ListTile(
                        title: Text(
                          result['type'] == 'category' ? result['name'] : result['item'].name,
                          style: const TextStyle(color: AppColors.darkBlue),
                        ),
                        leading: Icon(
                          result['type'] == 'category' ? Icons.category : Icons.shopping_bag,
                          color: AppColors.mediumBlue,
                        ),
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _searchResults = [];
                            _isSearching = false;
                          });
                          if (result['type'] == 'category') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryItemsScreen(category: result['name']),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(item: result['item']),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) => _navigateToPage(context, index),
      ),
    );
  }
}