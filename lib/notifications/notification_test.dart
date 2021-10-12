import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationS(),
      // home: SignupPage(),
    );
  }
}

class NotificationS extends StatefulWidget {
  const NotificationS();

  @override
  _NotificationSState createState() => _NotificationSState();
}

class _NotificationSState extends State<NotificationS> {
  static final String onSignalAppId = 'fd98bb7d-3747-4098-ab5a-1bcf8d72fd62';
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text('notification'),
          ),
          FlatButton(
              onPressed: () {
                sendNotification(['b0634531-dee7-42bc-abbe-6e89aac1d1d4'],
                    'Ding Dong Order!', 'Order Arrived');
              },
              child: Text('ra'))
        ],
      ),
    );
  }

  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            onSignalAppId, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},

        "data": {"orderid": '1'},
      }),
    );
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.init(
      onSignalAppId,
    );
    OneSignal.shared.setInFocusDisplayType(
      OSNotificationDisplayType.notification,
    );
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      var data = openedResult.notification.payload.additionalData;

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Result()));
    });
  }
}

class Result extends StatelessWidget {
  final String postId;
  Result(this.postId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(postId),
    );
  }
}
