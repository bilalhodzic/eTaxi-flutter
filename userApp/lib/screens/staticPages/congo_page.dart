import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/providers/taxi/booking_provider.dart';
import 'package:thrifty_cab/screens/taxi/home_main_taxi.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';

class CongoPage extends StatelessWidget {
  const CongoPage(
      {Key? key,
      required this.isUpdate,
      this.isPaymentFailed,
      this.istaxi = false})
      : super(key: key);

  final bool? isUpdate;
  final bool? isPaymentFailed;
  final bool? istaxi;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: buttonGradient),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: b * 30),
                  decoration: constBoxDecoration,
                  child: Column(
                    children: [
                      sh(140),
                      Text(
                        CongratulationsLabel,
                        style: TextStyle(
                          fontSize: b * 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff484848),
                        ),
                      ),
                      sh(54),
                      Image.asset(
                        'assets/images/congo_illus.png',
                        height: h * 160,
                        width: b * 295,
                      ),
                      sh(39),
                      Text(
                        !isUpdate!
                            ? isPaymentFailed == null ||
                                    isPaymentFailed == false
                                ? ConfirmMsg
                                : ConfirmMsgButPaymentFailed
                            : UpdateMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: b * 16,
                        ),
                      ),
                      sh(12),
                      Text(
                        ThankUMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: b * 24,
                          color: primaryColor,
                        ),
                      ),
                      sh(30),
                      AppButton(
                        label: ContinueLabel,
                        width: b * 139,
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => istaxi!
                                  ? MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                            create: (_) =>
                                                TaxiBookingProvider()),
                                        ChangeNotifierProvider(
                                            create: (_) => AppFlowProvider())
                                      ],
                                      child: HomeMainTaxi(index: 2,),
                                    )
                                  : HomeMain(
                                      index: 2,
                                    ),
                            ),
                            (route) => false,
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
