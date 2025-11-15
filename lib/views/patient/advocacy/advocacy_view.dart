import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/widget/Common_widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import 'add_caregiver_view.dart';

class AdvocacyView extends StatefulWidget {
  const AdvocacyView({super.key});

  @override
  State<AdvocacyView> createState() => _AdvocacyViewState();
}

class _AdvocacyViewState extends State<AdvocacyView> {
  final List<CaregiverModel> caregivers = [
    CaregiverModel(
      name: 'Sarah Johnson',
      role: 'Spouse',
      email: 'sarah@email.com',
      addedDate: '09-12-2025',
      profileImage: AppAssets.profile,
    ),
    CaregiverModel(
      name: 'Sarah Johnson',
      role: 'Spouse',
      email: 'sarah@email.com',
      addedDate: '09-12-2025',
      profileImage: AppAssets.profile,
    ),
    CaregiverModel(
      name: 'Sarah Johnson',
      role: 'Spouse',
      email: 'sarah@email.com',
      addedDate: '09-12-2025',
      profileImage: AppAssets.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Caregiver Access',
              onIconTap: () {},
            ),
            Expanded(
              child: _buildCaregiverContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// Caregiver Content
  Widget _buildCaregiverContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Add Caregiver Button
          _buildAddCaregiverButton(),

          const SizedBox(height: 24),

          // Caregiver Access Header
          subText2(
            'Caregiver Access',
            color: AppColors.headingTextColor,
            align: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 16),

          // Caregiver List
          ...caregivers.map((caregiver) => _buildCaregiverCard(caregiver)),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAddCaregiverButton() {
    return Container(
      width: context.screenWidth * 0.5,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCaregiverView()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            subText5(
              fontSize: 13,
              'Add Caregiver ',
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaregiverCard(CaregiverModel caregiver) {
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
          // Header with profile and delete button
          Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.dividerGray,
                backgroundImage: AssetImage(caregiver.profileImage),
              ),
              const SizedBox(width: 12),

              // Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText4(
                      caregiver.name,
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    subText5(
                      fontWeight: FontWeight.normal,
                      caregiver.role,
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),

              // Delete Button
              Container(
                width: context.screenWidth * 0.1,
                height: context.screenWidth * 0.1,
                decoration: BoxDecoration(
                  color: AppColors.lightRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    _showDeleteDialog(caregiver);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.redColor,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Email and Added Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              subText5(
                'Email: ${caregiver.email}',
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                align: TextAlign.start,
                fontSize: 11,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  subText5(
                    'Added on',
                    color: AppColors.textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColors.textColor,
                  ),
                  const SizedBox(width: 4),
                  subText5(
                    caregiver.addedDate,
                    fontSize: 11,
                    color: AppColors.textColor,
                    align: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Permissions
          Wrap(
            spacing: 5,
            runSpacing: 8,
            children: [
              _buildPermissionChip('View Records'),
              _buildPermissionChip('Add Notes'),
              _buildPermissionChip('View Appointments'),
            ],
          ),

          const SizedBox(height: 16),

          // Details Button
          SizedBox(
            width: 80,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                // Handle view details
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: subText3(
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

  Widget _buildPermissionChip(String permission) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.dividerGray, width: 1),
      ),
      child: subText5(
        permission,
        color: AppColors.textColor,
        align: TextAlign.center,
      ),
    );
  }

  void _showDeleteDialog(CaregiverModel caregiver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Caregiver'),
          content: Text(
              'Are you sure you want to remove ${caregiver.name} as a caregiver?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  caregivers.remove(caregiver);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.redColor)),
            ),
          ],
        );
      },
    );
  }
}

class CaregiverModel {
  final String name;
  final String role;
  final String email;
  final String addedDate;
  final String profileImage;

  CaregiverModel({
    required this.name,
    required this.role,
    required this.email,
    required this.addedDate,
    required this.profileImage,
  });
}
