import 'package:Azunii_Health/consts/colors.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';

class CaregiverCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String role;
  final String email;
  final String addedDate;
  final List<String> permissions;
  final VoidCallback onDelete;
  final VoidCallback onDetails;

  const CaregiverCard({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.role,
    required this.email,
    required this.addedDate,
    required this.permissions,
    required this.onDelete,
    required this.onDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Profile + Delete)
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.dividerGray,
                backgroundImage: AssetImage(profileImage),
              ),
              const SizedBox(width: 12),

              // Name + Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText5(
                      fontSize: 14,
                      name,
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 2),
                    subText5(
                      fontSize: 13,
                      role,
                      color: AppColors.textColor,
                      align: TextAlign.start,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              // Delete Button
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.lightRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.redColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Email + Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subText5(
                fontSize: 13,
                'Email: $email',
                color: AppColors.textColor,
                align: TextAlign.start,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  subText5(
                    fontSize: 13,
                    'Added on',
                    color: AppColors.textColor,
                    align: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColors.textColor,
                  ),
                  const SizedBox(width: 4),
                  subText5(
                    fontSize: 13,
                    addedDate,
                    color: AppColors.textColor,
                    align: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Permissions (Scrollable)
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: permissions.length,
              itemBuilder: (context, index) {
                return _PermissionChip(permission: permissions[index]);
              },
            ),
          ),

          const SizedBox(height: 16),

          // Details Button
          SizedBox(
            width: 100,
            height: 34,
            child: ElevatedButton(
              onPressed: onDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.zero,
              ),
              child: subText5(
                fontSize: 13,
                'Details',
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionChip extends StatelessWidget {
  final String permission;

  const _PermissionChip({Key? key, required this.permission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.dividerGray, width: 1),
      ),
      child: subText5(
        fontSize: 13,
        permission,
        color: AppColors.textColor,
        align: TextAlign.center,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
