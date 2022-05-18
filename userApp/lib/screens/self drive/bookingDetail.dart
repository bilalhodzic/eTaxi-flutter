import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thrifty_cab/models/booking_complete.dart';
import 'package:thrifty_cab/models/booking_history_model.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/screens/self%20drive/bookCar.dart';
import 'package:thrifty_cab/screens/self%20drive/dialogBoxCancel.dart';
import 'package:thrifty_cab/screens/staticPages/ratingsReview.dart';
import 'package:thrifty_cab/screens/staticPages/report.dart';
import 'package:thrifty_cab/screens/self%20drive/reportDetail.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/swipeCarContainer.dart';
import 'package:thrifty_cab/widgets/vehicle_tags.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingDetail extends StatefulWidget {
  final BookingHistoryModel booking;
  final int? bookingID;

  BookingDetail({Key? key, required this.booking, this.bookingID})
      : super(key: key);

  @override
  _BookingDetailState createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  final List<String> menuLabel = [
    CancelLabel,
    UpdateLabel,
    RatingLabel,
    ReportLabel,
    ReportHisLabel,
  ];

  BookingComplete booking =
      BookingComplete(pickup_uploads: [], dropoff_uploads: []);

  @override
  void didChangeDependencies() async {
    getBookingDetails();
    super.didChangeDependencies();
  }

  getBookingDetails() async {
    try {
      booking = await Provider.of<BookingProvider>(context, listen: false)
          .getBookingByID(widget.booking.bookingId!);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      appSnackBar(context: context, msg: e.toString(), isError: true);
    }
  }

  checkReportStatus() async {
    if (widget.booking.is_reported == 0)
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ReportScreen(bookingId: widget.booking.bookingId!)));
    else
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ReportDetail(bookingID: widget.booking.bookingId!)));
  }

  @override
  Widget build(BuildContext context) {
    final String startDate = DateFormat('EEE, d MMM, yy')
        .format(DateTime.parse(widget.booking.pickupDate!));
    final String endDate = DateFormat('EEE, d MMM, yy')
        .format(DateTime.parse(widget.booking.returnDate!));

    final startTime =
        TimeOfDay.fromDateTime(DateTime.parse(widget.booking.pickupDate!));
    final endTime =
        TimeOfDay.fromDateTime(DateTime.parse(widget.booking.returnDate!));
    if (widget.booking.rideStatus!.tr() == CompletedLabel ||
        widget.booking.rideStatus!.tr() == OnGoingLabel) {
      menuLabel.remove(UpdateLabel);
      menuLabel.remove(CancelLabel);
    }
    if (widget.booking.rideStatus!.tr() == CancelledLabel) {
      menuLabel.remove(CancelLabel);
      menuLabel.remove(UpdateLabel);
    }

    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: buttonGradient),
          child: Column(
            children: [
              AppBarText(
                txt: BookingHistoryLabel,
                icon: 'assets/icons/history.svg',
                isBackButton: true,
                actionIcon: null,
              ),
              Expanded(
                child: Container(
                  decoration: constBoxDecoration,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sh(20),
                        Container(
                          height: h * 140,
                          alignment: Alignment.center,
                          width: SizeConfig.screenWidth,
                          margin: EdgeInsets.symmetric(horizontal: b * 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(b * 4),
                            border: Border.all(
                              color: Color(0xfff2f2f2),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: b * 15),
                                child: SwipeCar(
                                  isBorder: false,
                                  imgUrl: widget.booking.vehicleDetails!.photo!,
                                  vehicleId: widget
                                      .booking.vehicleDetails!.vehicleId!
                                      .toString(),
                                ),
                              ),
                              Positioned(
                                top: h * 10,
                                right: b * 5,
                                child: PopupMenuButton<String>(
                                  padding: EdgeInsets.only(
                                      left: b * 14, right: b * 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(b * 4),
                                  ),
                                  onSelected: (value) {
                                    if (value == RatingLabel) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => RatingsReview(
                                            bookingId: widget.booking.bookingId
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    } else if (value == ReportLabel) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ReportScreen(
                                            bookingId:
                                                widget.booking.bookingId!,
                                          ),
                                        ),
                                      );
                                    } else if (value == UpdateLabel) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BookCar(
                                            vehicle:
                                                widget.booking.vehicleDetails,
                                            isUpdate: true,
                                            booking: widget.booking,
                                            limited:
                                                widget.booking.billingType ==
                                                        'Limited'
                                                    ? true
                                                    : false,
                                          ),
                                        ),
                                      );
                                    } else if (value == CancelLabel) {
                                      dialogBoxCancel(
                                          context, widget.booking, false);
                                    } else if (value == ReportHisLabel) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ReportDetail(
                                          bookingID: widget.booking.bookingId!,
                                        ),
                                      ));
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return menuLabel.map((String choice) {
                                      return PopupMenuItem<String>(
                                        height: h * 30,
                                        value: choice,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              label(choice),
                                              width: b * 17,
                                              color: Colors.black,
                                            ),
                                            sb(15),
                                            Text(
                                              choice,
                                              style: TextStyle(
                                                fontSize: b * 14,
                                                color: Colors.black
                                                    .withOpacity(0.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                  child: Icon(
                                    Icons.more_vert,
                                    size: b * 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sh(10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: b * 30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.booking.vehicleDetails!
                                                .vehicleName!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: b * 16,
                                            ),
                                          ),
                                          sh(10),
                                          Text(
                                            widget.booking.billingType! +
                                                " : " +
                                                (widget.booking.billingType ==
                                                        'Limited'
                                                    ? widget
                                                        .booking
                                                        .vehicleDetails!
                                                        .limitedPrice!
                                                    : widget
                                                        .booking
                                                        .vehicleDetails!
                                                        .unlimitedPrice!),
                                            style: TextStyle(
                                              color: secondaryColor,
                                              fontSize: b * 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          sh(5),
                                          Text(
                                            SelfDriveLabel,
                                            style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: b * 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          sh(10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              VehicleTags(
                                                txt: widget.booking
                                                    .vehicleDetails!.seater,
                                                size: b * 12,
                                              ),
                                              sb(6),
                                              VehicleTags(
                                                txt: widget.booking
                                                    .vehicleDetails!.fuelType,
                                                size: b * 12,
                                              ),
                                              sb(6),
                                              VehicleTags(
                                                txt: widget
                                                    .booking
                                                    .vehicleDetails!
                                                    .transmission!
                                                    .tr(),
                                                size: b * 11,
                                              ),
                                              widget.booking.vehicleDetails!
                                                          .airBags ==
                                                      "Yes"
                                                  ? sb(6)
                                                  : sh(0),
                                              widget.booking.vehicleDetails!
                                                          .airBags ==
                                                      "Yes"
                                                  ? VehicleTags(
                                                      txt: AirBagLabel,
                                                      size: b * 12,
                                                    )
                                                  : sh(0),
                                              sb(6),
                                            ],
                                          ),
                                          sh(8),
                                          VehicleTags(
                                            txt: widget
                                                .booking.vehicleDetails!.year,
                                            size: b * 12,
                                          ),
                                        ],
                                      ),
                                    ]),
                              ]),
                        ),
                        sh(10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: b * 30),
                          color: Color(0xfff2f2f2),
                          height: h * 2,
                        ),
                        sh(20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: b * 30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      BookingIdLabel,
                                      style: TextStyle(
                                        fontSize: b * 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      ": " +
                                          widget.booking.bookingId.toString(),
                                      style: TextStyle(
                                        fontSize: b * 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                sh(20),
                                Container(
                                  width: SizeConfig.screenWidth,
                                  padding: EdgeInsets.fromLTRB(
                                      b * 17, h * 11, b * 15, h * 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: borderColor),
                                    borderRadius: BorderRadius.circular(b * 4),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/blue_cirle.svg',
                                            width: b * 17,
                                          ),
                                          sb(19),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  booking.pickupAddr ?? "",
                                                  style: TextStyle(
                                                    letterSpacing: 0.45,
                                                    fontSize: b * 10,
                                                  ),
                                                ),
                                                sh(7),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "$StartDateLabel: " +
                                                          startDate,
                                                      style: TextStyle(
                                                        fontSize: b * 10,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "$StartTimeLabel: " +
                                                          timeFormat(startTime),
                                                      style: TextStyle(
                                                        fontSize: b * 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Transform.translate(
                                        offset: Offset(-b * 3, 0),
                                        child: Icon(
                                          Icons.more_vert,
                                          color: Color(0xff999999),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/choose_city.svg',
                                            color: secondaryColor,
                                            height: h * 20,
                                          ),
                                          sb(19),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  booking.destAddr ?? "",
                                                  style: TextStyle(
                                                    fontSize: b * 10,
                                                    letterSpacing: 0.45,
                                                  ),
                                                ),
                                                sh(7),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "$EndDateLabel: " +
                                                          endDate,
                                                      style: TextStyle(
                                                        fontSize: b * 10,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "$EndTimeLabel: " +
                                                          timeFormat(endTime),
                                                      style: TextStyle(
                                                        fontSize: b * 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        sh(20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: b * 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(b * 4),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sh(11),
                              textRow(b, BookingIdLabel,
                                  widget.booking.bookingId.toString(), h),
                              textRow(
                                  b, OrderIdLabel, widget.booking.orderId, h),
                              textRow(b, PaymentMethodLabel,
                                  booking.paymentOption ?? "", h),
                              textRow(b, PaymentStatusLabel,
                                  widget.booking.paymentStatus, h),
                              textRow(b, SecurityFeeLabel,
                                  '\u20b9 ${booking.securityFee}', h),
                              Padding(
                                padding: EdgeInsets.only(left: b * 22),
                                child: Text(
                                  "** $GSTLabel",
                                  style: TextStyle(
                                    fontSize: b * 10,
                                    color: Colors.black.withOpacity(0.7),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                              sh(20),
                              textRow(
                                b,
                                TotalAmountLabel,
                                widget.booking.totalAmount,
                                h,
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                        sh(20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textRow(double b, String? title, String? content, double h,
      {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(left: b * 22, right: b * 22, bottom: h * 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title!,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
                fontSize: b * 12,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content!,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
                fontSize: b * 12,
                color: secondaryColor,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String label(String title) {
    if (title == ReportLabel)
      return "assets/icons/report.svg";
    else if (title == CancelLabel)
      return "assets/icons/cancel.svg";
    else if (title == UpdateLabel)
      return "assets/icons/update.svg";
    else if (title == ReportHisLabel)
      return "assets/icons/report.svg";
    else if (title == RatingLabel) return "assets/icons/rating.svg";
    return '';
  }

  Widget docContainer({@required String? label, @required List? file}) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: b * 30),
          child: Text(
            label ?? "",
            style: TextStyle(
              fontSize: b * 12,
            ),
          ),
        ),
        sh(10),
        file != null
            ? SizedBox(
                height: h * 85,
                width: SizeConfig.screenWidth,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: b * 30),
                  physics: BouncingScrollPhysics(),
                  itemCount: file.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return fileContainer(
                      file[index],
                      label!,
                      h,
                    );
                  },
                ),
              )
            : sh(0),
        sh(20),
      ],
    );
  }

  Widget fileContainer(String? file, String label, double h) {
    var b = SizeConfig.screenWidth / 375;

    return InkWell(
      onTap: () {},
      child: Container(
        height: h * 83,
        width: b * 128,
        margin: EdgeInsets.only(right: b * 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: NetworkImage(file!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
