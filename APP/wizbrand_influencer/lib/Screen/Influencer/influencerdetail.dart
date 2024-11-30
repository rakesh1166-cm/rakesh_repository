import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/Screen/Influencer/imagescreen.dart';
import 'package:wizbrand_influencer/Screen/Influencer/taskboard.dart';
import 'package:wizbrand_influencer/model/mytask.dart';
import 'package:wizbrand_influencer/Screen/layout/mixins.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the package

class InfluencerDetailScreen extends StatefulWidget {
  final Mytask order;

  const InfluencerDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _InfluencerDetailScreenState createState() => _InfluencerDetailScreenState();
}

class _InfluencerDetailScreenState extends State<InfluencerDetailScreen> with NavigationMixin {
       Map<String, String> socialData = {}; // Store the social media data
 @override
void initState() {
  super.initState();
  _fetchInfluencerData();
}

void _fetchInfluencerData() {
  final influencerViewModel = Provider.of<InfluencerViewModel>(context, listen: false);
  
  // Use influencerAdminId and orderCartId from widget.order
  influencerViewModel.fetchInfluencerData(widget.order.orderCartId.toString(), widget.order.influencerAdminId.toString());
  
  // Add a listener to update the state when data is fetched
  influencerViewModel.addListener(() {
    setState(() {
      socialData = influencerViewModel.socialData; // Update socialData with the new values
    });
  });
}
  @override
  Widget build(BuildContext context) {
    return buildBaseScreen(
      currentIndex: 0, 
      title: 'Task Details',
      body: DefaultTabController(
        length: 4, 
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(text: 'General'),
                Tab(text: 'Description'),
                Tab(text: 'Status'),
                Tab(text: 'Images'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildGeneralInfo(),
                  buildDescriptionInfo(),
                  buildStatusInfo(),
                  buildImageInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // General Info Section with clickable Work Link
  Widget buildGeneralInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          ListTile(
            title: Text('Task Title'),
            subtitle: Text(widget.order.taskTitle ?? 'N/A'),
          ),
          ListTile(
            title: Text('Cart ID'),
            subtitle: Text(widget.order.orderCartId ?? 'N/A'),
          ),
              ListTile(
            title: Text('Payment ID'),
            subtitle: Text(widget.order.influencerPaymentId ?? 'N/A'),
          ),
          ListTile(
            title: Text('Pay Date'),
            subtitle: Text(widget.order.orderPayDate ?? 'N/A'),
          ),
          ListTile(
            title: Text('Product ID'),
            subtitle: Text(widget.order.orderProductId ?? 'N/A'),
          ),
          ListTile(
            title: Text('Orders ID'),
            subtitle: Text(widget.order.ordersId ?? 'N/A'),
          ),

          ListTile(
            title: Text('Pay Amount'),
            subtitle: Text('${widget.order.payAmount} ${widget.order.currency ?? ''}'),
          ),

    ListTile(
  title: Text('Work Link to influencer'),
  subtitle: InkWell(
    onTap: () {
      if (widget.order.videoLink != null && widget.order.videoLink!.isNotEmpty) {
        _launchURL(widget.order.videoLink!); // Launch the URL if valid
      }
    },
    child: Builder(
      builder: (context) {
        if (widget.order.videoLink != null && widget.order.videoLink!.isNotEmpty) {
          // When video link is available
          return Text(
            widget.order.videoLink!,
            style: TextStyle(
              color: const Color.fromARGB(255, 15, 15, 15),
              decoration: TextDecoration.underline,
            ),
          );
        } else {
          // When video link is not available
          return Text(
            'No work URL available',
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          );
        }
      },
    ),
  ),
), 

      ListTile(
  title: Text('Url completed by influencer'),
  subtitle: InkWell(
    onTap: () {
      if (widget.order.workUrl != null && widget.order.workUrl!.isNotEmpty) {
        _launchURL(widget.order.workUrl!); // Launch the URL if valid
      }
    },
    child: Builder(
      builder: (context) {
        if (widget.order.workUrl != null && widget.order.workUrl!.isNotEmpty) {
          // When workUrl is available
          return Text(
            widget.order.workUrl!,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          );
        } else {
          // When workUrl is not available
          return Text(
            'No Video Link',
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          );
        }
      },
    ),
  ),
),
          if (widget.order.status == 'not approved') ...[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Provider.of<InfluencerViewModel>(context, listen: false)
                          .approveTask(widget.order.id.toString());
                        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabDesign(),
        ),
      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to approve task. Please try again.')),
                      );
                    }
                  },
                  child: Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Provider.of<InfluencerViewModel>(context, listen: false)
                          .rejectTask(widget.order.id.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task rejected successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to reject task. Please try again.')),
                      );
                    }
                  },
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildDescriptionInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          ListTile(
            title: Text('Task Description by Publisher'),
             subtitle: Text(widget.order.description?.isNotEmpty == true ? widget.order.description! : 'N/A'),
            
          ),
          ListTile(
            title: Text('Task Completed Description by Influencer'),
            subtitle: Text(widget.order.workDesc?.isNotEmpty == true ? widget.order.workDesc! : 'N/A'),
          
          ),
             ListTile(
          title: Text('Modify Description by Publisher'),
          subtitle: Text(widget.order.suggestion?.isNotEmpty == true ? widget.order.suggestion! : 'N/A'),
        ),
           Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Bid for your social platform',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // Display each key-value pair in a single row with minimal space
        if (socialData.isNotEmpty) ...[
          for (var entry in socialData.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text(entry.value),
                ],
              ),
            ),
        ]
        
        ],
      ),
    );
  }

  Widget buildStatusInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          ListTile(
            title: Text('Influencer Status'),         
              subtitle: Text(widget.order.status?.isNotEmpty == true ? widget.order.status! : 'N/A'),
          ),
          ListTile(
            title: Text('Publisher Status'),
             subtitle: Text(widget.order.publisherStatus?.isNotEmpty == true ? widget.order.publisherStatus! : 'N/A'),
          
          ),
        ],
      ),
    );
  }

Widget buildImageInfo() {
  // Ensure imageLink is treated as a List<String>
  List<String>? imageLinks = widget.order.imageLink;

  // Check if imageLinks is null or empty
  if (imageLinks == null || imageLinks.isEmpty) {
    return Center(child: Text('No images available.'));
  }

  // Map the image filenames to full URLs
  List<String> imageUrls = imageLinks
      .map((e) => 'https://www.wizbrand.com/storage/uploads/$e')
      .toList();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ImageScreen(imageUrl: imageUrls[index]),
              ),
            );
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover, // Ensures the image covers the entire grid cell
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.zoom_out_map, // Zoom icon to indicate clickability
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
}