import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screen/Influencer/myorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';

class UpdateTaskForm extends StatefulWidget {
  final int productId;
  final String orderId;
  final String taskTitle;
  final String description;
  final String videoLink;
  final List<dynamic> imageLinks;

  UpdateTaskForm({
    required this.productId,
    required this.orderId,
    required this.taskTitle,
    required this.description,
    required this.videoLink,
    required this.imageLinks,
  });

  @override
  _UpdateTaskFormState createState() => _UpdateTaskFormState();
}

class _UpdateTaskFormState extends State<UpdateTaskForm> {
  late TextEditingController taskTitleController;
  late TextEditingController descriptionController;
  late TextEditingController videoLinkController;
  late List<dynamic> imageLinks;
  late File _image;
  List<File> _images = [];
  List<String> _selectedFileNames = [];
  bool _isImageSelected = false;

  @override
  void initState() {
    super.initState();
    print("order id aa raha hain");
     print(widget.orderId);
    taskTitleController = TextEditingController(text: widget.taskTitle);
    descriptionController = TextEditingController(text: widget.description);
    videoLinkController = TextEditingController(text: widget.videoLink);
    imageLinks = widget.imageLinks;
  }

  Future<void> _pickImage() async {
    try {
      List<XFile> images = await ImagePicker().pickMultiImage(
        imageQuality: 85,
      );

      if (images != null && images.isNotEmpty) {
        if (images.length <= 3) {
          setState(() {
            _images = images.map((image) => File(image.path)).toList();
            _isImageSelected = true;
            _selectedFileNames = images.map((image) => image.name).toList();
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please select a maximum of 3 files.'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('No files chosen');
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              TextField(
                decoration: InputDecoration(
                  labelText: 'Social Post Headlines',
                  border: OutlineInputBorder(),
                ),
                controller: taskTitleController,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _selectedFileNames.map((fileName) {
                  return Text(
                    'Selected File: $fileName',
                    style: TextStyle(color: Colors.grey),
                  );
                }).toList(),
              ),
              if (imageLinks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected Images (${imageLinks.length}):',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      for (var imageLink in imageLinks)
                        Text(imageLink, style: TextStyle(fontSize: 14, color: Colors.red)),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Video Link',
                  border: OutlineInputBorder(),
                ),
                controller: videoLinkController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                controller: descriptionController, // Reuse the controller
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Call API using InfluencerViewModel
                      List<String> imageLinksStr = imageLinks.cast<String>();
                      try {
                        final influencerViewModel = Provider.of<InfluencerViewModel>(context, listen: false);
                        await influencerViewModel.updateTaskWithDetails(
                          widget.productId,
                          widget.orderId,
                          taskTitleController.text,
                          descriptionController.text,
                          videoLinkController.text,                       
                          _images, // Pass the list of selected images
                        );
                       Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrderScreen(),
                    ),
                  );
                      } catch (e) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update task. Please try again.'),
                          ),
                        );
                      }
                    },
                    child: Text('Add'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskLockSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Success'),
          content: Text('Task locked successfully!'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}