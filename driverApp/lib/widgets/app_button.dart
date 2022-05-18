import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thrifty_cab_driver/utils/colors.dart';
import 'package:thrifty_cab_driver/utils/sizeConfig.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    @required this.label,
    this.width,
    @override this.onPressed,
    this.isShadow,
    this.vertPad,
  });

  final String? label;
  final double? width;
  final bool? isShadow;
  final double? vertPad;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: vertPad != null ? vertPad! : h * 16,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(b * 4),
        ),
        child: Text(
          label!.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1,
            fontSize: b * 12,
          ),
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key, this.width}) : super(key: key);

  final double? width;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Container(
      width: SizeConfig.screenWidth,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: h * 7),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(b * 5),
      ),
      child: SpinKitCircle(
        color: secondaryColor,
        size: b * 20,
      ),
    );
  }
}
