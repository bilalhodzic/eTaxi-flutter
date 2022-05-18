import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/screens/commonPages/settings.dart';
import 'package:thrifty_cab/screens/taxi/home_taxi.dart';
import 'package:thrifty_cab/screens/taxi/myTrip.dart';
import 'package:thrifty_cab/screens/commonPages/track_car.dart';
import 'package:thrifty_cab/services.dart/preferences.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';

class HomeMainTaxi extends StatefulWidget {
  final int index;

  const HomeMainTaxi({Key? key, this.index = 0}) : super(key: key);
  @override
  _HomeMainTaxiState createState() => _HomeMainTaxiState();
}

class _HomeMainTaxiState extends State<HomeMainTaxi> {
  int _index = 0;
  getUser() async {
    Future.delayed(Duration(seconds: 2));
    final user = await PreferencesUtils.getUser();
    Provider.of<AuthProvider>(context, listen: false).setUser(user);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await getUser();
  }

  @override
  void initState() {
    _index = widget.index;
    super.initState();
  }

  List<NavModel> _menu = [
    NavModel(icon: 'assets/icons/home.svg'),
    NavModel(icon: 'assets/icons/location.svg'),
    NavModel(icon: 'assets/icons/history.svg'),
    NavModel(icon: 'assets/icons/settings.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    List<Widget> _screens = [
      HomeTaxi(),
      TrackCarScreen(),
      MyTrips(),
      Settings(
        isTaxi: true,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: Container(
        height: h * 55,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedIconTheme: IconThemeData(size: h * 20),
          currentIndex: _index,
          items: _menu.map((e) {
            return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                e.icon,
                color: Color(0xffcccccc),
              ),
              activeIcon: SvgPicture.asset(
                e.icon,
                color: Colors.black,
              ),
              label: '',
            );
          }).toList(),
          onTap: (menuIndex) {
            setState(() {
              _index = menuIndex;
            });
          },
        ),
      ),
      body: IndexedStack(
        children: _screens,
        index: _index,
      ),
    );
  }
}

class NavModel {
  String icon;
  NavModel({required this.icon});
}
