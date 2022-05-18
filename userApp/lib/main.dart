import 'package:flutter/material.dart';
import 'package:thrifty_cab/auth_widget.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/providers/home_provider.dart';
import 'package:thrifty_cab/providers/track_provider.dart';
import 'package:thrifty_cab/providers/user_provider.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('pt')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TrackProvider())
      ],
      child: MaterialApp(
        title: 'eTaxi',
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: colorSwatch,
          primaryColor: primaryColor,
        ),
        home: AuthWidget(),
      ),
    );
  }
}
