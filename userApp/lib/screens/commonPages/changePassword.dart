import 'package:flutter/material.dart';
import 'package:thrifty_cab/utils/appBar.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confPwdController = TextEditingController();
  TextEditingController curPwdController = TextEditingController();

  bool isError = false;
  bool isError1 = false;
  bool isError2 = false;

  bool isMisMatch = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressed = false;
  resetPassword() async {
    isPressed = true;
    setState(() {});
    appSnackBar(
      context: context,
      msg: PassChangeSuccess,
      isError: false,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      appBar: appBarCommon(context, h, b, ChangePassLabel),
      body: Column(children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: b * 15),
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    sh(40),
                    Image.asset(
                      'assets/images/change_pass.png',
                      height: h * 165,
                      width: b * 142,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(top: h * 20),
                      padding:
                          EdgeInsets.fromLTRB(b * 15, h * 20, b * 15, h * 20),
                      child: Column(
                        children: [
                          sh(20),
                          AppTextFieldPassword(
                            label: CurPassLabel,
                            controller: curPwdController,
                            isMisMatch: false,
                            error: isError2,
                            validator: (val) {
                              if (curPwdController.text.trim() == "") {
                                setState(() {
                                  isError2 = true;
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
                          AppTextFieldPassword(
                            label: NewPassword,
                            controller: newPwdController,
                            isMisMatch: isMisMatch,
                            error: isError,
                            validator: (val) {
                              if (newPwdController.text.trim() == "") {
                                setState(() {
                                  isMisMatch = false;
                                  isError = true;
                                });
                                return FieldEmptyError;
                              } else if (confPwdController.text !=
                                  newPwdController.text) {
                                setState(() {
                                  isMisMatch = true;
                                  isError = true;
                                });
                                return PasswordMatchError;
                              } else {
                                setState(() {
                                  isError = false;
                                  isMisMatch = false;
                                });
                                return null;
                              }
                            },
                          ),
                          sh(20),
                          AppTextFieldPassword(
                            label: CnfmPasswordLabel,
                            isMisMatch: isMisMatch,
                            controller: confPwdController,
                            error: isError1,
                            validator: (val) {
                              if (confPwdController.text.trim() == "") {
                                setState(() {
                                  isError1 = true;
                                  isMisMatch = false;
                                });
                                return FieldEmptyError;
                              } else if (confPwdController.text !=
                                  newPwdController.text) {
                                setState(() {
                                  isMisMatch = true;
                                  isError1 = true;
                                });
                                return PasswordMatchError;
                              } else {
                                setState(() {
                                  isMisMatch = false;
                                  isError1 = false;
                                });
                                return null;
                              }
                            },
                          ),
                          sh(30),
                          AppButton(
                            label: ChangePassLabel.toUpperCase(),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              if (newPwdController.text.trim().length < 6 ||
                                  newPwdController.text.trim().length > 14) {
                                setState(() {
                                  isPressed = false;
                                });
                                appSnackBar(
                                  context: context,
                                  msg: PasswordLengthErrorLabel,
                                  isError: true,
                                );
                              } else {
                                resetPassword();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
