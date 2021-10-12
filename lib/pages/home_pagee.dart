import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/notifications/notification_test.dart';
import 'package:chiggy_wiggy/pages/account_page.dart';
import 'package:chiggy_wiggy/pages/cart.dart';
import 'package:chiggy_wiggy/pages/home_page.dart';
import 'package:chiggy_wiggy/pages/login_page.dart';
import 'package:chiggy_wiggy/pages/order_page_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomePagee extends StatefulWidget {
  const HomePagee();

  @override
  _HomePageeState createState() => _HomePageeState();
}

class _HomePageeState extends State<HomePagee> {
  FirebaseAuth _auth;

  User _user;

  int _index = 0;
  List<Widget> _widgetListLogin = [
    HomePage(),
    Cart(false),
    OrderPage(false),
    AccountPage(),
  ];
  List<Widget> _widgetListLogout = [
    HomePage(),
    LoginPage(),
    LoginPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;

    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.init(
      Config.oneSignalAppId,
    );
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print(playerId);

    // // await OneSignal.shared.setAppId(onSignalAppId);
    // await OneSignal.shared.getDeviceState().then((value) {
    //   print(value);
    //   APIService.updateOneSignal(value.userId).then((value) => {
    //         print(value),
    //       });
    // });
//tiillll
    // OneSignal.shared.init(
    //   onSignalAppId,
    // );

    OneSignal.shared.setInFocusDisplayType(
      OSNotificationDisplayType.notification,
    );
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      var data = openedResult.notification.payload.additionalData;
      print(data['orderid']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Result(data['orderid'].toString())));
    });
  }

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
      body:
          _user == null ? _widgetListLogout[_index] : _widgetListLogin[_index],
    );
  }
}
