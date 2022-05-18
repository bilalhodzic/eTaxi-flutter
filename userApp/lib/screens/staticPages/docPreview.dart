import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thrifty_cab/utils/app_texts.dart';
import 'package:thrifty_cab/utils/colors.dart';
import 'package:thrifty_cab/utils/sizeConfig.dart';
import 'package:photo_view/photo_view.dart';

class DocPreview extends StatelessWidget {
  final File? photoUrl;
  final String? name;
  final String? fileUrl;
  DocPreview({required this.photoUrl, this.name, this.fileUrl});

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: buttonGradient),
          child: Column(
            children: [
              AppBarText(
                txt: name,
                isBackButton: true,
                actionIcon: null,
              ),
              Expanded(
                child: PhotoView(
                  backgroundDecoration: BoxDecoration(
                    gradient: buttonGradient,
                  ),
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  imageProvider: FileImage(photoUrl!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
