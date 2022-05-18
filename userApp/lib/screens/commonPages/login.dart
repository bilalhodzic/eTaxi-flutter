import 'package:flutter/material.dart';
import 'package:thrifty_cab/mode_selector.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/screens/commonPages/forgot_password.dart';
import 'package:thrifty_cab/screens/staticPages/privacy_policy.dart';
import 'package:thrifty_cab/screens/commonPages/register.dart';
import 'package:thrifty_cab/screens/staticPages/tnc.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

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

  // login() async {
  //   try {
  //     final provider = Provider.of<AuthProvider>(
  //       context,
  //       listen: false,
  //     );
  //     await provider.login();

  //     if (provider.user!.phoneVerified == 0) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (_) => VerifyPhoneScreen(
  //             isPhoneProvided: true,
  //             fromRoot: widget.fromRoot,
  //           ),
  //         ),
  //       );
  //     } else {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (_) => ModeSelectorScreen(),
  //         ),
  //       );
  //     }
  //     // await provider.login();
  //   } catch (e) {
  //     appSnackBar(
  //       context: context,
  //       msg: e.toString(),
  //       isError: true,
  //     );
  //   } finally {
  //     if (mounted) {
  //       isPressed = false;
  //       setState(() {});
  //     }
  //   }
  // }
  login() async {
    final provider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    await provider.login();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ModeSelectorScreen(),
      ),
    );
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
              sh(30),
              Image.asset(
                'assets/images/login_illus.png',
                width: b * 178,
                height: h * 133,
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
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (terms) {
                                  if (!_formKey.currentState!.validate())
                                    return null;

                                  isPressed = true;
                                  setState(() {});

                                  login();
                                } else
                                  appSnackBar(
                                    context: context,
                                    msg: AcceptPrivacyLabel,
                                    isError: true,
                                  );
                              },
                            ),
                    ),
                    sh(18),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: b * 10),
                            height: 1,
                            color: Color(0xffe4e4e4),
                          ),
                        ),
                        Text(
                          OrLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: b * 12,
                            color: Color(0xffe4e4e4),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: b * 10),
                            height: 1,
                            color: Color(0xffe4e4e4),
                          ),
                        ),
                      ],
                    ),
                    sh(18),
                    MaterialButton(
                      onPressed: () {},
                      padding: EdgeInsets.symmetric(vertical: h * 15),
                      elevation: 0,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: Color(0xff395185),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/fb-icon.png',
                            height: h * 17,
                            width: b * 17,
                          ),
                          sb(18),
                          Text(
                            LoginwithFacebookLabel,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: b * 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    sh(20),
                    MaterialButton(
                      onPressed: () {},
                      padding: EdgeInsets.symmetric(vertical: h * 15),
                      elevation: 0,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: borderColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google-icon.png',
                            height: h * 17,
                            width: b * 17,
                          ),
                          sb(18),
                          Text(
                            LoginwithGoogleLabel,
                            style: TextStyle(
                              fontSize: b * 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    sh(20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        DontAccountLabel,
                        style: TextStyle(
                          fontSize: b * 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          ' $SignUpLabel',
                          style: TextStyle(
                            fontSize: b * 14,
                            fontWeight: FontWeight.w700,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ]),
                    sh(30),
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
