import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/layout/basescreen.dart';


mixin NavigationMixin<T extends StatefulWidget> on State<T> {
  Widget buildBaseScreen({required Widget body, required int currentIndex, required String title}) {
    return BaseScreen(
      currentIndex: currentIndex,
      title: title,
      body: body,
    );
  }
}