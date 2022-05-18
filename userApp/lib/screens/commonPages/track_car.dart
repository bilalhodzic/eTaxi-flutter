import 'package:flutter/material.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/screens/commonPages/track_car_map.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class TrackCarScreen extends StatefulWidget {
  @override
  _TrackCarScreenState createState() => _TrackCarScreenState();
}

class _TrackCarScreenState extends State<TrackCarScreen> {
  TextEditingController idController = TextEditingController();
  bool isPressed = false;

  getID() async {
    isPressed = true;
    setState(() {});

    try {
      Map data = await Provider.of<BookingProvider>(context, listen: false)
          .getTrackingID(orderID: idController.text);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrackCarMapScreen(
            trackingID: data['tracking_id'],
            pickUpAddr: data['pick_address'],
            dropOffAddr: data['drop_address'],
          ),
        ),
      );
    } catch (e) {
      appSnackBar(
        context: context,
        msg: e.toString(),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          isPressed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
  
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            AppBarText(
              txt: TrackYrCar,
              icon: 'assets/icons/loc_icon.svg',
              actionIcon: null,
              isBackButton: false,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: b * 30),
                decoration: constBoxDecoration,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      sh(45),
                      Image.asset(
                        'assets/images/track_illus.png',
                        height: h * 200,
                        width: b * 152,
                      ),
                      sh(78),
                      AppTextField(
                        label: EnterYrOrderID,
                        controller: idController,
                        suffix: null,
                        isVisibilty: null,
                      ),
                      sh(20),
                      isPressed
                          ? LoadingButton()
                          : AppButton(
                              label: SubmitLabel,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (idController.text != '') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => TrackCarMapScreen(),
                                    ),
                                  );
                                } else
                                  appSnackBar(
                                    context: context,
                                    msg: NoIdLabel,
                                    isError: true,
                                  );
                              },
                            ),
                      sh(30)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
