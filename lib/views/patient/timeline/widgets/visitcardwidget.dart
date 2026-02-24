import 'package:Azunii_Health/consts/assets.dart';
import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/timeline_model.dart';

class VisitCard extends StatelessWidget {
  final TimelineEvent event;
  final VoidCallback? onDetailsTap;

  const VisitCard({super.key, required this.event, this.onDetailsTap});

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
          // Top row: Avatar + Name/specialty + Date
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.cardGray,
                backgroundImage: const AssetImage(AppAssets.profile),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_capitalize(event.title)}${event.subtitle != null ? ' (${event.subtitle})' : ''}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.headingTextColor,
                  ),
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
          const Divider(thickness: 0.5),

          // Info row: Reason, Findings, Plan
          if (event.notes != null && event.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoChip(
                    'Reason:', _extractField(event.notes!, 'reason')),
                //const SizedBox(width: 8),
                //   _buildInfoChip('Findings:', _extractField(event.notes!, 'findings')),
                // const SizedBox(width: 8),
                // _buildInfoChip('Plan:', _extractField(event.notes!, 'plan')),
              ],
            ),
          ],

          const SizedBox(height: 12),
          // Bottom row: Active status + Details button
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
                      'Active',
                      fontSize: 11,
                      color: AppColors.green,
                    ),
                  ],
                )
              else
                const SizedBox(),
              GestureDetector(
                onTap: onDetailsTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Details',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              color: AppColors.headingTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                color: AppColors.textColor,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Try to extract structured fields from notes. If the notes don't have
  /// structured format, just use the full text for "Reason" and show dashes
  /// for the rest.
  String _extractField(String notes, String field) {
    // Simple extraction: if notes contain "Reason:", "Findings:", "Plan:" prefixes
    // Otherwise fall back to showing the notes as the reason
    final lower = notes.toLowerCase();
    if (field == 'reason') {
      if (lower.contains('reason:')) {
        return _extractBetween(notes, 'reason:', ['findings:', 'plan:']);
      }
      return notes.length > 20 ? '${notes.substring(0, 20)}...' : notes;
    } else if (field == 'findings') {
      if (lower.contains('findings:')) {
        return _extractBetween(notes, 'findings:', ['plan:']);
      }
      return '—';
    } else if (field == 'plan') {
      if (lower.contains('plan:')) {
        return _extractBetween(notes, 'plan:', []);
      }
      return '—';
    }
    return '—';
  }

  String _extractBetween(String text, String startKey, List<String> endKeys) {
    final lower = text.toLowerCase();
    final startIdx = lower.indexOf(startKey.toLowerCase());
    if (startIdx == -1) return '—';
    int start = startIdx + startKey.length;
    int end = text.length;
    for (final key in endKeys) {
      final idx = lower.indexOf(key.toLowerCase(), start);
      if (idx != -1 && idx < end) {
        end = idx;
      }
    }
    return text.substring(start, end).trim();
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
