import 'package:dakna/features/home/presentation/pages/home_page.dart';
import 'package:dakna/features/home/presentation/pages/profile.dart';
import 'package:dakna/features/orders/presentation/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    OrdersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'طلباتك',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حسابك',
          ),
        ],
      ),
    );
  }
}

