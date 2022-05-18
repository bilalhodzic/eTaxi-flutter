import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:thrifty_cab/models/vehicle_model.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/vehicle_tags.dart';

class DialogBoxDetail extends StatelessWidget {
  DialogBoxDetail(this.vehicle);

  final VehicleModel? vehicle;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: b * 20, vertical: h * 20),
                child: Row(
                  children: [
                    Text(
                      CarInfoLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: b * 14,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Container(
                color: borderColor,
                height: h * 2,
                width: SizeConfig.screenWidth,
              ),
              sh(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: b * 20),
                child: Wrap(
                  runSpacing: h * 5,
                  children: [
                    VehicleTags(txt: vehicle!.seater),
                    sb(6),
                    VehicleTags(txt: vehicle!.fuelType),
                    sb(6),
                    VehicleTags(txt: vehicle!.transmission),
                    sb(6),
                    vehicle!.airBags! == "No"
                        ? sh(0)
                        : VehicleTags(txt: AirBagLabel),
                    vehicle!.airBags! == "No" ? sh(0) : sb(6),
                    VehicleTags(txt: vehicle!.year),
                  ],
                ),
              ),
              sh(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: b * 20),
                child: Row(
                  children: [
                    Text(
                      LimitedLabel,
                      style: TextStyle(
                        fontSize: b * 12,
                        color: Color(0xff6666666),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Text(
                      vehicle!.isLimited != 'No'
                          ? vehicle!.limitedPrice!
                          : "No",
                      style: TextStyle(
                        fontSize: b * 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              sh(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: b * 20),
                child: Row(
                  children: [
                    Text(
                      UnLimitedLabel,
                      style: TextStyle(
                        fontSize: b * 12,
                        color: Color(0xff6666666),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Text(
                      vehicle!.isUnlimited != 'No'
                          ? vehicle!.unlimitedPrice!
                          : "No",
                      style: TextStyle(
                        fontSize: b * 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              sh(20),
            ],
          ),
        ],
      ),
    );
  }
}

void dialogBoxDetail(BuildContext context, VehicleModel vehicle) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return DialogBoxDetail(vehicle);
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 300),
  );
}
