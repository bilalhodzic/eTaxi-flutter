import 'package:flutter/material.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/screens/commonPages/login.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/activate_email_dialog.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confPwdController = TextEditingController();

  bool isPwdVisible = false;
  bool isConfVisible = false;

  bool isPressed = false;

  bool isError = false;
  bool isError1 = false;

  bool isMisMatch = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    // ignore: unused_local_variable
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sh(10),
              TextButton(
                onPressed: () {
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
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: b * 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sh(20),
                      Text(
                        CreateAccountLbl,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: b * 24,
                          letterSpacing: 0.5,
                        ),
                      ),
                      sh(30),
                      AppTextField(
                        label: NameLabel,
                        controller: nameController,
                        suffix: null,
                        isVisibilty: null,
                        validator: (val) {
                          if (nameController.text.trim() == "")
                            return FieldEmptyError;
                          else
                            return null;
                        },
                      ),
                      sh(20),
                      AppTextField(
                        label: EmailLabel,
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
                      AppTextField(
                        label: PhoneNoLabel,
                        controller: phoneController,
                        maxLength: 10,
                        suffix: Text(
                          "+91",
                          style: TextStyle(
                            fontSize: b * 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        isVisibilty: null,
                        inputType: TextInputType.number,
                        validator: (val) {
                          if (phoneController.text.trim() == "")
                            return FieldEmptyError;
                          else if (phoneController.text.length != 10)
                            return "* Enter a valid number";
                          else
                            return null;
                        },
                      ),
                      sh(20),
                      AppTextFieldPassword(
                        label: PasswordLabel,
                        controller: pwdController,
                        isMisMatch: isMisMatch,
                        error: isError,
                        validator: (val) {
                          if (pwdController.text.trim() == "") {
                            isError = true;
                            setState(() {});
                            return FieldEmptyError;
                          } else if (confPwdController.text !=
                              pwdController.text) {
                            setState(() {
                              isMisMatch = true;
                              isError = true;
                            });
                            return PasswordMatchError;
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
                        label: CnfmPasswordLabel,
                        isMisMatch: isMisMatch,
                        controller: confPwdController,
                        error: isError1,
                        validator: (val) {
                          if (confPwdController.text.trim() == "") {
                            setState(() {
                              isError1 = true;
                            });
                            return FieldEmptyError;
                          } else if (confPwdController.text !=
                              pwdController.text) {
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
                      sh(20),
                      isPressed
                          ? LoadingButton()
                          : AppButton(
                              label: RegisterLabel,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) return;
                                if (pwdController.text.trim().length < 6 ||
                                    pwdController.text.trim().length > 14) {
                                  appSnackBar(
                                    context: context,
                                    msg: PasswordLengthErrorLabel,
                                    isError: true,
                                  );
                                } else {
                                  isPressed = true;
                                  setState(() {});

                                  try {
                                    await dialogBoxActivationLinkSent(context);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(
                                            fromRoot: true,
                                          ),
                                        ),
                                        (route) => false);
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
                              },
                            ),
                      sh(15),
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
                      sh(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AlreadyAcountLabel + " ",
                            style: TextStyle(
                              fontSize: b * 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              LoginLabel,
                              style: TextStyle(
                                fontSize: b * 14,
                                color: secondaryColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          )
                        ],
                      ),
                      sh(30),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
