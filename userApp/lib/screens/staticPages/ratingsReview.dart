import 'package:flutter/material.dart';
import 'package:thrifty_cab/screens/staticPages/ratings_success.dart';
import 'package:thrifty_cab/utils/appBar.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';

class RatingsReview extends StatefulWidget {
  final String? bookingId;
  RatingsReview({Key? key, required this.bookingId}) : super(key: key);

  @override
  _RatingsReviewState createState() => _RatingsReviewState();
}

class _RatingsReviewState extends State<RatingsReview> {
  final TextEditingController expController = TextEditingController();

  final TextEditingController serController = TextEditingController();

  final TextEditingController sugController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool good = true;

  bool vgood = false;

  bool exc = false;

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;

    return Scaffold(
      appBar: appBarCommon(context, h, b, RatingNReview),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: SizeConfig.screenWidth,
              decoration: constBoxDecoration,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: b * 30, right: b * 30),
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sh(30),
                      Text(
                        RateReviewExpLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: b * 18,
                          letterSpacing: 0.6,
                        ),
                      ),
                      sh(24),
                      Row(children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                good = true;
                                vgood = false;
                                exc = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: h * 10),
                              decoration: BoxDecoration(
                                color: good ? primaryColor : Colors.white,
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                GoodLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: b * 12,
                                  letterSpacing: 0.45,
                                  color: good
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        sb(4),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                good = false;
                                vgood = true;
                                exc = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: h * 10),
                              decoration: BoxDecoration(
                                color: vgood ? primaryColor : Colors.white,
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                VeryGoodLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: b * 12,
                                  letterSpacing: 0.45,
                                  color: vgood
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        sb(4),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                good = false;
                                vgood = false;
                                exc = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: h * 10),
                              decoration: BoxDecoration(
                                color: exc ? primaryColor : Colors.white,
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                ExcellentLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: b * 12,
                                  letterSpacing: 0.45,
                                  color: exc
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      sh(30),
                      AppTextField(
                        label: TellAboutBooking,
                        controller: expController,
                        suffix: null,
                        isVisibilty: null,
                        size: b * 12,
                        maxLines: 3,
                        minLines: 3,
                        vertPad: h * 13,
                        hint: WriteYourReview,
                        validator: (val) {
                          if (expController.text.trim() == "")
                            return FieldEmptyError;
                          else
                            return null;
                        },
                      ),
                      sh(20),
                      AppTextField(
                        label: MeetExpectationsLabel,
                        controller: serController,
                        suffix: null,
                        isVisibilty: null,
                        size: b * 12,
                        maxLines: 3,
                        minLines: 3,
                        vertPad: h * 13,
                        hint: WriteYourReview,
                        validator: (val) {
                          if (serController.text.trim() == "")
                            return FieldEmptyError;
                          else
                            return null;
                        },
                      ),
                      sh(20),
                      AppTextField(
                        label: ShareSuggestion,
                        controller: sugController,
                        suffix: null,
                        isVisibilty: null,
                        size: b * 12,
                        maxLines: 6,
                        minLines: 6,
                        vertPad: h * 13,
                        hint: WriteYourReview,
                        validator: (val) {
                          if (sugController.text.trim() == "")
                            return FieldEmptyError;
                          else
                            return null;
                        },
                      ),
                      sh(20),
                      isPressed
                          ? LoadingButton()
                          : AppButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isPressed = true;
                                  });

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RatingSuccessScreen(),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    isPressed = false;
                                  });
                                  appSnackBar(
                                    context: context,
                                    msg: FillDetailsLabel,
                                    isError: true,
                                  );
                                }
                              },
                              label: SubmitLabel,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
