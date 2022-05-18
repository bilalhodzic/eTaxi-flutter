import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_cab/models/directions_model.dart';
import 'package:thrifty_cab/providers/taxi/app_flow_provider.dart';
import 'package:thrifty_cab/services.dart/directions_services.dart';
import 'package:thrifty_cab/utils/api_keys.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';

class PickUpSheet extends StatefulWidget {
  const PickUpSheet({Key? key}) : super(key: key);

  @override
  _PickUpSheetState createState() => _PickUpSheetState();
}

class _PickUpSheetState extends State<PickUpSheet> {
  Marker? pickMarker;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final h = MediaQuery.of(context).size.height / 812;
    final b = MediaQuery.of(context).size.width / 375;

    final appProvider = Provider.of<AppFlowProvider>(context);
    final local = appProvider.taxiMode == TaxiMode.Local;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: b * 20,
        vertical: h * 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  appProvider.changeTaxiMode(TaxiMode.Local);
                },
                child: Container(
                  width: b * 76,
                  padding: EdgeInsets.symmetric(vertical: h * 8),
                  decoration: BoxDecoration(
                    color: local ? primaryColor : Color(0xfff9f9f9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/local_car.png',
                        width: b * 40,
                      ),
                      sh(4),
                      Text(
                        LocalLabel,
                        style: TextStyle(
                          fontSize: b * 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sb(25),
              InkWell(
                onTap: () {
                  appProvider.changeTaxiMode(TaxiMode.OutStation);
                },
                child: Container(
                  width: b * 76,
                  padding: EdgeInsets.symmetric(vertical: h * 8),
                  decoration: BoxDecoration(
                    color: local ? Color(0xfff9f9f9) : primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/outstation_car.png',
                        width: b * 40,
                      ),
                      sh(4),
                      Text(
                        OutstationLabel,
                        style: TextStyle(
                          fontSize: b * 12,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          sh(25),
          Container(
            decoration: allBoxDecoration,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    if (appProvider.currentAdd != null) {
                      LocationResult? result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            GoogleMapApiKey,
                          ),
                        ),
                      );

                      if (result != null) if (result.latLng != null) {
                        await appProvider.setDestinationLoc(
                            result.latLng!, result.formattedAddress!);

                        Directions? dir = await DirectionServices()
                            .getDirections(
                                origin: appProvider.currentLoc!,
                                dest: result.latLng!);

                        if (dir != null) await appProvider.setDirections(dir);
                      }
                    } else
                      appSnackBar(
                          context: context,
                          msg: ChooseStartingMsg,
                          isError: true);
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      height: h * 50,
                      decoration: BoxDecoration(
                        color: Color(0xfff3f3f3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          sb(14),
                          Expanded(
                            child: Text(
                              appProvider.destAdd == null ||
                                      appProvider.destAdd == ''
                                  ? SearchDestLabel
                                  : appProvider.destAdd!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: b * 12,
                              ),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
          sh(16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: b * 30,
              vertical: h * 20,
            ),
            decoration: allBoxDecoration,
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      InviteLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: b * 12,
                      ),
                    ),
                    sh(20),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text: "GHPJHY09818",
                        )).then((_) {
                          appSnackBar(
                            context: context,
                            msg: CodeCopyLabel,
                            isError: false,
                          );
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: b * 16, vertical: h * 9),
                        decoration: BoxDecoration(
                          color: Color(0xfff3f3f3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "GHPJHY09818",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: b * 12,
                            letterSpacing: 0.65,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
                Image.asset(
                  'assets/images/invite_illus.png',
                  width: b * 90,
                ),
              ],
            ),
          ),
          sh(15),
          AppButton(
            label: ProceedLabel,
            onPressed: () async {
              if (appProvider.destAdd != null) {
                await Provider.of<AppFlowProvider>(context, listen: false)
                    .changeBookingStage(BookingStage.Destination);
              } else
                appSnackBar(
                    context: context, msg: ChooseDestinationMsg, isError: true);
            },
          )
        ],
      ),
    );
  }
}
