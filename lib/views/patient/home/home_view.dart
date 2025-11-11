import 'package:azunii_health_care/consts/assets.dart';
import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/quick_action_card.dart';
import '../../widget/Common_widgets/medication_alert_card.dart';
import '../../widget/Common_widgets/today_task_card.dart';
import '../../widget/Common_widgets/date_picker_button.dart';
import '../../widget/Common_widgets/appointment_card.dart';
import '../visits/visits_view.dart';
import '../medicines/medicines_view.dart';

class HomeView extends StatelessWidget {
  static const String routeName = '/HomeView';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildQuickActions(context),
              const SizedBox(height: 8),
              _buildMedicationAlert(context),
              const SizedBox(height: 8),
              _buildAsOfTodaySection(context),
              const SizedBox(height: 8),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.textColor, width: 0.1))),
        child: Row(
          children: [
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
                  subText4(
                    'Anne Shaen',
                    color: AppColors.headingTextColor,
                    align: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            // Profile picture
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.cardGray,
              backgroundImage: const AssetImage(AppAssets.profile),
            ),
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
                      MaterialPageRoute(
                          builder: (context) => const AddVisitView()),
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
          headline5(
            Lang.medicationAlert,
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w500,
            //   textAlign: TextAlign.start,
          ),
          const SizedBox(height: 12),
          MedicationAlertCard(
            message: Lang.medContraindication,
          ),
        ],
      ),
    );
  }

  /// As of Today Section
  Widget _buildAsOfTodaySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headline5(
                fontWeight: FontWeight.w500,
                Lang.asOfToday,
                color: AppColors.headingTextColor,
//textAlign: TextAlign.start,
              ),
              DatePickerButton(
                date: '09-12-2025',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          TodayTaskCard(
            backgroundColor: AppColors.lightBlue,
            icon: FaIcon(
              FontAwesomeIcons.pills,
              color: Colors.blue[600],
              size: 24,
            ),
            title: Lang.takeMedDaily,
            isCompleted: true,
          ),
          const SizedBox(height: 12),
          TodayTaskCard(
            backgroundColor: AppColors.lightOrange,
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.orange[300],
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'X',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Lang.doNotTakeMed,
            isCompleted: true,
          ),
          const SizedBox(height: 12),
          TodayTaskCard(
            backgroundColor: AppColors.lightGreenCard,
            icon: FaIcon(
              FontAwesomeIcons.clipboardList,
              color: AppColors.green,
              size: 24,
            ),
            title: Lang.limitedExercise,
            isCompleted: true,
          ),
          const SizedBox(height: 12),
          TodayTaskCard(
            backgroundColor: AppColors.lightPurple,
            icon: FaIcon(
              FontAwesomeIcons.clipboardList,
              color: Colors.purple[600],
              size: 24,
            ),
            title: Lang.limitedExercise,
            isCompleted: true,
          ),
        ],
      ),
    );
  }

  /// Future Appointments Section
  Widget _buildFutureAppointmentsSection(BuildContext context) {
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
                  // textAlign: TextAlign.start,

                  fontWeight: FontWeight.w500),
              InkWell(
                onTap: () {},
                child: subText6(
                  Lang.viewAll,
                  color: AppColors.valueTextColor,
                  align: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppointmentCard(
            date: '09-12-2025',
            doctor: 'Dr. James Ray',
            reason: 'Headache',
            specialty: 'Neurologist',
          ),
          const SizedBox(height: 12),
          AppointmentCard(
            date: '09-12-2025',
            doctor: 'Dr. James Ray',
            reason: 'Headache',
            specialty: 'Neurologist',
          ),
          const SizedBox(height: 12),
          AppointmentCard(
            date: '09-12-2025',
            doctor: 'Dr. James Ray',
            reason: 'Headache',
            specialty: 'Neurologist',
          ),
        ],
      ),
    );
  }
}
