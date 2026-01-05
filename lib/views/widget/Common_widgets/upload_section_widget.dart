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
  final RxString? existingImageUrl;

  const UploadSectionWidget({
    super.key,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.selectedImage,
    this.existingImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.cardsColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.lightBlueAccent, width: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    subText6(
                      subtitle,
                      color: AppColors.textColor,
                      //  fontSize: 12,
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
              child: Obx(() {
                // Show local file if selected
                if (selectedImage.value != null) {
                  return Container(
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
                  );
                }
                // Show network image if available
                else if (existingImageUrl != null && existingImageUrl!.value.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        existingImageUrl!.value,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.cardGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: AppColors.textColor,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.cardGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                // Show upload placeholder
                else {
                  return Container(
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
                  );
                }
              }),
            ),
          )
        ],
      ),
    );
  }
}