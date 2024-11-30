import 'package:flutter/material.dart';

class SuccessMsg extends StatefulWidget {
  final String message;

  const SuccessMsg({Key? key, required this.message}) : super(key: key);

  @override
  _SuccessMsgState createState() => _SuccessMsgState();
}

class _SuccessMsgState extends State<SuccessMsg> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard if open
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text('Message'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : Text(widget.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}