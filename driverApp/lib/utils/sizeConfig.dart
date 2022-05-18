import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';

class SizeConfig {
  MediaQueryData _mediaQueryData = MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double _safeAreaHorizontal = 0;
  static double _safeAreaVertical = 0;
  static double b = 0;
  static double v = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    b = (screenWidth - _safeAreaHorizontal) / 100;
    v = (screenHeight - _safeAreaVertical) / 100;
  }
}

SizedBox sh(double h) {
  return SizedBox(height: h * SizeConfig.screenHeight / 812);
}

SizedBox sb(double b) {
  return SizedBox(width: b * SizeConfig.screenWidth / 375);
}

String timeFormat(TimeOfDay _selectedTime) {
  DateTime tempDate = DateFormat("hh:mm").parse(
      _selectedTime.hour.toString() + ":" + _selectedTime.minute.toString());
  var dateFormat = DateFormat("h:mm a");
  return dateFormat.format(tempDate);
}

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key? key,
    required this.b,
    required this.h,
  }) : super(key: key);

  final double b;
  final double h;

  static List images = [
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340049/thriftycab/avatar/merry_rose_sfxyaa.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340047/thriftycab/avatar/juhi_eoiulv.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340045/thriftycab/avatar/joe_west_zbwgfe.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340042/thriftycab/avatar/michail_ratbej.jpg",
    "https://res.cloudinary.com/djisilfwk/image/upload/v1644340040/thriftycab/avatar/fatima_feroz_danhwm.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: (images..shuffle()).first,
      width: b * 36,
      height: h * 36,
      fit: BoxFit.fitWidth,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
