import 'package:flutter/material.dart';

class MyWebView extends StatelessWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? projectName;
  final String? Tasktype;
  final String? webname;
  final String? token_engineer;
  final String? username;
  final String? email;   
  final String? password;
  final String? pro_name;
  final String? pro_engg;
  final int? id;

  const MyWebView({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.projectName,
    this.Tasktype,
    this.webname,
    this.token_engineer,
    this.username,
    this.email,
    this.password,
    this.pro_name,
    this.pro_engg,
    this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Center(
        child: Text(
          'Web Access Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 250, 249, 250),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
   
            children: [
              _buildDetailRow('Task Type:', Tasktype ?? "N/A"),
              _buildDetailRow('Website:', webname ?? "N/A"),
              _buildDetailRow('Email:', email ?? "N/A"),
              _buildDetailRow('User Name:', username ?? "N/A"),
              _buildDetailRow('Password:', password ?? "N/A"),
              _buildDetailRow('Manage By:', token_engineer ?? "N/A"),
              _buildDetailRow('Key Name:', pro_name ?? "N/A"),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.0), // Space between title and value
          Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
