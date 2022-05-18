import 'package:flutter/material.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool isPressed = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: b * 28, vertical: h * 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: b * 7),
                    width: b * 30,
                    height: b * 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffc4c4c4).withOpacity(0.4),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: b * 16,
                    ),
                  ),
                ),
                sh(15),
                Center(
                  child: Image.asset(
                    'assets/images/forgot_illus_2.png',
                    height: h * 151,
                    width: b * 252,
                  ),
                ),
                sh(50),
                Text(
                  ResetPasswordLabel,
                  style: TextStyle(
                    fontSize: b * 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                sh(30),
                AppTextField(
                  label: EnterRegisterEmail,
                  controller: emailController,
                  suffix: null,
                  isVisibilty: null,
                  validator: (value) {
                    Pattern emailPattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(emailPattern.toString());
                    if (value!.isEmpty) {
                      return FieldEmptyError;
                    } else if ((!regex.hasMatch(value.trim()))) {
                      return ValidEmailLabel;
                    } else
                      return null;
                  },
                ),
                sh(20),
                Center(
                  child: isPressed
                      ? LoadingButton()
                      : AppButton(
                          label: SubmitLabel,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isPressed = true;
                              });

                              appSnackBar(
                                context: context,
                                msg: ResetLinkSentMsg,
                                isError: false,
                              );
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
