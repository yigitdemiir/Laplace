import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/user_model.dart';
import '../home/home_page.dart';
import '../categories/categories_page.dart';
import '../cart/cart_page.dart';
import '../orders/orders_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isSeller = authProvider.userModel?.role == UserRole.seller;

    final List<Widget> _sellerPages = const [
      HomePage(),
      OrdersPage(),
      ProfilePage(),
    ];

    final List<Widget> _buyerPages = const [
      HomePage(),
      CategoriesPage(),
      CartPage(),
      ProfilePage(),
    ];

    final List<BottomNavigationBarItem> _sellerItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag),
        label: 'Orders',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    final List<BottomNavigationBarItem> _buyerItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category),
        label: 'Categories',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: isSeller ? _sellerPages : _buyerPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: isSeller ? _sellerItems : _buyerItems,
      ),
    );
  }
} 