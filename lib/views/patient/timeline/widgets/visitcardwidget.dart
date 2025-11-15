import 'package:azunii_health_care/consts/assets.dart';
import 'package:azunii_health_care/consts/colors.dart';
import 'package:azunii_health_care/views/widget/buttons.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Model for Visit Detail Row
class VisitDetail {
  final String label;
  final String value;

  VisitDetail({required this.label, required this.value});
}

// Model for Visit
class Visit {
  final String doctorName;
  final String specialty;
  final String date;
  final List<VisitDetail> details; // List of reason, findings, plan, etc.
  final bool isActive;
  final VoidCallback? onDetailsPressed;

  Visit({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.details,
    this.isActive = true,
    this.onDetailsPressed,
  });
}

// Reusable VisitCard Widget
class VisitCard extends StatelessWidget {
  final Visit visit;

  const VisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with doctor info and date
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.cardGray,
                backgroundImage: const AssetImage(AppAssets.profile),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText4(
                      '${visit.doctorName} (${visit.specialty})',
                      color: AppColors.headingTextColor,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.calander,
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    subText5(
                      visit.date,
                      fontSize: 12,
                      color: AppColors.headingTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Dynamic details rows
          ...visit.details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildVisitDetailRow(detail),
            ),
          ),
          const SizedBox(height: 16),
          // Bottom row with Active status and Details button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (visit.isActive)
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    subText5(
                      fontSize: 13,
                      'Active',
                      color: AppColors.green,
                    ),
                  ],
                ),
              SizedBox(
                height: 36,
                child: AppElevatedButton(
                  onPressed: visit.onDetailsPressed,
                  title: 'Details',
                  backgroundColor: AppColors.primary,
                  width: 100,
                  height: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisitDetailRow(VisitDetail detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: subText5(
            detail.label,
            color: AppColors.textColor,
          ),
        ),
        Expanded(
          child: subText5(
            detail.value,
            color: AppColors.headingTextColor,
          ),
        ),
      ],
    );
  }
}
