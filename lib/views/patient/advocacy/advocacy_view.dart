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
            _buildAppBar(context),
            Expanded(
              child: _buildCaregiverContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// App Bar with back button, title, and notification bell
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          // Title
          Expanded(
            child: Center(
              child: headline3(
                'Caregiver Access',
                color: AppColors.headingTextColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Notification bell
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.bellBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.bell,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
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
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCaregiverView()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            subText2(
              'Add Caregiver',
              color: AppColors.white,
              fontWeight: FontWeight.w500,
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
                radius: 24,
                backgroundColor: AppColors.dividerGray,
                backgroundImage: AssetImage(caregiver.profileImage),
              ),
              const SizedBox(width: 12),
              
              // Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText2(
                      caregiver.name,
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    subText3(
                      caregiver.role,
                      color: AppColors.textColor,
                      align: TextAlign.start,
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
                  onPressed: () {
                    _showDeleteDialog(caregiver);
                  },
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
          
          // Email and Added Date
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText3(
                      'Email: ${caregiver.email}',
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        subText3(
                          'Added on',
                          color: AppColors.textColor,
                          align: TextAlign.start,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.textColor,
                        ),
                        const SizedBox(width: 4),
                        subText3(
                          caregiver.addedDate,
                          color: AppColors.textColor,
                          align: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Permissions
          Wrap(
            spacing: 8,
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
      child: subText3(
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
          content: Text('Are you sure you want to remove ${caregiver.name} as a caregiver?'),
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
              child: const Text('Delete', style: TextStyle(color: AppColors.redColor)),
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