import 'package:flutter/material.dart';

class ProfileSreen extends StatefulWidget {
  const ProfileSreen({Key? key}) : super (key: key);

  @override
  _ProfileSreenState createState() => _ProfileSreenState();
}

class _ProfileSreenState extends State<ProfileSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text ("welcome to your profile Page"),
      ),
    );
  }
}
