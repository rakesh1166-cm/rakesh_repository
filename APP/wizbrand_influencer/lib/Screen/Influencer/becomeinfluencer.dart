import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/layout/mixins.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/Service/Influencer/influencer_service.dart';
import 'package:wizbrand_influencer/view_modal/form_view_model.dart';
import 'package:wizbrand_influencer/Screen/layout/influencermixins.dart';
import 'package:wizbrand_influencer/Screen/layout/formwidget.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';

class TabScreen extends StatefulWidget {
  final int initialTabIndex;

  TabScreen({this.initialTabIndex = 0});  // Set default tab index to 0

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with NavigationMixin, InfluencerListMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<String> _titles = [
    'Add social site',
    'Set Price',
    'Describe',
  ];

  final List<String> social_site = [
    'facebook',
    'twitter',
    'youtube',
    'wordpress',
    'tumblr',
    'instagram',
    'quora',
    'pinterest',
    'reddit',
    'telegram',
    'linkedin',
  ];

  List<List<String>> _fieldLabels = [
    [
      'Enter your facebook url',
      'Enter your twitter url',
      'Enter your youtube url',
      'Enter your wordpress url',
      'Enter your tumblr url',
      'Enter your instagram url',
      'Enter your quora url',
      'Enter your pinterest url',
      'Enter your reddit url',
      'Enter your telegram url',
      'Enter your linkedin url',
    ],
    [
      'Enter your facebook url',
      'Enter your twitter url',
      'Enter your youtube url',
      'Enter your wordpress url',
      'Enter your tumblr url',
      'Enter your instagram url',
      'Enter your quora url',
      'Enter your pinterest url',
      'Enter your reddit url',
      'Enter your telegram url',
      'Enter your linkedin url',
    ],
    [
      'Influenceras',
      'Biography',
    ],
  ];

  @override
   void initState() {
    super.initState();
    // Ensure initialTabIndex is within bounds
    _currentIndex = (widget.initialTabIndex >= 0 && widget.initialTabIndex <= 3) ? widget.initialTabIndex : 0;
    
    _tabController = TabController(length: 3, vsync: this, initialIndex: _currentIndex);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormViewModel(InfluencerAPI())),
        ChangeNotifierProvider(create: (_) => InfluencerViewModel(InfluencerAPI())),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text('Wizbrand', style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Add social site'),
              Tab(text: 'Set Price'),
              Tab(text: 'Describe'),
            ],
          ),
        ),
        body: Consumer<InfluencerViewModel>(
          builder: (context, viewModel, child) {
            final List<Widget> _tabs = [
              FormWidget(title: 'Add social site', fieldLabels: _fieldLabels[0], socialSite: social_site),
              FormWidget(title: 'Set Price', fieldLabels: _fieldLabels[1], socialSite: social_site),
              FormWidget(title: 'Describe', fieldLabels: _fieldLabels[2], socialSite: social_site),
            ];
            return buildBaseScreen(
              body: TabBarView(
                controller: _tabController,
                children: _tabs,
              ),
              currentIndex: _currentIndex,
              title: 'Wizbrand',
            );
          },
        ),
      ),
    );
  }
}