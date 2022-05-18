import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';

class SearchingWidget extends StatefulWidget {
  const SearchingWidget({Key? key}) : super(key: key);

  @override
  _SearchingWidgetState createState() => _SearchingWidgetState();
}

class _SearchingWidgetState extends State<SearchingWidget>
    with SingleTickerProviderStateMixin {
  moveToNext() async {
    await Future.delayed(Duration(seconds: 5));
    AudioCache player = AudioCache();
    await player.play('sounds/booking_success.mp3');

    anicontroller.dispose();
    Provider.of<AppFlowProvider>(context, listen: false)
        .changeBookingStage(BookingStage.Booked);
  }

  late AnimationController anicontroller;

  @override
  void initState() {
    moveToNext();
    super.initState();
    anicontroller = AnimationController(
      vsync: this,
      lowerBound: 0,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: anicontroller, curve: Curves.easeInCirc),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildContainer(150 * anicontroller.value),
            _buildContainer(250 * anicontroller.value),
            _buildContainer(350 * anicontroller.value),
            Align(
              child: sh(0),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black26.withOpacity(1 - (anicontroller.value)),
      ),
    );
  }
}
