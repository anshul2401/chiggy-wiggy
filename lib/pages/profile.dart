import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          getTopNav(
              context, 'Edit Profile', getThemeColor(), Container(), true),
        ],
      ),
    );
  }
}
