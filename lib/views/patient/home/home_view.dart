import 'package:Azunii_Health/consts/assets.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
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
import '../visits/visits_view.dart';
import '../medicines/medicines_view.dart';
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildQuickActions(context),
              const SizedBox(height: 13),
              _buildMedicationAlert(context),
              const SizedBox(height: 13),
              _buildAsOfTodaySection(context),
              const SizedBox(height: 13),
              _buildFutureAppointmentsSection(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Header with logo, welcome text, and profile picture
  Widget _buildHeader(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.textColor, width: 0.1))),
        child: Row(
          children: [
            // Menu Icon
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: Icon(Icons.menu),
            ),
            const SizedBox(width: 12),
            // Logo/Icon (R or ribbon icon)
            Container(
              width: context.screenWidth * 0.1,
              height: context.screenWidth * 0.1,
              decoration: BoxDecoration(
                color: AppColors.valueTextColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'R',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
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
                  ),
                  Obx(() => subText4(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value
                            : 'User',
                        color: AppColors.headingTextColor,
                        align: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
            // Profile picture
            Obx(() => CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.cardGray,
                  backgroundImage: controller.userProfileImage.value.isNotEmpty
                      ? NetworkImage(controller.userProfileImage.value)
                      : const AssetImage(AppAssets.profile) as ImageProvider,
                  onBackgroundImageError:
                      controller.userProfileImage.value.isNotEmpty
                          ? (exception, stackTrace) =>
                              const AssetImage(AppAssets.profile)
                          : null,
                )),
          ],
        ),
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
                    size: 18,
                  ),
                  title: Lang.addVisit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddVisitView()),
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
                    size: 17,
                  ),
                  title: Lang.addMedication,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMedicineView()),
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
                    size: 18,
                  ),
                  title: Lang.viewTimeline,
                  onTap: () => Get.find<HomeController>().onViewTimelineTap(),
                ),
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
                        size: 18,
                      ),
                      Positioned(
                        bottom: 0,
                        child: FaIcon(
                          FontAwesomeIcons.stethoscope,
                          color: Colors.blue[600],
                          size: 12,
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
            //   textAlign: TextAlign.start,
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
//textAlign: TextAlign.start,
              ),
              DatePickerButton(
                date: controller.selectedDate.value,
                onTap: controller.onDatePickerTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.todayTasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = controller.todayTasks[index];
              return TodayTaskCard(
                backgroundColor: task['backgroundColor'],
                icon: task['icon'],
                title: task['title'],
                isCompleted: task['isCompleted'],
              );
            },
          ),
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
                  fontWeight: FontWeight.w500),
              InkWell(
                onTap: controller.onViewAllTap,
                child: subText5(
                  fontSize: 12,
                  Lang.viewAll,
                  color: AppColors.borderColor,
                  align: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.appointments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final appointment = controller.appointments[index];
              return AppointmentCard(
                date: appointment['date']!,
                doctor: appointment['doctor']!,
                reason: appointment['reason']!,
                specialty: appointment['specialty']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Logo at top
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
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () => Navigator.pop(context),
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
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: subText4(
            'Logout',
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
          ),
          content: subText5(
            'Are you sure you want to logout?',
            color: AppColors.textColor,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: subText5(
                'Cancel',
                color: AppColors.textColor,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final controller = Get.find<HomeController>();
                await controller.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: subText5(
                'Logout',
                color: AppColors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
