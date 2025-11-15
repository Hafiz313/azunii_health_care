import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../text.dart';

class AppointmentCard extends StatelessWidget {
  final String date;
  final String doctor;
  final String reason;
  final String specialty;

  const AppointmentCard({
    super.key,
    required this.date,
    required this.doctor,
    required this.reason,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 232, 232, 232),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppAssets.calander,
                  width: 12,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                subText5(
                  fontSize: 12,
                  date,
                  color: AppColors.headingTextColor,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Doctor
          _buildAppointmentRow('Doctor', doctor),
          const SizedBox(height: 8),
          const Divider(color: AppColors.dividerGray, height: 1),
          const SizedBox(height: 8),
          // Reason to Visit
          _buildAppointmentRow('Reason to Visit', reason),
          const SizedBox(height: 8),
          const Divider(color: AppColors.dividerGray, height: 1),
          const SizedBox(height: 8),
          // Specialty
          _buildAppointmentRow('Specialty', specialty),
        ],
      ),
    );
  }

  Widget _buildAppointmentRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: subText5(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            label,
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
        ),
        Expanded(
          child: subText5(
            value,
            fontSize: 12,
            color: const Color.fromARGB(255, 53, 53, 53),
            align: TextAlign.end,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
