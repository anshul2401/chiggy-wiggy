import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/authentication/home_page.dart';
import 'package:chiggy_wiggy/authentication/login_scree.dart';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/models/customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chiggy_wiggy/main.dart' as m;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: InitializerWidget());
  }
}

class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseAuth _auth;

  User _user;

  bool isLoading = true;

  APIService _apiService;

  setUserId(String phn) async {
    CustomerModel customer = await _apiService.getCustomerIdByMobile(phn);

    Config.userID = customer.id;
  }

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _apiService = new APIService();

    String phn = _user.phoneNumber.substring(1);
    setUserId(phn);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? LoginScreen()
            : m.MyApp();
  }
}
