import 'package:flutter/material.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final bool? isPhoneProvided;
  final bool? fromRoot;
  VerifyPhoneScreen({Key? key, @required this.isPhoneProvided, this.fromRoot})
      : super(key: key);

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool isOTPSent = false;
  bool isPressed = false;

  sendOtp() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .sendOTP(phoneController.text);

      isOTPSent = true;
      setState(() {});
      appSnackBar(
        context: context,
        msg: OTPSentSuccess,
        isError: false,
      );
    } catch (e) {
      appSnackBar(
        context: context,
        msg: e.toString(),
        isError: true,
      );
    } finally {
      setState(() {
        isPressed = false;
      });
    }
  }

  verifyOtp() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .verifyOTP(phoneController.text, otpController.text);
      appSnackBar(
        context: context,
        msg: WelcomeThriftyCab,
        isError: false,
      );

      if (widget.fromRoot == null || widget.fromRoot == false)
        Navigator.of(context).pop();
      else
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeMain(),
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
        isPressed = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    final provider = Provider.of<AuthProvider>(context);

    if (widget.isPhoneProvided!)
      phoneController.text = provider.user!.phone ?? "";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: b * 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh(30),
              Center(
                child: Image.asset(
                  'assets/images/verify_phone_illus.png',
                  height: h * 227,
                  width: b * 234,
                ),
              ),
              sh(40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TwoStepVerifyLabel,
                        style: TextStyle(
                          fontSize: b * 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      sh(30),
                      AppTextField(
                        label: EnterPhoneLabel,
                        controller: phoneController,
                        suffix: Text(
                          "+91",
                          style: TextStyle(
                            fontSize: b * 14,
                            height: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        isVisibilty: null,
                        inputType: TextInputType.number,
                        readOnly: widget.isPhoneProvided,
                        maxLength: 10,
                      ),
                      isOTPSent ? sh(20) : sh(0),
                      isOTPSent
                          ? AppTextField(
                              label: EnterOTPLabel,
                              controller: otpController,
                              suffix: null,
                              isVisibilty: null,
                              inputType: TextInputType.number,
                              maxLength: 6,
                            )
                          : sh(0),
                      sh(20),
                      isPressed
                          ? LoadingButton()
                          : AppButton(
                              label: !isOTPSent ? SubmitLabel : VerifyLabel,
                              onPressed: () async {
                                isPressed = true;
                                setState(() {});

                                if (!isOTPSent) {
                                  sendOtp();
                                } else {
                                  verifyOtp();
                                }
                              },
                            ),
                      sh(30)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
