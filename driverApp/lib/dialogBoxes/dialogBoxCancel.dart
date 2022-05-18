import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';
import 'package:thrifty_cab_driver/widgets/app_button.dart';
import 'package:thrifty_cab_driver/widgets/app_snackBar.dart';

class DialogBoxCancel extends StatefulWidget {
  @override
  _DialogBoxCancelState createState() => _DialogBoxCancelState();
}

class _DialogBoxCancelState extends State<DialogBoxCancel> {
  TextEditingController reasonController = TextEditingController();
  var outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: borderColor,
    ),
  );

  List reasons = [
    "Drop Location not preferred",
    "Insufficient Fuel",
    "Less Fare Calculated",
    "Not Available",
    "Others",
  ];
  List values = [
    false,
    false,
    false,
    false,
    false,
  ];
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(b * 30, h * 30, b * 30, h * 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Cancel a Ride",
                style: TextStyle(
                  fontSize: b * 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              sh(15),
              Text(
                "Cancellation Reason",
                style: TextStyle(
                  fontSize: b * 12,
                  letterSpacing: 0.5,
                  color: Color(0xff3c3b3b),
                ),
              ),
              sh(15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    side: BorderSide(color: Color(0xffcccccc), width: b * 1),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                    value: values[0],
                    onChanged: (v) {
                      setState(() {
                        values[0] = v!;
                        values[1] = false;
                        values[2] = false;
                        values[3] = false;
                        values[4] = false;
                      });
                    },
                  ),
                  sb(8),
                  Text(
                    reasons[0],
                    style: TextStyle(
                      fontSize: b * 12,
                      color: values[0]
                          ? secondaryColor
                          : Colors.black.withOpacity(0.5),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    side: BorderSide(color: Color(0xffcccccc), width: b * 1),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                    value: values[1],
                    onChanged: (v) {
                      setState(() {
                        values[0] = false;
                        values[2] = false;
                        values[3] = false;
                        values[4] = false;
                        values[1] = v!;
                      });
                    },
                  ),
                  sb(8),
                  Text(
                    reasons[1],
                    style: TextStyle(
                      fontSize: b * 12,
                      color: values[1]
                          ? secondaryColor
                          : Colors.black.withOpacity(0.5),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    side: BorderSide(color: Color(0xffcccccc), width: b * 1),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                    value: values[2],
                    onChanged: (v) {
                      setState(() {
                        values[0] = false;
                        values[1] = false;
                        values[3] = false;
                        values[4] = false;

                        values[2] = v!;
                      });
                    },
                  ),
                  sb(8),
                  Text(
                    reasons[2],
                    style: TextStyle(
                      fontSize: b * 12,
                      color: values[2]
                          ? secondaryColor
                          : Colors.black.withOpacity(0.5),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    side: BorderSide(color: Color(0xffcccccc), width: b * 1),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                    value: values[3],
                    onChanged: (v) {
                      setState(() {
                        values[3] = v!;
                        values[0] = false;
                        values[1] = false;
                        values[2] = false;
                        values[4] = false;
                      });
                    },
                  ),
                  sb(8),
                  Text(
                    reasons[3],
                    style: TextStyle(
                      fontSize: b * 12,
                      color: values[3]
                          ? secondaryColor
                          : Colors.black.withOpacity(0.5),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    side: BorderSide(color: Color(0xffcccccc), width: b * 1),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                    value: values[4],
                    onChanged: (v) {
                      setState(() {
                        values[4] = v!;
                        values[0] = false;
                        values[1] = false;
                        values[2] = false;
                        values[3] = false;
                      });
                    },
                  ),
                  sb(8),
                  Text(
                    reasons[4],
                    style: TextStyle(
                      fontSize: b * 12,
                      color: values[4]
                          ? secondaryColor
                          : Colors.black.withOpacity(0.5),
                    ),
                  )
                ],
              ),
              values[4]
                  ? TextFormField(
                      style: TextStyle(
                        fontSize: b * 12,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: reasonController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Write your other reasons..",
                        hintStyle: TextStyle(
                          fontSize: b * 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: b * 15,
                          vertical: h * 12,
                        ),
                        focusedBorder: outlineInputBorder,
                        border: outlineInputBorder,
                        enabledBorder: outlineInputBorder,
                      ),
                    )
                  : sh(0),
              sh(15),
              isPressed
                  ? LoadingButton()
                  : AppButton(
                      vertPad: h * 10,
                      label: "CANCEL RIDE",
                      onPressed: () {
                        setState(() {
                          isPressed = true;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pop(context);
                          appSnackBar(
                            context: context,
                            msg: "The ride is successfully cancelled",
                            isError: false,
                          );
                        });
                      },
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}

void dialogBoxCancel(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return DialogBoxCancel();
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 300),
  );
}
