import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thrifty_cab/screens/self%20drive/homeMain.dart';
import 'package:thrifty_cab/screens/staticPages/docPreview.dart';
import 'package:thrifty_cab/utils/appBar.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:thrifty_cab/utils/strings.dart';
import 'package:thrifty_cab/widgets/app_button.dart';
import 'package:thrifty_cab/widgets/app_snackBar.dart';
import 'package:thrifty_cab/widgets/app_text_field.dart';

class ReportScreen extends StatefulWidget {
  final int bookingId;
  const ReportScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<File?> reportFiles = [];
  bool isPressed = false;
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      appBar: appBarCommon(context, h, b, ReportLabel),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sh(40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: b * 30),
                      child: AppTextField(
                        label: TitleLabel,
                        controller: titleController,
                        suffix: null,
                        size: b * 12,
                        isVisibilty: null,
                        hint: WriteTitleLabel,
                        validator: (val) {
                          if (titleController.text.trim() == "")
                            return FieldEmptyError;
                          else
                            return null;
                        },
                      ),
                    ),
                    sh(20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: b * 30),
                      child: AppTextField(
                        size: b * 12,
                        label: DescriptionLabel,
                        controller: desController,
                        suffix: null,
                        isVisibilty: null,
                        hint: WriteDesLabel,
                        maxLines: 5,
                        vertPad: h * 13,
                        minLines: 5,
                        validator: (val) {
                          if (desController.text.trim() == "")
                            return FieldEmptyError;
                          else
                            return null;
                        },
                      ),
                    ),
                    sh(20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: b * 30),
                      child: Text(
                        UploadImgLabel,
                        style: TextStyle(
                          fontSize: b * 14,
                        ),
                      ),
                    ),
                    sh(12),
                    docContainer(
                      file: reportFiles,
                      fileCode: 0,
                    ),
                    sh(20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: b * 30),
                      child: isPressed
                          ? LoadingButton()
                          : AppButton(
                              label: SubmitLabel,
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isPressed = true;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => HomeMain(index: 2),
                                    ),
                                  );
                                  appSnackBar(
                                    context: context,
                                    msg: ReportedSuccessLabel,
                                    isError: false,
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
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget docContainer({@required List? file, @required int? fileCode}) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: h * 100,
          width: SizeConfig.screenWidth,
          child: ListView.builder(
              padding: EdgeInsets.only(left: b * 25),
              physics: BouncingScrollPhysics(),
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return fileContainer(
                  file![index],
                  fileCode.toString() + "$index",
                  h,
                );
              }),
        ),
        sh(20),
      ],
    );
  }

  Widget fileContainer(File? file, String fileCode, double h) {
    var b = SizeConfig.screenWidth / 375;

    return InkWell(
      onTap: () {
        file!.path == ''
            ? pickImage(fileCode)
            : file.path != ''
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DocPreview(
                        photoUrl: file,
                        name: "Image",
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
              child: file.path == ''
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/upload.svg',
                          height: h * 16,
                          color: primaryColor,
                        ),
                        sh(3),
                        Text(
                          UploadImgLabel,
                          style: TextStyle(
                            letterSpacing: 0.6,
                            fontSize: b * 12,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    )
                  : sh(0),
            ),
            file.path != ''
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          reportFiles[int.parse(fileCode[1])] =
                              File.fromRawPath(
                            Uint8List.fromList([0]),
                          );
                        });
                      },
                      child: CircleAvatar(
                        radius: b * 10,
                        backgroundColor: secondaryColor,
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

  pickImage(String fileCode) async {
    File? _selectedImage;
    final _selected = await _picker.pickImage(source: ImageSource.gallery);
    _selected != null
        ? _selectedImage = File(_selected.path)
        : _selectedImage = null;

    File? _cropped = await ImageCropper().cropImage(
      sourcePath: _selectedImage!.path,
      compressQuality: 100,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio5x4,
      ],
      androidUiSettings: settingUi,
      iosUiSettings: IOSUiSettings(
        title: EditImageLabel,
      ),
    );

    setState(() {
      _image = _cropped;
    });
    if (_image != null) {
      reportFiles[int.parse(fileCode[1])] = File(_image!.path);
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
  File? _image;
}
