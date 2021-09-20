import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/utils/progressHUD.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  const BasePage();

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool showSncakbutton = false;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        backgroundColor: Colors.white
            .withOpacity(1)
            .withRed(254)
            .withBlue(245)
            .withGreen(230),
        body: Column(
          children: [
            getTopNav(
              context,
              'Checkout',
              getThemeColor(),
              Container(),
              showBackButton(),
            ),
            ProgressHUD(
              inAsyncCall: loaderModel.isApiCallProcess,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              child: pageUI(),
            ),
          ],
        ),
      );
    });
  }

  Widget pageUI() {
    return null;
  }

  bool showBackButton() {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
