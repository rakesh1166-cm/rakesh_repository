import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/layout/basescreen.dart';


mixin NavigationMixin<T extends StatefulWidget> on State<T> {
  Widget buildBaseScreen({required Widget body, required int currentIndex, required String title}) {
    return BaseScreen(
      currentIndex: currentIndex,
      title: title,
      body: body,
    );
  }
}