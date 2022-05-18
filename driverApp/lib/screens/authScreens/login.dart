import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/screens/authScreens/forgot_password.dart';
import 'package:thrifty_cab_driver/screens/homeMain.dart';
import 'package:thrifty_cab_driver/staticPages/privacy_policy.dart';
import 'package:thrifty_cab_driver/staticPages/tnc.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';
import 'package:thrifty_cab_driver/widgets/app_snackBar.dart';
import 'package:thrifty_cab_driver/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  final bool? fromRoot;
  LoginScreen({Key? key, this.fromRoot}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool isVisibilty = false;
  bool isPressed = false;

  bool isError = false;
  bool terms = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController.text = 'demo@thriftycab.com';
    pwdController.text = 'abcd@1234';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: b * 30, vertical: h * 16),
          child: Column(
            children: [
              sh(40),
              Image.asset(
                'assets/images/login.png',
                width: b * 207,
                height: h * 156,
              ),
              sh(29),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$LoginLabel ",
                      style: TextStyle(
                        fontSize: b * 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.65,
                      ),
                    ),
                    sh(30),
                    AppTextField(
                      label: EnterEmail,
                      controller: emailController,
                      suffix: null,
                      isVisibilty: null,
                      validator: (value) {
                        Pattern emailPattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(emailPattern.toString());
                        if (value!.isEmpty) {
                          setState(() {
                            isError = true;
                          });
                          return FieldEmptyError;
                        } else if ((!regex.hasMatch(value.trim()))) {
                          setState(() {
                            isError = true;
                          });
                          return ValidEmailLabel;
                        } else
                          return null;
                      },
                    ),
                    sh(20),
                    AppTextFieldPassword(
                      label: PasswordLabel,
                      controller: pwdController,
                      isMisMatch: false,
                      error: isError,
                      validator: (val) {
                        if (val!.trim() == "") {
                          setState(() {
                            isError = true;
                          });
                          return FieldEmptyError;
                        } else {
                          setState(() {
                            isError = false;
                          });
                          return null;
                        }
                      },
                    ),
                    sh(20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        ForgotPasswordLabel + "?",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: b * 14,
                        ),
                      ),
                    ),
                    sh(20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          side: BorderSide(
                              color: Color(0xffcccccc), width: b * 1),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          activeColor: primaryColor,
                          checkColor: Colors.white,
                          value: terms,
                          onChanged: (v) {
                            setState(() {
                              terms = v!;
                            });
                          },
                        ),
                        sb(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AgreeLabel,
                              style: TextStyle(
                                height: 1.6,
                                fontSize: b * 13,
                                color: Color(0xff3A3A3A),
                              ),
                            ),
                            sh(2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => TnCScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    TnCLabel,
                                    style: TextStyle(
                                      fontSize: b * 13,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' $AndLabel ',
                                  style: TextStyle(
                                    fontSize: b * 13,
                                    color: Color(0xff3A3A3A),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PrivacyPolicyScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    PrivacyPolicyLabel.toLowerCase() + ".",
                                    style: TextStyle(
                                      fontSize: b * 14,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    sh(22),
                    Center(
                      child: (isPressed && terms)
                          ? LoadingButton()
                          : AppButton(
                              label: LoginLabel,
                              onPressed: () {
                                if (terms) {
                                  if (!_formKey.currentState!.validate())
                                    return null;

                                  isPressed = true;
                                  setState(() {});

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => HomeMain(),
                                    ),
                                  );
                                } else
                                  appSnackBar(
                                    context: context,
                                    msg: AcceptPrivacyLabel,
                                    isError: true,
                                  );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
