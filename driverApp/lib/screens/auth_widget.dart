import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/screens/authScreens/login.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';

class AuthWidget extends StatefulWidget {
  AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  @override
  void initState() {
    checkState();
    super.initState();
  }

  checkState() async {
    _controller.animateTo(1, curve: Curves.bounceInOut);

    await Future.delayed(Duration(milliseconds: 2500));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          fromRoot: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(gradient: buttonGradient),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: b * 72),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    alignment: Alignment.center,
                    scale: _controller,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: h * 8, horizontal: b * 6.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/logo/full.jpg',
                      ),
                    ),
                  ),
                  sh(20),
                  Text(
                    "Driving Partner",
                    style: TextStyle(
                      fontSize: b * 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: _controller,
                child: Image.asset(
                  'assets/logo/taxi.png',
                  width: b * 250,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
