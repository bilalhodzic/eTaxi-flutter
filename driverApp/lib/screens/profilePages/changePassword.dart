import 'package:flutter/material.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/utils/strings.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';
import 'package:thrifty_cab_driver/widgets/app_snackBar.dart';
import 'package:thrifty_cab_driver/widgets/app_text_field.dart';

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
      msg: "Password changed successfully.",
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: h * 22,
              horizontal: b * 20,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: b * 18,
            ),
          ),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            fontSize: b * 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: buttonGradient,
          ),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: b * 15),
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Container(
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.only(top: h * 20),
                  padding: EdgeInsets.fromLTRB(b * 15, h * 20, b * 15, h * 20),
                  decoration: BoxDecoration(
                    boxShadow: boxShadow2,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(b * 4),
                  ),
                  child: Column(
                    children: [
                      sh(20),
                      AppTextFieldPassword(
                        label: "Current Password",
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
                        label: "CHANGE PASSWORD",
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
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
