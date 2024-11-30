import 'package:flutter/material.dart';
import 'package:wizbrand/Screen/layout/bottomnavbar.dart';
import 'package:wizbrand/Screen/layout/navbar.dart';



class BaseScreen extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const BaseScreen({
    required this.body,
    required this.currentIndex,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Handle navigation based on the tapped item index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: widget.title,
        actions: widget.actions,
        leading: widget.leading,
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}