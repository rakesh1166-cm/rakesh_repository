import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  const ImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image"),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain, // Ensures the image fits within the screen
        ),
      ),
    );
  }
}