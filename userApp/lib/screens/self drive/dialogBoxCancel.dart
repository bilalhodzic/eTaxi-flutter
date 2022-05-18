import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/providers/taxi/booking_provider.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/models/booking_history_model.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/screens/taxi/home_main_taxi.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:provider/provider.dart';

class DialogBoxCancel extends StatefulWidget {
  DialogBoxCancel(this.booking, this.isTaxi);

  final BookingHistoryModel booking;
  final bool? isTaxi;

  @override
  _DialogBoxCancelState createState() => _DialogBoxCancelState();
}

class _DialogBoxCancelState extends State<DialogBoxCancel> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: b * 20, vertical: h * 20),
                child: Row(
                  children: [
                    Text(
                      CancelBookingLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: b * 14,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Container(
                color: borderColor,
                height: h * 2,
                width: SizeConfig.screenWidth,
              ),
              sh(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: b * 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CancellationFeeLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: b * 14,
                        color: secondaryColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                    sh(10),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non volutpat eget donec tellus id sed. Varius nunc in faucibus duis consectetur ullamcorper. A amet sit.",
                      style: TextStyle(
                        fontSize: b * 12,
                        color: Colors.black.withOpacity(0.8),
                        letterSpacing: 0.6,
                      ),
                    ),
                    sh(14),
                    Text(
                      RefundAmountLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: b * 14,
                        color: secondaryColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                    sh(10),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non volutpat eget donec tellus id sed. Varius nunc in faucibus duis consectetur ullamcorper. A amet sit.",
                      style: TextStyle(
                        fontSize: b * 12,
                        color: Colors.black.withOpacity(0.8),
                        letterSpacing: 0.6,
                      ),
                    ),
                    sh(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: h * 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(b * 4),
                              ),
                              child: Text(
                                CancelLabel,
                                style: TextStyle(
                                  letterSpacing: 0.6,
                                  fontSize: b * 12,
                                  height: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        sb(20),
                        Expanded(
                          child: isPressed
                              ? LoadingButton()
                              : AppButton(
                                  label: ConfirmLabel,
                                  onPressed: () async {
                                    if (widget.isTaxi == false) {
                                      setState(() {
                                        isPressed = true;
                                      });
                                      await Provider.of<BookingProvider>(
                                              context,
                                              listen: false)
                                          .cancelBooking(
                                        widget.booking.bookingId!,
                                      );

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => HomeMain(index: 2),
                                        ),
                                      );
                                      appSnackBar(
                                        context: context,
                                        msg: CancelSuccessLabel,
                                        isError: false,
                                      );
                                    } else {
                                      setState(() {
                                        isPressed = true;
                                      });

                                      Future.delayed(Duration(seconds: 1), () {
                                        appSnackBar(
                                          context: context,
                                          msg: CancelSuccessLabel,
                                          isError: false,
                                        );

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (_) => MultiProvider(
                                              providers: [
                                                ChangeNotifierProvider(
                                                    create: (_) =>
                                                        TaxiBookingProvider()),
                                                ChangeNotifierProvider(
                                                    create: (_) =>
                                                        AppFlowProvider())
                                              ],
                                              child: HomeMainTaxi(),
                                            ),
                                          ),
                                          (route) => false,
                                        );
                                      });
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              sh(20),
            ],
          ),
        ],
      ),
    );
  }
}

void dialogBoxCancel(BuildContext context,
    BookingHistoryModel bookingHistoryModel, bool? isTaxi) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return DialogBoxCancel(bookingHistoryModel, isTaxi!);
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 300),
  );
}
