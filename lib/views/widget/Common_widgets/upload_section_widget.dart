import 'dart:io';

import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts/lang.dart';

class UploadSectionWidget extends StatelessWidget {
  final IconData headerIcon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Rx<File?> selectedImage;

  const UploadSectionWidget({
    super.key,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardsColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  headerIcon,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText5(
                      title,
                      color: AppColors.headingTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    subText5(
                      subtitle,
                      color: AppColors.textColor,
                      fontSize: 13,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => selectedImage.value != null
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage.value!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.cloud_upload_outlined,
                            size: 25,
                            color: AppColors.textColor,
                          ),
                          const SizedBox(height: 16),
                          subText5(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            Lang.chooseFileOrDrag,
                            color: AppColors.headingTextColor,
                          ),
                          const SizedBox(height: 8),
                          subText5(
                            Lang.fileFormats,
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: AppColors.textColor,
                          ),
                        ],
                      ),
                    )),
            ),
          )
        ],
      ),
    );
  }
}
