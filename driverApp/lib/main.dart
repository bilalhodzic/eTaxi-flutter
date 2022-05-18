import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/screens/auth_widget.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MyApp(),
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thrifty Cab Driver',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: colorSwatch,
        primaryColor: primaryColor,
      ),
      home: AuthWidget(),
    );
  }
}
