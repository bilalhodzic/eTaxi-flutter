import 'dart:io';
import 'dart:typed_data';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thrifty_cab/main.dart';
import 'package:thrifty_cab/models/user_model.dart';
import 'package:thrifty_cab/models/vehicle_model.dart';
import 'package:thrifty_cab/providers/auth_provider.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/providers/user_provider.dart';
import 'package:thrifty_cab/screens/self%20drive/checkOut.dart';
import 'package:thrifty_cab/screens/staticPages/docPreview.dart';
import 'package:thrifty_cab/services.dart/storage_services.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:thrifty_cab/widgets/doc_dialog.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool? isBooking;
  final VehicleModel? vehicle;
  ProfileScreen({Key? key, @required this.isBooking, this.vehicle})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cophoneController = TextEditingController();
  String nationality = 'Indian';
  String selectedDoc = 'dom';
  List<File?> aadharFiles = [];
  List<File?> driveLicFiles = [];
  List<File?> overseasLic = [];
  List<File?> intLic = [];
  List<File?> passport = [];

  late Future<void> getNation;
  Userinfo? usr;

  bool isRead = true;
  bool isPressed = false;

  bool nationalitySelected = false;

  @override
  void initState() {
    super.initState();

    if (widget.isBooking!) {
      isRead = false;
    } else {
      isRead = true;
    }

    getNation =
        Provider.of<UserProvider>(context, listen: false).getNationality();

    final userProvider = Provider.of<AuthProvider>(context, listen: false);

    usr = userProvider.user;
    nameController.text = usr!.userName ?? "";
    addController.text = usr!.address ?? "";
    phoneController.text = usr!.phone ?? "";
    if (usr!.phone == 'null') {
      phoneController.text = '';
    }
    if (usr!.docType != 'null') {
      selectedDoc = usr!.docType == '1' ? 'dom' : 'intl';
    } else {
      selectedDoc = 'dom';
    }

    nationality = usr!.nationality ?? "Indian";
    if (usr!.nationality == 'null') {
      nationality = 'Indian';
      nationalitySelected = false;
    }

    if (usr!.nationality != 'null' && usr!.nationality != null) {
      nationalitySelected = true;
    }
    if (usr!.address == '') {
      loadFilesInitial();
    }

    loadFiles();
  }

  loadFilesInitial() async {
    for (int i = 0; i < 4; i++) {
      aadharFiles.add(
        File.fromRawPath(
          Uint8List.fromList([0]),
        ),
      );
    }
    for (int i = 0; i < 4; i++) {
      driveLicFiles.add(
        File.fromRawPath(
          Uint8List.fromList([0]),
        ),
      );
      for (int i = 0; i < 4; i++)
        overseasLic.add(
          File.fromRawPath(
            Uint8List.fromList([0]),
          ),
        );

      for (int i = 0; i < 4; i++)
        intLic.add(
          File.fromRawPath(
            Uint8List.fromList([0]),
          ),
        );

      for (int i = 0; i < 4; i++)
        passport.add(
          File.fromRawPath(
            Uint8List.fromList([0]),
          ),
        );
    }
    if (mounted) {
      setState(() {});
    }
  }

  loadFiles() async {
    if (usr!.docType == '1') {
      aadharFiles = [];
      driveLicFiles = [];
      for (int i = 0; i < 4; i++) {
        aadharFiles.add(
          await StorageServices.getDocFromLocal(
                  fileName:
                      StorageServices.aadharFileName + "${i.toString()}") ??
              File.fromRawPath(
                Uint8List.fromList([0]),
              ),
        );
      }
      for (int i = 0; i < 4; i++) {
        driveLicFiles.add(
          await StorageServices.getDocFromLocal(
                  fileName: (StorageServices.driveLicFileName + "$i")) ??
              File.fromRawPath(
                Uint8List.fromList([0]),
              ),
        );
      }
    } else if (usr!.docType == '0') {
      overseasLic = [];
      intLic = [];
      passport = [];
      for (int i = 0; i < 4; i++)
        overseasLic.add(
          await StorageServices.getDocFromLocal(
                  fileName: StorageServices.overseasLicFileName + '$i') ??
              File.fromRawPath(
                Uint8List.fromList([0]),
              ),
        );

      for (int i = 0; i < 4; i++)
        intLic.add(
          await StorageServices.getDocFromLocal(
                  fileName: StorageServices.intLicFileName + '$i') ??
              File.fromRawPath(
                Uint8List.fromList([0]),
              ),
        );

      for (int i = 0; i < 4; i++)
        passport.add(
          await StorageServices.getDocFromLocal(
                  fileName: StorageServices.passportFileName + '$i') ??
              File.fromRawPath(
                Uint8List.fromList([0]),
              ),
        );
    }
    if (mounted) {
      setState(() {});
    }
  }

  onChangeDropdownTests(selectedTest) {
    setState(() {
      nationality = selectedTest;
    });
  }

  Future<void> saveProfile() async {
    if (!fieldValidate()) {
      isPressed = false;
      setState(() {});
      return;
    }

    usr!.userName = nameController.text.trim();
    usr!.address = addController.text.trim();
    usr!.phone = phoneController.text.trim();
    usr!.nationality = nationality;
    usr!.docType = selectedDoc == 'dom' ? '1' : '0';
    nationalitySelected = true;

    await Provider.of<AuthProvider>(context, listen: false)
        .setUserFromLocal(usr!);

    try {
      if (selectedDoc == 'dom') {
        await Provider.of<UserProvider>(context, listen: false).updateProfile(
          user: usr,
          aadhar: aadharFiles,
          driveLic: driveLicFiles,
        );
      } else
        await Provider.of<UserProvider>(context, listen: false).updateProfile(
          user: usr,
          overseasLic: overseasLic,
          intLic: intLic,
          passport: passport,
        );
    } catch (e) {
      appSnackBar(context: context, msg: e.toString(), isError: true);
      print(e);
    } finally {
      isPressed = false;
      setState(() {});

      if (widget.isBooking!)
        continueToBook();
      else {
        setState(() {
          isRead = true;
        });
      }
    }
  }

  continueToBook() async {
    if (usr!.docType == '1') {
      await Provider.of<BookingProvider>(context, listen: false)
          .setFile(0, aadharFiles);

      await Provider.of<BookingProvider>(context, listen: false)
          .setFile(1, driveLicFiles);
    } else if (usr!.docType == '0') {
      await Provider.of<BookingProvider>(context, listen: false)
          .setFile(2, overseasLic);

      await Provider.of<BookingProvider>(context, listen: false)
          .setFile(3, intLic);

      await Provider.of<BookingProvider>(context, listen: false)
          .setFile(4, passport);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckOut(
          vehicle: widget.vehicle,
          coPassanger: cophoneController.text.trim(),
        ),
      ),
    );
  }

  bool fieldValidate() {
    if (selectedDoc == 'dom') {
      int aCount = aadharFiles.where((ele) {
        return ele!.path == '' ? true : false;
      }).length;

      int dCount = driveLicFiles.where((ele) {
        return ele!.path == '' ? true : false;
      }).length;

      if (aCount == 4 || dCount == 4) {
        appSnackBar(context: context, msg: DocMissingError, isError: true);
        return false;
      }
    } else if (selectedDoc == 'intl') {
      int oCount = overseasLic.where((ele) {
        return ele!.path == '' ? true : false;
      }).length;

      int iCount = intLic.where((ele) {
        return ele!.path == '' ? true : false;
      }).length;

      int pCount = passport.where((ele) {
        return ele!.path == '' ? true : false;
      }).length;

      if (oCount == 4 || iCount == 4 || pCount == 4) {
        appSnackBar(context: context, msg: DocMissingError, isError: true);
        return false;
      }
    }

    return true;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    final profileProvider = Provider.of<UserProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    final userProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: (widget.isBooking == true || isRead)
            ? Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
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
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: h * 22,
                    horizontal: b * 20,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: b * 18,
                    color: Colors.transparent,
                  ),
                ),
              ),
        title: Text(
          ProfileLabel,
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
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: widget.isBooking != null && widget.isBooking == false
                ? isRead
                    ? InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isRead = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: h * 22,
                            horizontal: b * 20,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/edit_icon.svg',
                            color: Colors.black,
                            width: b * 20,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          loadFiles();
                          setState(() {
                            isRead = true;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: h * 22,
                            horizontal: b * 20,
                          ),
                          child: Icon(
                            Icons.cancel,
                            size: b * 22,
                          ),
                        ),
                      )
                : sh(0),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sh(41),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: b * 25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              label: FullName,
                              readOnly: isRead,
                              controller: nameController,
                              suffix: null,
                              size: b * 12,
                              spacing: 0.6,
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
                              label: AddresseLabel,
                              controller: addController,
                              suffix: null,
                              readOnly: isRead,
                              maxLines: 20,
                              minLines: 4,
                              vertPad: h * 10,
                              size: b * 12,
                              spacing: 0.6,
                              isVisibilty: null,
                              validator: (val) {
                                if (addController.text.trim() == "")
                                  return FieldEmptyError;
                                else
                                  return null;
                              },
                            ),
                            sh(20),
                            Text(
                              EmailLabel,
                              style: TextStyle(
                                color: !isRead
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.black,
                                fontSize: b * 14,
                              ),
                            ),
                            sh(10),
                            Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.symmetric(
                                horizontal: b * 15,
                                vertical: h * 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: borderColor,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                usr!.emailid!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: b * 12,
                                  color: !isRead
                                      ? Colors.black.withOpacity(0.5)
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            sh(20),
                            Text(
                              MobileNumberLabel,
                              style: TextStyle(
                                fontSize: b * 14,
                              ),
                            ),
                            sh(10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: b * 12,
                                vertical: h * 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              width: SizeConfig.screenWidth,
                              child: Row(
                                children: [
                                  Container(
                                    width: b * 19,
                                    height: h * 19,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          CountryCode(
                                            name: "भारत",
                                            code: "IN",
                                            dialCode: "+91",
                                            flagUri: 'flags/in.png',
                                          ).flagUri!,
                                          package: 'country_code_picker',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  sb(10),
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: isRead,
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: b * 12,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusColor: primaryColor,
                                      ),
                                      validator: (val) {
                                        if (phoneController.text.trim() == "")
                                          return FieldEmptyError;
                                        else if (phoneController.text.length !=
                                            10)
                                          return "* Enter a valid number";
                                        else
                                          return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            sh(20),
                            widget.isBooking!
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        CoPassMobileNumberLabel,
                                        style: TextStyle(
                                          fontSize: b * 14,
                                        ),
                                      ),
                                      sh(10),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: b * 12,
                                          vertical: h * 10,
                                        ),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: borderColor),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        width: SizeConfig.screenWidth,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: b * 19,
                                              height: h * 19,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    CountryCode(
                                                      name: "भारत",
                                                      code: "IN",
                                                      dialCode: "+91",
                                                      flagUri: 'flags/in.png',
                                                    ).flagUri!,
                                                    package:
                                                        'country_code_picker',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            sb(10),
                                            Expanded(
                                              child: TextFormField(
                                                readOnly: isRead,
                                                controller: cophoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                maxLength: 10,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: b * 12,
                                                ),
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  isDense: true,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusColor: primaryColor,
                                                ),
                                                validator: (val) {
                                                  if (cophoneController.text
                                                          .trim() ==
                                                      "")
                                                    return FieldEmptyError;
                                                  else if (cophoneController
                                                          .text.length !=
                                                      10)
                                                    return "* Enter a valid number";
                                                  else
                                                    return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : sh(0),
                            sh(20),
                            Text(
                              Nationality,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: b * 14,
                              ),
                            ),
                            sh(10),
                            Container(
                              width: SizeConfig.screenWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: FutureBuilder(
                                future: getNation,
                                builder: (context, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.done)
                                    return (!isRead && !nationalitySelected)
                                        ? DropdownBelow(
                                            boxHeight: h * 36,
                                            itemWidth:
                                                SizeConfig.screenWidth - b * 50,
                                            itemTextstyle: TextStyle(
                                              fontSize: b * 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            boxPadding: EdgeInsets.fromLTRB(
                                              b * 14,
                                              h * 0,
                                              b * 10,
                                              h * 0,
                                            ),
                                            boxTextstyle: TextStyle(
                                              fontSize: b * 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            boxWidth:
                                                SizeConfig.screenWidth - b * 50,
                                            icon: SvgPicture.asset(
                                              'assets/icons/drop_down_icon.svg',
                                              height: h * 6,
                                            ),
                                            hint: Text(
                                              nationality == Nationality
                                                  ? Nationality
                                                  : nationality,
                                              style: TextStyle(
                                                fontSize: b * 12,
                                                letterSpacing: 0.6,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            value: null,
                                            items: profileProvider.nationalities
                                                .map((e) {
                                              return DropdownMenuItem<String?>(
                                                child: Text(e!),
                                                value: e,
                                              );
                                            }).toList(),
                                            onChanged: (String? val) {
                                              print(nationality);
                                              setState(() {
                                                nationality = val!;
                                                if (nationality != 'Indian') {
                                                  selectedDoc = 'intl';
                                                  profileProvider.setDocType(0);
                                                  bookingProvider.setDocType(0);
                                                } else {
                                                  selectedDoc = 'dom';
                                                  profileProvider.setDocType(1);
                                                  bookingProvider.setDocType(1);
                                                }
                                              });
                                            },
                                          )
                                        : InkWell(
                                            onTap: () {
                                              if (nationalitySelected &&
                                                  !isRead) {
                                                appSnackBar(
                                                  context: context,
                                                  msg:
                                                      NationalityCantChangeLabel,
                                                  isError: true,
                                                );
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: h * 36,
                                              padding: EdgeInsets.fromLTRB(
                                                b * 14,
                                                h * 0,
                                                b * 10,
                                                h * 0,
                                              ),
                                              child: Text(
                                                nationality,
                                                style: TextStyle(
                                                  fontSize: b * 12,
                                                  letterSpacing: 0.6,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                  else
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      height: h * 36,
                                    );
                                },
                              ),
                            ),
                            sh(20),
                            Text(
                              DocumentsLabel,
                              style: TextStyle(
                                fontSize: b * 14,
                              ),
                            ),
                            sh(16),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: h * 15, horizontal: b * 12),
                                  decoration: BoxDecoration(
                                    color: nationality == 'Indian'
                                        ? primaryColor
                                        : Colors.white,
                                    border: Border.all(
                                      color: nationality != 'Indian'
                                          ? borderColor
                                          : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    DomesticLabel,
                                    style: TextStyle(
                                      color: nationality == 'Indian'
                                          ? Colors.black
                                          : Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.6,
                                      fontSize: b * 12,
                                    ),
                                  ),
                                ),
                                sb(20),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: h * 15,
                                    horizontal: b * 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: nationality == 'Indian'
                                          ? borderColor
                                          : Colors.transparent,
                                    ),
                                    color: nationality != 'Indian'
                                        ? primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    InternationalLabel,
                                    style: TextStyle(
                                      color: nationality != 'Indian'
                                          ? Colors.black
                                          : Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.6,
                                      fontSize: b * 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            sh(20),
                          ]),
                    ),
                    selectedDoc != 'intl'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              docContainer(
                                label: AadhaarCardLabel,
                                file: aadharFiles,
                                fileCode: 0,
                              ),
                              docContainer(
                                  label: DrivingLicenseLabel,
                                  file: driveLicFiles,
                                  fileCode: 1),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              docContainer(
                                label: OverSeasDriveLbl,
                                file: overseasLic,
                                fileCode: 2,
                              ),
                              docContainer(
                                label: InternationalLicLbl,
                                file: intLic,
                                fileCode: 3,
                              ),
                              docContainer(
                                label: PassportLbl,
                                file: passport,
                                fileCode: 4,
                              ),
                            ],
                          ),
                    sh(20),
                    !isRead
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: b * 25),
                            child: isPressed
                                ? LoadingButton()
                                : AppButton(
                                    label: widget.isBooking!
                                        ? ContinueLabel
                                        : SaveLabel,
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        if (isPressed)
                                          return;
                                        else {
                                          isPressed = true;
                                          setState(() {});
                                        }

                                        if (userProvider.user!.docType ==
                                            null) {
                                          showAnimatedDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            barrierColor:
                                                Colors.black.withOpacity(0.3),
                                            animationType:
                                                DialogTransitionType.fadeScale,
                                            curve: Curves.fastOutSlowIn,
                                            duration:
                                                Duration(milliseconds: 300),
                                            builder: (context) {
                                              return DocWarningDialog(
                                                ctx: context,
                                                msg: selectedDoc == 'dom'
                                                    ? WarningDomestic
                                                    : WarningIntl,
                                                onYesPressed: () {
                                                  Navigator.of(navigatorKey
                                                          .currentContext!)
                                                      .pop();
                                                  saveProfile();
                                                },
                                              );
                                            },
                                          );

                                          return;
                                        }

                                        saveProfile();
                                      }
                                    },
                                  ),
                          )
                        : sh(0),
                    sh(40),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget docContainer(
      {@required String? label,
      @required List? file,
      @required int? fileCode}) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: b * 25),
          child: Text(
            label ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: b * 14,
            ),
          ),
        ),
        sh(usr!.address == '' && isRead ? 5 : 10),
        usr!.address == '' && isRead
            ? Padding(
                padding: EdgeInsets.only(left: b * 25),
                child: MaterialButton(
                  elevation: 0,
                  splashColor: Colors.white,
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.white,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(b * 5),
                  ),
                  onPressed: () {
                    setState(() {
                      isRead = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: h * 12,
                      horizontal: b * 38,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(b * 5),
                    ),
                    child: Text(
                      UploadLabel,
                      style: TextStyle(
                        fontSize: b * 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            : file!.isNotEmpty
                ? SizedBox(
                    height: h * 100,
                    width: SizeConfig.screenWidth,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: b * 25),
                      physics: BouncingScrollPhysics(),
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return file[index].path != '' || !isRead
                            ? fileContainer(
                                file[index],
                                fileCode.toString() + "$index",
                                label!,
                                h,
                              )
                            : sh(0);
                      },
                    ),
                  )
                : sh(0),
        sh(20),
      ],
    );
  }

  Widget fileContainer(File? file, String fileCode, String label, double h) {
    var b = SizeConfig.screenWidth / 375;

    return InkWell(
      onTap: () {
        (!isRead && file!.path == '')
            ? pickImage(fileCode)
            : file!.path != ''
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DocPreview(
                        photoUrl: file,
                        name: label,
                      ),
                    ),
                  )
                // ignore: unnecessary_statements
                : null;
      },
      child: SizedBox(
        height: h * 93,
        width: b * 138,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              height: h * 88,
              width: b * 138 - b * 5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(4),
                image: file!.path == ''
                    ? null
                    : DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      ),
              ),
              child: !isRead && file.path == ''
                  ? SvgPicture.asset(
                      'assets/icons/upload.svg',
                      height: h * 16,
                    )
                  : sh(0),
            ),
            !isRead && file.path != ''
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () async {
                        if (fileCode.startsWith('0')) {
                          aadharFiles[int.parse(fileCode[1])] =
                              File.fromRawPath(
                            Uint8List.fromList([0]),
                          );

                          aadharFiles = await rearrangeFileList(aadharFiles);
                        } else if (fileCode.startsWith('1')) {
                          driveLicFiles[int.parse(fileCode[1])] =
                              File.fromRawPath(
                            Uint8List.fromList([0]),
                          );

                          driveLicFiles =
                              await rearrangeFileList(driveLicFiles);
                        } else if (fileCode.startsWith('2')) {
                          overseasLic[int.parse(fileCode[1])] =
                              File.fromRawPath(
                            Uint8List.fromList([0]),
                          );

                          overseasLic = await rearrangeFileList(overseasLic);
                        } else if (fileCode.startsWith('3')) {
                          intLic[int.parse(fileCode[1])] = File.fromRawPath(
                            Uint8List.fromList([0]),
                          );

                          intLic = await rearrangeFileList(intLic);
                        } else if (fileCode.startsWith('4')) {
                          passport[int.parse(fileCode[1])] = File.fromRawPath(
                            Uint8List.fromList([0]),
                          );

                          passport = await rearrangeFileList(passport);
                        }
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: b * 10,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: b * 10,
                        ),
                      ),
                    ),
                  )
                : sh(0),
          ],
        ),
      ),
    );
  }

  Future<List<File?>> rearrangeFileList(List<File?> fileArray) async {
    List<File> files = [];

    for (int i = 0; i < 4; i++) {
      if (fileArray[i]!.path != '') files.add(fileArray[i]!);
    }

    for (int i = files.length; i < 4; i++) {
      files.add(
        File.fromRawPath(
          Uint8List.fromList([0]),
        ),
      );
    }

    return files;
  }

  pickImage(String fileCode) async {
    File? _selectedImage;
    final _selected = await _picker.pickImage(source: ImageSource.gallery);
    _selected != null
        ? _selectedImage = File(_selected.path)
        : _selectedImage = null;

    File? _cropped = await ImageCropper().cropImage(
      sourcePath: _selectedImage!.path,
      compressQuality: 80,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio5x4,
      ],
      androidUiSettings: settingUi,
      iosUiSettings: IOSUiSettings(
        title: "Edit Image",
      ),
    );

    File? _image;
    setState(() {
      _image = _cropped;
    });
    if (_image != null) {
      if (fileCode.startsWith('0')) {
        aadharFiles[int.parse(fileCode[1])] = File(_image!.path);
      } else if (fileCode.startsWith('1')) {
        driveLicFiles[int.parse(fileCode[1])] = File(_image!.path);
      } else if (fileCode.startsWith('2')) {
        overseasLic[int.parse(fileCode[1])] = File(_image!.path);
      } else if (fileCode.startsWith('3')) {
        intLic[int.parse(fileCode[1])] = File(_image!.path);
      } else if (fileCode.startsWith('4')) {
        passport[int.parse(fileCode[1])] = File(_image!.path);
      }
      setState(() {});
    }
  }

  var settingUi = AndroidUiSettings(
    toolbarTitle: EditImageLabel,
    toolbarColor: secondaryColor,
    statusBarColor: secondaryColor,
    toolbarWidgetColor: Colors.white,
    activeControlsWidgetColor: secondaryColor,
  );

  final _picker = ImagePicker();
}
