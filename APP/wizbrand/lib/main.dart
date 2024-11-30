import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/competitorscreen.dart';
import 'package:wizbrand/Screen/Influencer/createorg.dart';
import 'package:wizbrand/Screen/Influencer/dashboard.dart';
import 'package:wizbrand/Screen/Influencer/emailscreen.dart';
import 'package:wizbrand/Screen/Influencer/guestscreen.dart';
import 'package:wizbrand/Screen/Influencer/intervaltask.dart';
import 'package:wizbrand/Screen/Influencer/keyscreen.dart';
import 'package:wizbrand/Screen/Influencer/keywordscreen.dart';
import 'package:wizbrand/Screen/Influencer/pagerank.dart';
import 'package:wizbrand/Screen/Influencer/phonescreen.dart';
import 'package:wizbrand/Screen/Influencer/project.dart';
import 'package:wizbrand/Screen/Influencer/socialrank.dart';
import 'package:wizbrand/Screen/Influencer/splash_screen.dart';
import 'package:wizbrand/Screen/Influencer/taskboard.dart';
import 'package:wizbrand/Screen/Influencer/teamrating.dart';
import 'package:wizbrand/Screen/Influencer/urlscreen.dart';
import 'package:wizbrand/Screen/Influencer/users.dart';
import 'package:wizbrand/Screen/Influencer/web.dart';
import 'package:wizbrand/Screen/Influencer/webassetscreen.dart';
import 'package:wizbrand/Service/Influencer/organization_service.dart';
import 'package:wizbrand/model/interval_task.dart';
import 'package:wizbrand/view_modal/Login_view_model.dart';
import 'package:wizbrand/view_modal/country_view_model.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';



void main() {
  final influencerAPI = OrganizationAPI();
  final influencerViewModel = OrganizationViewModel(influencerAPI);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => influencerViewModel,
        ),
          ChangeNotifierProvider(
          create: (_) => CountryViewModel(influencerAPI),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(api: influencerAPI, influencerViewModel: influencerViewModel),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Influencer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes for navigation
      initialRoute: '/',

      
      onGenerateRoute: (RouteSettings settings) {
         switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => SplashScreen());
          case '/organization':
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case '/users':
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => UsersScreen(orgSlug: orgSlug),
            );
          case '/new_project': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ProjectScreen(orgSlug: orgSlug),
            );
              case '/urls': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => UrlScreen(orgSlug: orgSlug),
            );
              case '/keywords': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => KeywordScreen(orgSlug: orgSlug),
            );
             case '/competitor_analysis': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => CompetitorScreen(orgSlug: orgSlug),
            );        
           
            case '/rank_overview': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => TeamRating(orgSlug: orgSlug),
            );
           
             case '/web_ratings': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => WebScreen(orgSlug: orgSlug),
            );

                  case '/page_rank': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => PageRank(orgSlug: orgSlug),
            );

                  case '/social_rank': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => SocialRank(orgSlug: orgSlug),
            );

          case '/asset_list': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ProjectScreen(orgSlug: orgSlug),
            );
                case '/key_manager': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => KeyScreen(orgSlug: orgSlug),
            );
                case '/web_access': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => WebassetScreen(orgSlug: orgSlug),
            );
             case '/email_access': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => EmailScreen(orgSlug: orgSlug),
            );
            case '/phone_numbers': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => PhoneScreen(orgSlug: orgSlug),
            );
             case '/guest_post': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => GuestScreen(orgSlug: orgSlug),
            );            
             case '/current_tasks': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => TaskBoards(orgSlug: orgSlug),
            );          
             case '/interval_tasks': // Add the new route for projects
            final String orgSlug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => IntervalTasks(orgSlug: orgSlug),
            );
          // Add other routes here as needed   
          default:
            return null;
        }
      },
    );
  }
}

Size displaySize(BuildContext context) {
  debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}