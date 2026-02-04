import 'package:Azunii_Health/consts/assets.dart';
import 'package:Azunii_Health/core/models/static_user_model.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/care_taker/home/controller/care-giver-controller.dart';
import 'package:Azunii_Health/views/care_taker/home/select_patient_view.dart';
import 'package:Azunii_Health/views/patient/medicines/medicines_view.dart';
import 'package:Azunii_Health/views/patient/visits/visits_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/quick_action_card.dart';
import '../../widget/Common_widgets/medication_alert_card.dart';
import '../../widget/Common_widgets/today_task_card.dart';
import '../../widget/Common_widgets/date_picker_button.dart';
import '../../widget/Common_widgets/appointment_card.dart';
import '../../auth/login/login_view.dart';
import '../../patient/home/profile_view.dart';

class HomeView_caregiver extends StatelessWidget {
  static const String routeName = '/home-caregiver';
  const HomeView_caregiver({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController_caregiver());
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final patientId = controller.activePatient.value?.userId;
            if (patientId != null) {
              await controller.loadDashboardData(int.parse(patientId));
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildPatientSwitcher(context),
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
    );
  }

  /// Top Header with logo, welcome text, and profile picture
  Widget _buildHeader(BuildContext context) {
    final controller = Get.find<HomeController_caregiver>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.textColor, width: 0.1))),
        child: Row(
          children: [
            // Menu Icon
            // GestureDetector(
            //   onTap: () => _scaffoldKey.currentState?.openDrawer(),
            //   child: Icon(Icons.menu),
            // ),
            const SizedBox(width: 4),

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
                  subText4(
                    Staticdata.userModel?.name ?? 'Caregiver',
                    color: AppColors.headingTextColor,
                    align: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            // Profile picture
            GestureDetector(
              onTap: () => Get.toNamed(ProfileView.routeName),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.11,
                height: MediaQuery.of(context).size.width * 0.11,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.notificationBing,
                    width: 21,
                    height: 21,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientSwitcher(BuildContext context) {
    final controller = Get.find<HomeController_caregiver>();
    return Obx(() {
      final activePatient = controller.activePatient.value;
      if (activePatient == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 20,
                child: Text(
                  activePatient.patient.name[0].toUpperCase(),
                  style: const TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText5(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      'Active Patient',
                      color: AppColors.textColor.withOpacity(0.7),
                    ),
                    subText4(
                      activePatient.patient.name,
                      color: AppColors.headingTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectPatientView(),
                    ),
                  );
                },
                child: subText5(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  'Change',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    });
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
                    size: 17,
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
                    size: 18,
                  ),
                  title: Lang.viewTimeline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Medication Alert Section
  // Widget _buildMedicationAlert(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         headline6(
  //           Lang.medicationAlert,
  //           color: AppColors.headingTextColor,
  //           fontWeight: FontWeight.w500,
  //           //   textAlign: TextAlign.start,
  //         ),
  //         const SizedBox(height: 8),
  //         MedicationAlertCard(
  //           message: Lang.medContraindication,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// As of Today Section
  Widget _buildAsOfTodaySection(BuildContext context) {
    final controller = Get.find<HomeController_caregiver>();
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
              ),
              Row(
                children: [
                  if (controller.selectedDateString.value.isNotEmpty)
                    TextButton(
                      onPressed: controller.clearDateFilter,
                      child: subText5(
                        fontSize: 12,
                        'Clear Filter',
                        color: AppColors.primary,
                      ),
                    ),
                  Obx(() => DatePickerButton(
                        date: controller.selectedDateString.value.isEmpty
                            ? 'Select Date'
                            : controller.selectedDateString.value,
                        onTap: controller.onDatePickerTap,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final controller = Get.find<HomeController_caregiver>();
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.filteredMedicines.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(Icons.medication_outlined,
                        size: 48, color: AppColors.textColor.withOpacity(0.3)),
                    const SizedBox(height: 8),
                    subText4(
                        controller.selectedDateString.value.isEmpty
                            ? 'No medications available'
                            : 'No medications for selected date',
                        color: AppColors.textColor.withOpacity(0.6)),
                  ],
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredMedicines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final medicine = controller.filteredMedicines[index];
                return TodayTaskCard(
                  backgroundColor: Colors.blue[100]!,
                  icon: FaIcon(FontAwesomeIcons.pills,
                      color: Colors.blue[600], size: 24),
                  title: '${medicine.medicineName} - ${medicine.dosage}',
                  isCompleted: medicine.status == 'active',
                );
              },
            );
          }),
        ],
      ),
    );
  }

  /// Future Appointments Section
  Widget _buildFutureAppointmentsSection(BuildContext context) {
    final controller = Get.find<HomeController_caregiver>();

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
          Obx(() {
            final dashboard = controller.dashboardData.value;
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (dashboard == null || dashboard.upcomingVisits.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(Icons.event_note_outlined,
                        size: 48, color: AppColors.textColor.withOpacity(0.3)),
                    const SizedBox(height: 8),
                    subText4('No upcoming visits',
                        color: AppColors.textColor.withOpacity(0.6)),
                  ],
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dashboard.upcomingVisits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final visit = dashboard.upcomingVisits[index];
                return AppointmentCard(
                  date: visit.visitDate,
                  doctor: visit.providerName,
                  reason: visit.notes,
                  specialty: visit.specialty,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: context.screenWidth * 0.6,
      child: Container(
        color: Colors.white,
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
                  _buildDrawerItem(
                    context,
                    icon: Icons.info,
                    title: 'About',
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
                  onPressed: () async {
                    Navigator.pop(context);
                    final controller = Get.find<HomeController_caregiver>();
                    await controller.logout();
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
}
