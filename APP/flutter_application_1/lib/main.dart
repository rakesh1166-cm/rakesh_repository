import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/Influencerscreen.dart';
import 'package:flutter_application_1/Screen/Influencer/splash_screen.dart';
import 'package:flutter_application_1/Service/Influencer/influencer_service.dart';
import 'package:flutter_application_1/view_modal/Login_view_model.dart';
import 'package:flutter_application_1/view_modal/country_view_model.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:flutter_application_1/view_modal/tagviewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  final influencerAPI = InfluencerAPI();
  final influencerViewModel = InfluencerViewModel(influencerAPI);

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
          create: (_) => TagViewModel(),
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
      home: SplashScreen(),
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