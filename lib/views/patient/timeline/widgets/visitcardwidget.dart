import 'package:Azunii_Health/consts/assets.dart';
import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/timeline_model.dart';

class VisitCard extends StatelessWidget {
  final TimelineEvent event;

  const VisitCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isActive = event.status.toLowerCase() == 'active';
    final formattedDate = _formatTimestamp(event.timestamp);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${_capitalize(event.title)}${event.subtitle != null ? ' (${event.subtitle})' : ''}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.headingTextColor,
                      ),
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
                      width: 12,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    subText5(
                      formattedDate,
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: AppColors.headingTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.5,
          ),
          if (event.notes != null) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60,
                  child: Text('Notes:',
                      style: GoogleFonts.manrope(
                          color: AppColors.headingTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                ),
                Expanded(
                  child: Text(
                    event.notes!,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.manrope(
                        color: AppColors.headingTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isActive)
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    subText5(
                      fontSize: 11,
                      'Active',
                      color: AppColors.green,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (e) {
      return timestamp;
    }
  }
}
