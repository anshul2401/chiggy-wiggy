import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/pages/order_page_list.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage();

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTopNav(
            context,
            'My Account',
            getThemeColor(),
            Container(),
            false,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getBoldText(
                  'Welcome',
                  18,
                  Colors.black,
                ),
                getCard('Order', 'Check my order', Icons.shopping_bag_rounded,
                    OrderPage()),
                getCard(
                  'Edit Profile',
                  'Edit my profile',
                  Icons.edit,
                  OrderPage(),
                ),
                getCard('Log out', 'Log out from the application',
                    Icons.logout_rounded, OrderPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getCard(String title, String subtitle, IconData icon, Widget method) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => method));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        icon,
                        size: 36,
                        color: Colors.grey,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getBoldText(title, 16, Colors.black),
                        SizedBox(
                          height: 5,
                        ),
                        getNormalText(
                          subtitle,
                          14,
                          getThemeColor(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
