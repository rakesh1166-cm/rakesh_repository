import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/imagescreen.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatefulWidget {
  final String productId;
  final String influencerAdminId;
  final String adminId;
  final String userName;
  final String status;
  final String adminEmail;
  final String cartId;
    final String order_id;
        final String influencerPaymentId;
    

   final String influadmin_id;
    final String suggestion;
    final String description;
    final String work_desc;
     final String currency;
    final String image_link;
  final String influencerEmail;
  final String taskLockStatus;
  final String taskDates;
  final String statusDate;
  final String taskCreated;
  final String cartCreated;
  final String orderCreated;
  final String pubStatus;
  final String influencerName;
    final String workurl;
  final String videourl;
    final String task_title;
  const OrderDetail({
    Key? key,
    required this.productId,
    required this.influencerAdminId,
    required this.influadmin_id,
      required this.influencerPaymentId,
    required this.adminId,
    required this.userName,
    required this.cartId,   
    required this.status,
    required this.suggestion,
       required this.order_id,
    required this.description,
    required this.work_desc,
    required this.currency,
    required this.image_link,
    required this.adminEmail,
    required this.workurl,
    required this.videourl,
    required this.influencerEmail,
    required this.taskLockStatus,
    required this.taskDates,
    required this.statusDate,
    required this.taskCreated,
    required this.cartCreated,
    required this.orderCreated,
    required this.pubStatus,
        required this.task_title,
    required this.influencerName,
  }) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> with NavigationMixin {
   Map<String, String> socialData = {}; // Store the social media data
    @override
  void initState() {
    super.initState();
    _fetchInfluencerData();
  }

void _fetchInfluencerData() {
    final influencerViewModel = Provider.of<InfluencerViewModel>(context, listen: false);
    influencerViewModel.fetchInfluencerData(widget.cartId, widget.influadmin_id);
    print("widget taskdate");
        print(widget.taskDates);
    // Assuming you have some way to notify when data is fetched
    influencerViewModel.addListener(() {
      setState(() {
        socialData = influencerViewModel.socialData; // Update socialData with the new values
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar
      title: 'Work Details',
      body: DefaultTabController(
        length: 4, // Number of tabs
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(text: 'General'),
                Tab(text: 'Description'),
                Tab(text: 'Status'),
                Tab(text: 'Images'), // Images tab
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGeneralTab(),
                  _buildDescriptionTab(),
                  _buildStatusTab(),
                  _buildImagesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralTab() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      children: [
        ListTile(
          title: Text('Task Title'),
        subtitle: Text(widget.task_title ?? 'N/A'),
        ),
        ListTile(
          title: Text('Cart ID'),
          subtitle: Text(widget.cartId ?? 'N/A'),
        ),
          ListTile(
          title: Text('Payment ID'),
          subtitle: Text(widget.influencerPaymentId ?? 'N/A'),
        ),
        ListTile(
          title: Text('Pay Date'),
          subtitle: Text(widget.orderCreated ?? 'N/A'),
        ),
        ListTile(
          title: Text('Product ID'),
          subtitle: Text(widget.productId ?? 'N/A'),
        ),
      ListTile(
        title: Text('Orders ID'),
        subtitle: Text(widget.order_id ?? 'N/A'),
      ),
ListTile(
  title: Text('Pay Amount'),
  subtitle: Text('1.0 ${widget.currency ?? ''}'),
),

 ListTile(
  title: Text('Work Link to influencer'),
  subtitle: InkWell(
    onTap: () {
      if (widget.videourl != null && widget.videourl!.isNotEmpty) {
        _launchURL(widget.videourl!); // Launch the URL if valid
      }
    },
    child: Builder(
      builder: (context) {
        if (widget.videourl != null && widget.videourl!.isNotEmpty) {
          // When videourl is available
          return Text(
            widget.videourl!,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          );
        } else {
          // When videourl is not available
          return Text(
            'Not available',
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
      if (widget.workurl != null && widget.workurl!.isNotEmpty) {
        _launchURL(widget.workurl!); // Launch the URL if valid
      }
    },
    child: Builder(
      builder: (context) {
        if (widget.workurl != null && widget.workurl!.isNotEmpty) {
          // When workurl is available
          return Text(
            widget.workurl!,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          );
        } else {
          // When workurl is not available
          return Text(
            'Not URL available',
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


      ],
    ),
  );
}

void _launchURL(String url) async {
  // Assuming you have the necessary package to launch URLs, like `url_launcher`
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget _buildDescriptionTab() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      children: [
        ListTile(
          title: Text('Task Description by Publisher'),
          subtitle: Text(widget.description?.isNotEmpty == true ? widget.description! : 'N/A'),
        ),
        ListTile(
          title: Text('Task Completed Description by Influencer'),
          subtitle: Text(widget.work_desc?.isNotEmpty == true ? widget.work_desc! : 'not available'),
        ),
        ListTile(
          title: Text('Modify Description by Publisher'),
          subtitle: Text(widget.suggestion?.isNotEmpty == true ? widget.suggestion! : 'N/A'),
        ),
        // Add static title "Bid by Influencer" in bold
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

  Widget _buildStatusTab() {
       return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
               ListTile(
            title: Text('Influencer Status'),         
              subtitle: Text(widget.status?.isNotEmpty == true ? widget.status! : 'N/A'),
          ),
          ListTile(
            title: Text('Publisher Status'),
             subtitle: Text(widget.pubStatus?.isNotEmpty == true ? widget.pubStatus! : 'N/A'),
          
          ),
       
        ],
      ),
    );
  }

  Widget _buildImagesTab() {
    if (widget.image_link.isEmpty) {
      return Center(child: Text('No images available.'));
    }

    // Cleanup imageLink to remove unnecessary characters
    String cleanImageLinks = widget.image_link.replaceAll('[', '').replaceAll(']', '').trim();
    
    // Split and map to URLs with proper encoding
    List<String> imageUrls = cleanImageLinks
        .split(',')
        .map((e) => 'https://www.wizbrand.com/storage/uploads/${Uri.encodeComponent(e.trim())}')
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
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes as int)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Center(
                          child: Icon(Icons.error, color: Colors.red));
                    },
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