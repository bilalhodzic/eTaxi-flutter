import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:thrifty_cab/models/booking_model.dart';
import 'package:thrifty_cab/models/coupon_model.dart';
import 'package:thrifty_cab/models/vehicle_model.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/screens/staticPages/congo_page.dart';
import 'package:thrifty_cab/services.dart/booking_services.dart';
import 'package:thrifty_cab/utils/appBar.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/swipeCarContainer.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckOut extends StatefulWidget {
  final VehicleModel? vehicle;
  final String? coPassanger;
  CheckOut({Key? key, @required this.vehicle, this.coPassanger})
      : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final TextEditingController promoController = TextEditingController();
  bool cash = false;
  Booking booking = Booking();
  bool isPressed = false;

  late Razorpay _razorpay;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Booking curBooking =
        Provider.of<BookingProvider>(context, listen: false).currentBooking;

    try {
      final bookIDinInt = getBookingIdInt(curBooking.bookingID!);
      await Provider.of<BookingProvider>(context, listen: false)
          .verifyPayment(response, bookIDinInt);

      await Provider.of<BookingProvider>(context, listen: false).clearBooking();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CongoPage(isUpdate: false),
        ),
      );
    } catch (e) {
      print(e);
      appSnackBar(
        context: context,
        msg: GenericError,
        isError: true,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    await Provider.of<BookingProvider>(context, listen: false).clearBooking();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => CongoPage(
                  isUpdate: false,
                  isPaymentFailed: true,
                )),
        (route) => false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    appSnackBar(
      context: context,
      msg: "EXTERNAL_WALLET: " + response.walletName!,
      isError: false,
    );
  }

  bookCar(String paymentMethod, num amount) async {
    isPressed = true;
    setState(() {});
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      await Provider.of<BookingProvider>(context, listen: false)
          .bookSelfDrive(user!, paymentMethod, widget.coPassanger!);

      await Provider.of<BookingProvider>(context, listen: false).clearBooking();

      AudioCache player = AudioCache();
      player.play('sounds/booking_success.mp3');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CongoPage(isUpdate: false),
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

  String getBookingIdInt(String boi) {
    String idInInt = '';

    for (int i = boi.length - 1; i >= 0; i--) {
      if (boi[i] == '0' ||
          boi[i] == '1' ||
          boi[i] == '2' ||
          boi[i] == '3' ||
          boi[i] == '4' ||
          boi[i] == '5' ||
          boi[i] == '6' ||
          boi[i] == '7' ||
          boi[i] == '8' ||
          boi[i] == '9') {
        idInInt = idInInt + boi[i];
      } else
        break;
    }

    return idInInt.split("").reversed.join();
  }

  num appliedDiscount = 0;

  applyCoupon(String promoCode) async {
    FocusScope.of(context).unfocus();
    try {
      await Provider.of<BookingProvider>(context, listen: false)
          .applyCoupon(couponCode: promoCode);
      appSnackBar(
        context: context,
        msg: CouponAppliedMsg,
        isError: false,
      );
      setState(() {
        promoController.text = promoCode;
      });
    } catch (e) {
      appSnackBar(
        context: context,
        msg: e.toString(),
        isError: true,
      );
    }
  }

  bool isAgree = false;
  int app = 1;
  num originalDiscount = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    final provider = Provider.of<BookingProvider>(context);
    if (app == 1) {
      originalDiscount = provider.currentBooking.discount!;
      app++;
    }
    if (originalDiscount == 0) {
      appliedDiscount = provider.currentBooking.discount!;
    }
    return Scaffold(
      appBar: appBarCommon(context, h, b, CheckoutLabel),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: SizeConfig.screenWidth,
              decoration: constBoxDecoration,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sh(10),
                    SwipeCar(
                      imgUrl: widget.vehicle!.photo!,
                      vehicleId: widget.vehicle!.vehicleId.toString(),
                    ),
                    sh(10),
                    Padding(
                      padding: EdgeInsets.only(left: b * 30, right: b * 30),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.vehicle!.vehicleName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: b * 16,
                                ),
                              ),
                              sh(10),
                              Text(
                                provider.currentBooking.package ?? "",
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: b * 12,
                                  color: secondaryColor,
                                ),
                              ),
                              sh(5),
                              Text(
                                SelfDriveLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: b * 12,
                                  color: Color(0xff999999),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    sh(20),
                    Container(
                      margin: EdgeInsets.only(left: b * 30, right: b * 30),
                      padding: EdgeInsets.symmetric(
                        horizontal: b * 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: b * 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.6,
                              ),
                              controller: promoController,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              minLines: 1,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: PromoCodeHintLabel,
                                hintStyle: TextStyle(
                                  fontSize: b * 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.8),
                                  letterSpacing: 0.6,
                                ),
                                focusedBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              applyCoupon(promoController.text);
                            },
                            child: Text(
                              ApplyNowLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: b * 14,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sh(30),
                    Padding(
                      padding: EdgeInsets.only(left: b * 30),
                      child: Text(
                        AvaialbleCouponLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: b * 14,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    sh(10),
                    FutureBuilder(
                        future: BookingServices.getCoupons(
                            provider.currentBooking.typeID.toString()),
                        builder: (context, AsyncSnapshot<DiscountModel?> snap) {
                          if (snap.hasData) {
                            DiscountModel? _list = snap.data;
                            return _list!.data!.length != 0
                                ? SizedBox(
                                    height: h * 120,
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(left: b * 30),
                                        itemCount: _list.data!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Data data1 =
                                              _list.data!.elementAt(index);

                                          return InkWell(
                                            onTap: () async {
                                              applyCoupon(data1.couponCode!);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  right: b * 20),
                                              width:
                                                  SizeConfig.screenWidth * 0.75,
                                              padding: EdgeInsets.fromLTRB(
                                                b * 15,
                                                h * 14,
                                                b * 15,
                                                h * 14,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xfff6f6f6),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  4,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "$FlatLabel ${data1.discount} ${OFFLabel.toLowerCase()}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: b * 14,
                                                          letterSpacing: 0.6,
                                                          color: Color(
                                                            0xff3c3b3b,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  sh(10),
                                                  Text(
                                                    "$GetLabel ${data1.discount} $OffUpto \u20b9${data1.maxValue} $OntheBooking",
                                                    style: TextStyle(
                                                      fontSize: b * 12,
                                                      letterSpacing: 0.6,
                                                      color: Color(0xffa7a7a7),
                                                    ),
                                                  ),
                                                  sh(11),
                                                  Text(
                                                    "$PromoCodeLabel: " +
                                                        data1.couponCode!,
                                                    style: TextStyle(
                                                      fontSize: b * 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 0.6,
                                                      color: Color(0xffd40511),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                : sh(0);
                          } else
                            return sh(0);
                        }),
                    sh(20),
                    Padding(
                      padding: EdgeInsets.only(left: b * 30),
                      child: Text(
                        PaymentMethodLabel,
                        style: TextStyle(
                          fontSize: b * 14,
                          color: Color(0xff3c3b3b),
                        ),
                      ),
                    ),
                    sh(10),
                    Padding(
                      padding: EdgeInsets.only(left: b * 30, right: b * 30),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              cash = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: h * 15, horizontal: b * 25),
                            decoration: BoxDecoration(
                              color: !cash ? Colors.black : Colors.white,
                              border: Border.all(
                                color: cash ? borderColor : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              OnlineLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: b * 12,
                                letterSpacing: 0.45,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    sh(26),
                    Container(
                      margin: EdgeInsets.only(right: b * 30, left: b * 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(b * 4),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sh(20),
                          textRow(
                            b,
                            PaymentMethodLabel,
                            cash ? CashLabel : OnlineLabel,
                            h,
                            false,
                          ),
                          textRow(
                            b,
                            "\u20b9 ${provider.currentBooking.per_day_charge}*${provider.currentBooking.total_days} days",
                            "\u20b9" +
                                (provider.currentBooking.per_day_charge *
                                        provider.currentBooking.total_days)
                                    .toString(),
                            h,
                            false,
                          ),
                          provider.currentBooking.additional_hrs != 0
                              ? textRow(
                                  b,
                                  "\u20b9 ${provider.currentBooking.per_hour_rate}*${provider.currentBooking.additional_hrs} hours",
                                  "\u20b9" +
                                      (provider.currentBooking.per_hour_rate *
                                              num.parse(provider.currentBooking
                                                  .additional_hrs))
                                          .toString(),
                                  h,
                                  false,
                                )
                              : sh(0),
                          textRow(
                            b,
                            PickUpChargeLabel,
                            "\u20b9${provider.currentBooking.pickup_charge}",
                            h,
                            false,
                          ),
                          textRow(
                            b,
                            DropOffChargeLabel,
                            "\u20b9${provider.currentBooking.dropoff_charge}",
                            h,
                            false,
                          ),
                          textRow(
                            b,
                            SubtotalLabel,
                            "\u20b9" +
                                provider.currentBooking.subtotal.toString(),
                            h,
                            true,
                          ),
                          textRow(
                            b,
                            SecurityFeeLabel,
                            "\u20b9${provider.currentBooking.securityFee}",
                            h,
                            false,
                          ),
                          originalDiscount > 0
                              ? textRow(
                                  b,
                                  DiscountLabel,
                                  "${provider.currentBooking.discount}",
                                  h,
                                  false,
                                )
                              : sh(0),
                          provider.currentBooking.discount != 0
                              ? textRow(
                                  b,
                                  PromoCodeLabel,
                                  "${promoController.text}",
                                  h,
                                  false,
                                )
                              : sh(0),
                          appliedDiscount > 0
                              ? textRow(
                                  b,
                                  AppliedDisLabel,
                                  "\u20b9 $appliedDiscount",
                                  h,
                                  false,
                                )
                              : sh(0),
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
                          Container(
                            color: borderColor,
                            height: h * 1,
                          ),
                          sh(16),
                          textRow(
                            b,
                            TotalAmountLabel,
                            "\u20b9 " +
                                (provider.currentBooking.total! -
                                        provider.currentBooking.discount!)
                                    .toString(),
                            h,
                            true,
                          )
                        ],
                      ),
                    ),
                    sh(20),
                    InkWell(
                      onTap: () {
                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.3),
                          builder: (BuildContext context) {
                            return dialogWidget();
                          },
                          animationType: DialogTransitionType.fadeScale,
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(milliseconds: 300),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sb(26),
                          Checkbox(
                            side: BorderSide(
                              color: Color(0xffcccccc),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            activeColor: primaryColor,
                            checkColor: Colors.white,
                            value: isAgree,
                            onChanged: (v) {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.3),
                                builder: (BuildContext context) {
                                  return dialogWidget();
                                },
                                animationType: DialogTransitionType.fadeScale,
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 300),
                              );
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "$AgreeToLabel ",
                                style: TextStyle(
                                  height: 1.7,
                                  fontSize: b * 14,
                                  color: Color(0xff3A3A3A),
                                ),
                              ),
                              Text(
                                TnCLabel,
                                style: TextStyle(
                                  height: 1.7,
                                  fontSize: b * 14,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    sh(16),
                    isPressed
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: b * 30),
                            child: LoadingButton(),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: b * 30),
                            child: AppButton(
                                label:
                                    cash ? ConfirmBookingLbl : ProceedToBookLbl,
                                width: b * 230,
                                onPressed: () {
                                  if (isAgree) {
                                    if (cash)
                                      bookCar("Cash",
                                          provider.currentBooking.total!);
                                    else
                                      bookCar("Online",
                                          provider.currentBooking.total!);
                                  } else
                                    appSnackBar(
                                      context: context,
                                      msg: AcceptTnCLabel,
                                      isError: true,
                                    );
                                }),
                          ),
                    sh(100),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget textRow(
      double b, String? title, String? content, double h, bool isBold) {
    return Padding(
      padding: EdgeInsets.only(left: b * 22, right: b * 22, bottom: h * 17),
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

  double price(String offer) {
    double amount = 0;
    offer = offer.substring(2);
    amount = double.parse(
      offer.substring(0, offer.indexOf(' ')),
    );
    return amount;
  }

  Dialog dialogWidget() {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 10),
      ),
      child: SizedBox(
        height: h * 340,
        width: SizeConfig.screenWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: b * 20, vertical: h * 20),
              child: Row(
                children: [
                  Text(
                    IDVerifyLabel,
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
            sh(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: b * 20),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vulputate mauris scelerisque quis ultrices ut urna, eu nunc. Nulla risus, id cras vestibulum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vulputate mauris scelerisque quis ultrices ut urna, eu nunc. Nulla risus, id cras vestibulum.",
                style: TextStyle(
                  fontSize: b * 14,
                  letterSpacing: 0.6,
                  height: h * 18.51 / 14,
                ),
              ),
            ),
            sh(31),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: b * 20),
              child: AppButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (isAgree) {
                      isAgree = false;
                    } else {
                      isAgree = true;
                    }
                  });
                },
                label: !isAgree ? IAgreeLabel : IDisAgreeLabel,
              ),
            ),
            sh(25),
          ],
        ),
      ),
    );
  }
}
