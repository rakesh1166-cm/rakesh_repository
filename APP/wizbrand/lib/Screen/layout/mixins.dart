import 'package:flutter/material.dart';
import 'package:wizbrand/Screen/Auth/loginscreen.dart';
import 'package:wizbrand/Screen/Influencer/createorg.dart';
import 'package:wizbrand/Screen/Influencer/dashboard.dart';
import 'package:wizbrand/Screen/Influencer/organizationScreen.dart';
import 'package:wizbrand/Screen/layout/basescreen.dart';

mixin NavigationMixin<T extends StatefulWidget> on State<T> {
  Widget buildBaseScreen({required Widget body, required int currentIndex, required String title}) {
    return BaseScreen(
      currentIndex: currentIndex,
      title: title,
      body: body,
    );
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.home, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()), // Replace HomeScreen with your actual screen
          );
        },
      ),
      IconButton(
        icon: Icon(Icons.business, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrganizationScreen()), // Replace OrganizationScreen with your actual screen
          );
        },
      ),
    ];
  }
}