import 'package:Azunii_Health/consts/assets.dart';
import 'package:Azunii_Health/core/models/static_user_model.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/care_taker/feedback/feedback_view.dart';
import 'package:Azunii_Health/views/patient/privacy/privacy_policy_view.dart';
import 'package:Azunii_Health/views/patient/support/help_support_view.dart';
import 'package:Azunii_Health/views/patient/timeline/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../core/services/google_auth_service.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/quick_action_card.dart';
import '../../widget/Common_widgets/medication_alert_card.dart';
import '../../widget/Common_widgets/today_task_card.dart';
import '../../widget/Common_widgets/date_picker_button.dart';
import '../../widget/Common_widgets/appointment_card.dart';
import '../../widget/Common_widgets/overlayloader.dart';
import '../visits/visits_view.dart';
import '../medicines/medicines_view.dart';
import 'profile_view.dart';
import 'controller/home_controller.dart';
import '../../auth/login/login_view.dart';

class HomeView extends StatelessWidget {
  static const String routeName = '/HomeView';
  const HomeView({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Obx(() => OverlayLoader(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.white,
            drawer: _buildDrawer(context),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshData(),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      _buildQuickActions(context),
                      const SizedBox(height: 13),
                      // _buildMedicationAlert(context),
                      // const SizedBox(height: 13),
                      _buildAsOfTodaySection(context),
                      const SizedBox(height: 13),
                      _buildFutureAppointmentsSection(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  /// Top Header with logo, welcome text, and profile picture
  Widget _buildHeader(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        children: [
          Row(
            children: [
              // Menu Icon
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: Icon(Icons.menu),
              ),
              const SizedBox(width: 12),
              // Logo/Icon (R or ribbon icon)

              const SizedBox(width: 12),
              // Welcome text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    subText3(
                      Lang.welcome,
                      color: AppColors.textColor,
                      align: TextAlign.start,
                      context: context,
                    ),
                    subText4(
                      Staticdata.userModel?.name?.isNotEmpty == true
                          ? Staticdata.userModel!.name!
                          : 'User',
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                      fontWeight: FontWeight.w500,
                      context: context,
                    ),
                  ],
                ),
              ),
              // Profile picture
              Obx(() => GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, ProfileView.routeName),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.cardGray,
                      backgroundImage:
                          controller.userProfileImage.value.isNotEmpty
                              ? NetworkImage(controller.userProfileImage.value)
                              : const AssetImage(AppAssets.profile)
                                  as ImageProvider,
                      onBackgroundImageError:
                          controller.userProfileImage.value.isNotEmpty
                              ? (exception, stackTrace) =>
                                  const AssetImage(AppAssets.profile)
                              : null,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 0.2,
            color: AppColors.textColor,
          ),
        ],
      ),
    );
  }

  /// Quick Action Buttons in 2x2 Grid
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  icon: FaIcon(
                    FontAwesomeIcons.house,
                    color: Colors.pink[300],
                    size: context.percentWidth * 4.5,
                  ),
                  title: Lang.addVisit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddVisitView(
                                isOndashboard: false,
                              )),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionCard(
                  icon: FaIcon(
                    FontAwesomeIcons.pills,
                    color: Colors.blue[400],
                    size: context.percentWidth * 4.25,
                  ),
                  title: Lang.addMedication,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMedicineView(
                                isOndashboard: false,
                              )),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                    icon: FaIcon(
                      FontAwesomeIcons.timeline,
                      color: Colors.orange[400],
                      size: context.percentWidth * 4.5,
                    ),
                    title: Lang.viewTimeline,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TimelineView(
                                    isOndashboard: false,
                                  )));
                    }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionCard(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.clipboardList,
                        color: Colors.blue[400],
                        size: context.percentWidth * 4.5,
                      ),
                      Positioned(
                        bottom: 0,
                        child: FaIcon(
                          FontAwesomeIcons.stethoscope,
                          color: Colors.blue[600],
                          size: context.percentWidth * 3,
                        ),
                      ),
                    ],
                  ),
                  title: Lang.reviewMed,
                  onTap: () => Get.find<HomeController>().onReviewMedTap(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Medication Alert Section
  Widget _buildMedicationAlert(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headline6(
            Lang.medicationAlert,
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
            context: context,
          ),
          const SizedBox(height: 8),
          MedicationAlertCard(
            message: Lang.medContraindication,
          ),
        ],
      ),
    );
  }

  /// As of Today Section
  Widget _buildAsOfTodaySection(BuildContext context) {
    final controller = Get.find<HomeController>();

    // Medicine colors and icons
    final medicineColors = [
      const Color.fromARGB(255, 181, 218, 244),
      AppColors.lightOrange,
      AppColors.lightGreenCard,
      AppColors.lightPurple,
    ];

    final medicineIcons = [
      FaIcon(FontAwesomeIcons.pills,
          color: Colors.blue[600], size: context.percentWidth * 6),
      FaIcon(FontAwesomeIcons.capsules,
          color: Colors.orange[600], size: context.percentWidth * 6),
      FaIcon(FontAwesomeIcons.tablets,
          color: AppColors.green, size: context.percentWidth * 6),
      FaIcon(FontAwesomeIcons.syringe,
          color: Colors.purple[600], size: context.percentWidth * 6),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headline6(
                fontWeight: FontWeight.w500,
                Lang.asOfToday,
                color: AppColors.headingTextColor,
                context: context,
              ),
              Row(
                children: [
                  Obx(() => controller.selectedDate.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: controller.clearDateFilter,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                  Obx(() => DatePickerButton(
                        date: controller.selectedDate.value.isEmpty
                            ? 'Select Date'
                            : controller.selectedDate.value,
                        onTap: controller.onDatePickerTap,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => controller.medicinesList.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.pills,
                        color: AppColors.textColor.withOpacity(0.5),
                        size: context.percentWidth * 8,
                      ),
                      const SizedBox(height: 8),
                      subText4(
                        'No medicines added yet',
                        color: AppColors.textColor,
                        align: TextAlign.center,
                        context: context,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.medicinesList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final medicine = controller.medicinesList[index];
                    print('medicine id :${medicine.id}');
                    final colorIndex = index % medicineColors.length;
                    final iconIndex = index % medicineIcons.length;

                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: TodayTaskCard(
                              backgroundColor: medicineColors[colorIndex],
                              icon: medicineIcons[iconIndex],
                              title: medicine.medicineName,
                              isCompleted: medicine.status != 'active',
                              status: medicine.status == 'active'
                                  ? 'Active'
                                  : 'Completed',
                              onTap: () =>
                                  controller.showMedicineDetails(medicine.id),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )),
        ],
      ),
    );
  }

  /// Future Appointments Section
  Widget _buildFutureAppointmentsSection(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headline5(Lang.futureAppointments,
                  color: AppColors.headingTextColor,
                  fontWeight: FontWeight.w500,
                  context: context),
              InkWell(
                onTap: controller.onViewAllTap,
                child: subText5(
                  Lang.viewAll,
                  color: AppColors.borderColor,
                  align: TextAlign.start,
                  context: context,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => controller.visitsList.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.calendarCheck,
                        color: AppColors.textColor.withOpacity(0.5),
                        size: context.percentWidth * 8,
                      ),
                      const SizedBox(height: 8),
                      subText4(
                        'No visits scheduled',
                        color: AppColors.textColor,
                        align: TextAlign.center,
                        context: context,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.visitsList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final visit = controller.visitsList[index];
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: AppointmentCard(
                              date: visit.visitDate,
                              doctor: visit.providerName,
                              reason: visit.notes,
                              specialty: visit.specialty,
                              onTap: () =>
                                  controller.showVisitDetails(visit.id),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Logo at top
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(40),
            child: Image.asset(
              AppAssets.logoMain,
              height: 80,
            ),
          ),
          const SizedBox(height: 20),
          // Menu options
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileView(
                                isOndashboard: false,
                              )),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.feedback,
                  title: 'Feedback',
                  onTap: () => Navigator.pushNamed(context, '/feedback'),
                ),
                // _buildDrawerItem(
                //   context,
                //   icon: Icons.settings,
                //   title: 'Settings',
                //   onTap: () => Navigator.pop(context),
                // ),
                _buildDrawerItem(
                  context,
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyView()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpSupportView()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Logout button at bottom
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: subText4(
                  'Logout',
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  context: context,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: subText4(
        title,
        color: AppColors.headingTextColor,
        align: TextAlign.start,
        context: context,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final controller = Get.find<HomeController>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: subText4(
            'Logout',
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
            context: context,
          ),
          content: subText5(
            'Are you sure you want to logout?',
            color: AppColors.textColor,
            context: context,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: subText5(
                'Cancel',
                color: AppColors.textColor,
                context: context,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await controller.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: subText5(
                'Logout',
                color: AppColors.white,
                context: context,
              ),
            ),
          ],
        );
      },
    );
  }
}
