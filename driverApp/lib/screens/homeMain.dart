import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thrifty_cab_driver/screens/myTrip.dart';
import 'package:thrifty_cab_driver/screens/settings.dart';
import 'package:thrifty_cab_driver/screens/upcomingRides.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import '../dialogBoxes/dialogBoxAccept.dart';

class HomeMain extends StatefulWidget {
  final int index;

  const HomeMain({Key? key, this.index = 0}) : super(key: key);
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int _index = 0;

  @override
  void initState() {
    _index = widget.index;
    Future.delayed(Duration(seconds: 4), () => dialogBoxAccept(context));

    super.initState();
  }

  List<NavModel> _menu = [
    NavModel(icon: 'assets/icons/home.svg'),
    NavModel(icon: 'assets/icons/history.svg'),
    NavModel(icon: 'assets/icons/settings.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    List<Widget> _screens = [
      UpcomingRides(),
      BookingHistory(),
      Settings(),
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
