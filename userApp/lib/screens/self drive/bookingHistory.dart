import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thrifty_cab/models/booking_history_model.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/screens/self%20drive/bookingDetail.dart';
import 'package:thrifty_cab/screens/commonPages/login.dart';
import 'package:thrifty_cab/services.dart/preferences.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/vehcileCardShimmerHis.dart';
import 'package:thrifty_cab/widgets/vehicleCardHistory.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  Future<void>? getHistory;
  String? authToken;

  List<String> types = [
    AllBookingsLabel,
    PendingLabel,
    ConfirmedLabel,
    OnGoingLabel,
    CompletedLabel,
    CancelledLabel,
  ];
  String historyType = AllBookingsLabel;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    getAuthToken();

    getHistory = Provider.of<BookingProvider>(context, listen: false)
        .getBookingHistory();
  }

  void getAuthToken() async {
    authToken = await PreferencesUtils.getPref(PreferencesUtils.apiToken);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    final pro = Provider.of<BookingProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: buttonGradient,
              ),
              padding:
                  EdgeInsets.symmetric(vertical: h * 22, horizontal: b * 20),
              child: Row(children: [
                Spacer(),
                Text(
                  BookingHistoryLabel,
                  style: TextStyle(
                    fontSize: b * 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                Spacer(),
                auth.user == null || auth.user!.apiToken == null
                    ? SizedBox()
                    : PopupMenuButton<String>(
                        padding: EdgeInsets.only(left: b * 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(b * 4),
                        ),
                        onSelected: (value) {
                          setState(() {
                            historyType = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return types.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    choice != OnGoingLabel
                                        ? label(choice)
                                        : "assets/icons/choose_your_car.svg",
                                    width: b * 16,
                                    color: Colors.black,
                                  ),
                                  sb(26),
                                  Text(
                                    choice,
                                    style: TextStyle(
                                      fontSize: b * 14,
                                      color: Colors.black.withOpacity(0.75),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                        child: SvgPicture.asset(
                          "assets/icons/filter.svg",
                          color: Colors.black,
                          width: b * 20,
                        ),
                      ),
              ]),
            ),
            Expanded(
              child: Container(
                decoration: constBoxDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sh(20),
                    Expanded(
                      child: auth.user == null || auth.user!.apiToken == null
                          ? noLoginWidget()
                          : FutureBuilder(
                              future: getHistory,
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  List<BookingHistoryModel> bookingList = [];
                                  if (historyType != AllBookingsLabel)
                                    bookingList =
                                        pro.bookingHistory.where((element) {
                                      if (element.rideStatus!.tr() ==
                                          historyType)
                                        return true;
                                      else
                                        return false;
                                    }).toList();
                                  else
                                    bookingList = pro.bookingHistory;

                                  if (bookingList.length == 0)
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/no_booking_illus.png',
                                          width: b * 226,
                                          height: h * 140,
                                        ),
                                        sh(40),
                                        Text(
                                          NoBookingLbl,
                                          style: TextStyle(
                                            fontSize: b * 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        sh(10),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 70),
                                          child: Text(
                                            NoPreviousBookingLbl,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: b * 14,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  else
                                    return ListView.builder(
                                      padding: EdgeInsets.only(top: h * 16),
                                      shrinkWrap: true,
                                      itemCount: bookingList.length,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => BookingDetail(
                                                  booking: bookingList[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: VehicleCardHistory(
                                            bookingList[index],
                                          ),
                                        );
                                      },
                                    );
                                } else
                                  return ListView.builder(
                                      padding: EdgeInsets.only(top: h * 5),
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return VehicleCardHistoryShimmer();
                                      });
                              }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  noLoginWidget() {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no_booking_illus.png',
          width: b * 226,
          height: h * 140,
        ),
        sh(40),
        Text(
          NoLoginMsg,
          style: TextStyle(
            fontSize: b * 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        sh(10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: b * 50, vertical: h * 20),
          child: AppButton(
            label: LoginLabel,
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

String label(String title) {
  if (title == PendingLabel)
    return "assets/icons/pending.svg";
  else if (title == ConfirmedLabel)
    return "assets/icons/confirmed.svg";
  else if (title == CompletedLabel)
    return "assets/icons/completed.svg";
  else if (title == CancelledLabel)
    return "assets/icons/cancelled.svg";
  else if (title == ConfirmedLabel)
    return "assets/icons/confirmed.svg";
  else if (title == AllBookingsLabel) return "assets/icons/all bookings.svg";

  return '';
}

Color tagColor(String type) {
  if (type.tr() == CancelledLabel)
    return Color(0xffc22a23);
  else if (type.tr() == CompletedLabel)
    return Color(0xff14ce5e);
  else if (type.tr() == ConfirmedLabel)
    return Color(0xff55a3ff);
  else if (type.tr() == PendingLabel) return primaryColor;
  return Color(0xff395185);
}
