import 'package:flutter/material.dart';
import '/screens/login_screen.dart';
import '/screens/signup_screen.dart';
import '../screens/buyer/home_screen.dart';
import '../screens/buyer/profile_screen.dart';
import '/screens/categories_screen.dart';
import '/screens/seller/add_item_screen.dart';
import '/screens/seller/home_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String register = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String category = '/category';
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String sellerhome = '/sellerhome';
  static const String selleradditem = '/selleradditem';
 

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    register: (context) => SignUpScreen(),
    home: (context) => HomeScreen(),
    profile: (context) => ProfileScreen(),
    category: (context) => CategoriesScreen(),
    sellerhome: (context) => SellerHomePage(),
    selleradditem: (context) => AddItemScreen(),

  };
}
