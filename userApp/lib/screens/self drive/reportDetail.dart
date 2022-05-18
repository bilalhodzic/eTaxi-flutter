import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thrifty_cab/models/report_model.dart';
import 'package:thrifty_cab/providers/booking_provider.dart';
import 'package:thrifty_cab/services.dart/preferences.dart';
import 'package:thrifty_cab/utils/appBar.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:provider/provider.dart';

class ReportDetail extends StatefulWidget {
  final int bookingID;
  ReportDetail({required this.bookingID});
  @override
  _ReportDetailState createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  final TextEditingController message = TextEditingController();

  Future<ReportModel?>? getReportData;
  late Timer timer;
  ReportModel? reportModel;

  List<File?> reportFiles = [];
  bool isPressed = false;
  int? uid;
  late int ticketID;

  @override
  void initState() {
    for (int i = 0; i < 4; i++) {
      reportFiles.add(
        File.fromRawPath(
          Uint8List.fromList([0]),
        ),
      );
    }

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    uid = await PreferencesUtils.getIntPref(PreferencesUtils.userId);

    getReportData =
        Provider.of<BookingProvider>(context, listen: false).getReportData();
    startFetchingData();

    super.didChangeDependencies();
  }

  startFetchingData() async {
    try {
      timer = Timer.periodic(Duration(seconds: 0), (tick) async {
        print("Fetching Data from Timer");
        ReportModel? tempReport =
            await Provider.of<BookingProvider>(context, listen: false)
                .getReportData();

        if (tempReport != null) {
          reportModel = tempReport;
          setState(() {});
        }
      });
    } catch (e) {
      print(e);
      appSnackBar(
        context: context,
        msg: GenericError,
        isError: true,
      );
    }
  }

  sendReply() async {
    try {
      String rpl = message.text.trim();
      message.text = '';
      await Provider.of<BookingProvider>(context, listen: false)
          .sendReplyOnReport(ticketID: ticketID, reply: rpl, userID: uid!);

      ReportModel? tempReport =
          await Provider.of<BookingProvider>(context, listen: false)
              .getReportData();

      if (tempReport != null) {
        reportModel = tempReport;
        setState(() {});
      }
      tolast(false);
    } catch (e) {
      print(e);
      appSnackBar(context: context, msg: GenericError, isError: true);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarCommon(context, h, b, ReportLabel),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: SizeConfig.screenWidth,
              decoration: constBoxDecoration,
              child: Column(
                children: [
                  FutureBuilder(
                      future: getReportData,
                      builder: (context, AsyncSnapshot<ReportModel?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          ticketID = reportModel!.ticketId!;

                        if (!snapshot.hasData)
                          return Expanded(
                            child: Center(
                              child: SpinKitCircle(
                                color: primaryColor,
                              ),
                            ),
                          );
                        else
                          return Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: b * 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: SizeConfig.screenWidth,
                                    padding:
                                        EdgeInsets.symmetric(vertical: h * 20),
                                    margin: EdgeInsets.symmetric(
                                      vertical: h * 30,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xfff6f6f6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 20),
                                          child: Text(
                                            TitleLabel +
                                                ": " +
                                                reportModel!.title!,
                                            style: TextStyle(
                                              fontSize: b * 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                        sh(5),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 20),
                                          child: Text(
                                            BookingIdLabel +
                                                ": ${reportModel!.bookingId}",
                                            style: TextStyle(
                                              fontSize: b * 14,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                        sh(10),
                                        Container(
                                          color: borderColor,
                                          height: h * 1,
                                        ),
                                        sh(10),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 20),
                                          child: Text(
                                            DescriptionLabel,
                                            style: TextStyle(
                                              fontSize: b * 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                        sh(5),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 20),
                                          child: Text(
                                            reportModel!.description ?? "",
                                            style: TextStyle(
                                              fontSize: b * 14,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                        sh(10),
                                        Container(
                                          color: borderColor,
                                          height: h * 1,
                                        ),
                                        sh(10),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 20),
                                          child: Text(
                                            "Images",
                                            style: TextStyle(
                                              fontSize: b * 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                        sh(8),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: b * 20),
                                          child: Row(
                                            children: [
                                              if (reportModel!.images!.length >
                                                  0)
                                                imageContainer(
                                                  b,
                                                  h,
                                                  reportModel!.images![0],
                                                ),
                                              if (reportModel!.images!.length >
                                                  1)
                                                imageContainer(
                                                  b,
                                                  h,
                                                  reportModel!.images![1],
                                                ),
                                              if (reportModel!.images!.length >
                                                  2)
                                                imageContainer(
                                                  b,
                                                  h,
                                                  reportModel!.images![2],
                                                ),
                                              if (reportModel!.images!.length >
                                                  3)
                                                imageContainer(
                                                  b,
                                                  h,
                                                  reportModel!.images![3],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: reportModel!.replies!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: b * 10),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return messageContainer(
                                          b,
                                          h,
                                          "http://via.placeholder.com/350x150",
                                          reportModel!.replies![index]!
                                                      .userId ==
                                                  uid!
                                              ? true
                                              : false,
                                          reportModel!.replies![index]!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                      }),
                  Container(
                    color: Color(0xfff2f2f2),
                    height: h * 1,
                  ),
                  Container(
                    height: h * 60,
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.only(right: b * 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: TextField(
                              onTap: () {
                                tolast(true);
                              },
                              keyboardType: TextInputType.multiline,
                              controller: message,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: b * 16,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: b * 16,
                                ),
                                hintText: 'Type a message',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: h * 8,
                                  horizontal: b * 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (message.text.trim() == '') return;

                            await sendReply();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/send.svg',
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageContainer(double b, double h, String imgUrl) {
    return Padding(
      padding: EdgeInsets.only(right: b * 5),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        width: b * 61,
        height: h * 61,
        fit: BoxFit.fitWidth,
        imageBuilder: (context, imageProvider) => Container(
          width: b * 61,
          height: h * 61,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget messageContainer(
      double b, double h, String imgUrl, bool isSender, Replies reply) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isSender) Spacer(),
            !isSender
                ? CachedNetworkImage(
                    imageUrl: imgUrl,
                    width: b * 35,
                    height: h * 35,
                    fit: BoxFit.fitWidth,
                    imageBuilder: (context, imageProvider) => Container(
                      width: b * 35,
                      height: h * 35,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: b * 32 / 2,
                    backgroundColor: primaryColor,
                    child: Text(
                      getInitials(reply.userName!),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: b * 12,
                      ),
                    ),
                  ),
            sb(5),
            Text(
              reply.userName ?? "User",
              style: TextStyle(
                fontSize: b * 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        sh(10),
        Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: SizeConfig.screenWidth * 0.7,
              padding: EdgeInsets.symmetric(
                horizontal: b * 10,
                vertical: h * 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(b * 4),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                reply.reply ?? "",
                style: TextStyle(
                  fontSize: b * 12,
                  color: Color(0xff3a3a3a),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        sh(5),
        Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              dateFormatString(reply.timestamp!.split(' ').first),
              style: TextStyle(
                fontSize: b * 10,
                color: Colors.black.withOpacity(0.5),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        sh(10),
      ],
    );
  }

  ScrollController _scrollController = new ScrollController();
  void tolast(bool keyboard) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent +
            (keyboard ? SizeConfig.screenHeight * 0 : 0),
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1),
      );
    }
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';
}
