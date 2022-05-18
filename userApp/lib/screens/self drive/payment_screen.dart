import 'package:flutter/material.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var _razorPay = Razorpay();

  @override
  void initState() {
    super.initState();

    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    startPaymentProcess();
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final booking =
          Provider.of<BookingProvider>(context, listen: false).currentBooking;

      await Provider.of<BookingProvider>(context, listen: false)
          .verifyPayment(response, booking.bookingID!);
    } catch (e) {
      appSnackBar(context: context, msg: e.toString(), isError: true);
    } finally {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomeMain()), (route) => false);
    }
  }

  _handlePaymentError(PaymentFailureResponse response) {
    appSnackBar(context: context, msg: GenericError, isError: true);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
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

  startPaymentProcess() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final booking =
        Provider.of<BookingProvider>(context, listen: false).currentBooking;

    try {
      final bookIDinInt = getBookingIdInt(booking.bookingID!);
      final String orderID =
          await Provider.of<BookingProvider>(context, listen: false)
              .createPayment(bookIDinInt, user!.userId.toString());

      var options = {
        // 'key': RazorPayID,
        'amount': (booking.total! * 100).toInt(),
        'currency': "INR",
        'name': "Thrifty Cab",
        'order_id': orderID,
        'description': BookingSelfDriveLabel,
        'timeout': 60,
        'prefill': {
          'name': user.userName,
          'email': user.emailid,
          'contact': "+91" + user.phone!,
        },
        'customer_id': user.userId.toString(),
        'readonly': {'contact': true, 'email': true, 'name': true}
      };

      _razorPay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();

    _razorPay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: buttonGradient,
          ),
        ),
      ),
    );
  }
}
