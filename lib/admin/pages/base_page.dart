import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/utils/progressHUD.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminBasePage extends StatefulWidget {
  const AdminBasePage();

  @override
  AdminBasePageState createState() => AdminBasePageState();
}

class AdminBasePageState<T extends AdminBasePage> extends State<T> {
  String pageTitle = '';
  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return SafeArea(
        child: Scaffold(
          body: ProgressHUD(
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getTopNav(
                    context,
                    pageTitle,
                    getThemeColor(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                    ),
                    false,
                  ),
                  pageUI(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget pageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
