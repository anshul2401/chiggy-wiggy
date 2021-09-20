import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/pages/account_page.dart';
import 'package:chiggy_wiggy/pages/cart.dart';
import 'package:chiggy_wiggy/pages/home_page.dart';
import 'package:chiggy_wiggy/pages/order_page_list.dart';
import 'package:flutter/material.dart';

class HomePagee extends StatefulWidget {
  const HomePagee();

  @override
  _HomePageeState createState() => _HomePageeState();
}

class _HomePageeState extends State<HomePagee> {
  int _index = 0;
  List<Widget> _wodgetList = [
    HomePage(),
    Cart(false),
    OrderPage(),
    AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.storefront_outlined,
              ),
              label: 'Store'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: 'My cart'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: 'Account'),
        ],
        selectedItemColor: getThemeColor(),
        currentIndex: _index,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _wodgetList[_index],
    );
  }
}
