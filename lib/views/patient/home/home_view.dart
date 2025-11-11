import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../../app_routes.dart';
import '../../widget/text.dart';
import '../visits/visits_view.dart';
import '../medicines/medicines_view.dart';

class HomeView extends StatelessWidget {
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
              const SizedBox(height: 20),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildMedicationAlert(context),
              const SizedBox(height: 24),
              _buildAsOfTodaySection(context),
              const SizedBox(height: 24),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Logo/Icon (R or ribbon icon)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.valueTextColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'R',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subText3(
                  Lang.welcome,
                  color: AppColors.textColor,
                  align: TextAlign.start,
                ),
                const SizedBox(height: 2),
                headline5(
                  'Anne Shaen',
                  color: AppColors.headingTextColor,
                  align: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          // Profile picture
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.cardGray,
            backgroundImage: const AssetImage(AppAssets.profile),
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
                child: _buildQuickActionCard(
                  context,
                  icon: Stack(
                    alignment: Alignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.house,
                        color: Colors.pink[300],
                        size: 24,
                      ),
                      Positioned(
                        top: 2,
                        right: 4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.redColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Lang.addVisit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: FaIcon(
                    FontAwesomeIcons.pills,
                    color: Colors.blue[400],
                    size: 24,
                  ),
                  title: Lang.addMedication,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: FaIcon(
                    FontAwesomeIcons.timeline,
                    color: Colors.orange[400],
                    size: 24,
                  ),
                  title: Lang.viewTimeline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.clipboardList,
                        color: Colors.blue[400],
                        size: 24,
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

  Widget _buildQuickActionCard(
    BuildContext context, {
    required Widget icon,
    required String title,
  }) {
    return InkWell(
      onTap: () {
        if (title == Lang.addVisit) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddVisitView()),
          );
        } else if (title == Lang.addMedication) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicineView()),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: subText2(
                title,
                color: AppColors.headingTextColor,
                align: TextAlign.start,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textColor,
            ),
          ],
        ),
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
          headline3(
            Lang.medicationAlert,
            color: AppColors.headingTextColor,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.alertRed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.transparent,
                  ),
                  child: CustomPaint(
                    painter: TrianglePainter(),
                    child: const Center(
                      child: Icon(
                        Icons.warning,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: subText2(
                    Lang.medContraindication,
                    color: AppColors.headingTextColor,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
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
              headline3(
                Lang.asOfToday,
                color: AppColors.headingTextColor,
                textAlign: TextAlign.start,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.dividerGray,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.calander,
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
              subText3(
                        '09-12-2025',
                        color: AppColors.headingTextColor,
                        align: TextAlign.start,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 20,
                color: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
            ],
          ),
          const SizedBox(height: 16),
          // Card 1 - Light Blue/Purple
          _buildTodayCard(
            context,
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
          // Card 2 - Light Yellow/Orange
          _buildTodayCard(
            context,
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
          // Card 3 - Light Green
          _buildTodayCard(
            context,
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
          // Card 4 - Light Purple
          _buildTodayCard(
            context,
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

  Widget _buildTodayCard(
    BuildContext context, {
    required Color backgroundColor,
    required Widget icon,
    required String title,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: subText2(
              title,
              color: AppColors.headingTextColor,
              align: TextAlign.start,
            ),
          ),
          if (isCompleted)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                subText2(
                  Lang.completed,
                  color: AppColors.green,
                  align: TextAlign.start,
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 20,
                ),
              ],
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
              headline3(
                Lang.futureAppointments,
                color: AppColors.headingTextColor,
                textAlign: TextAlign.start,
              ),
              InkWell(
                onTap: () {},
                child: subText2(
                  Lang.viewAll,
                  color: AppColors.valueTextColor,
                  align: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Appointment cards
          _buildAppointmentCard(
            context,
            date: '09-12-2025',
            doctor: 'Dr. James Ray',
            reason: 'Headache',
            specialty: 'Neurologist',
          ),
          const SizedBox(height: 12),
          _buildAppointmentCard(
            context,
            date: '09-12-2025',
            doctor: 'Dr. James Ray',
            reason: 'Headache',
            specialty: 'Neurologist',
          ),
          const SizedBox(height: 12),
          _buildAppointmentCard(
            context,
            date: '09-12-2025',
            doctor: 'Dr. James Ray',
            reason: 'Headache',
            specialty: 'Neurologist',
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context, {
    required String date,
    required String doctor,
    required String reason,
    required String specialty,
  }) {
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgGrayColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppAssets.calander,
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                subText3(
                  date,
                  color: AppColors.headingTextColor,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Doctor
          _buildAppointmentRow(Lang.doctor, doctor),
          const SizedBox(height: 8),
          const Divider(color: AppColors.dividerGray, height: 1),
          const SizedBox(height: 8),
          // Reason to Visit
          _buildAppointmentRow(Lang.reasonToVisit, reason),
          const SizedBox(height: 8),
          const Divider(color: AppColors.dividerGray, height: 1),
          const SizedBox(height: 8),
          // Specialty
          _buildAppointmentRow(Lang.specialty, specialty),
        ],
      ),
    );
  }

  Widget _buildAppointmentRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: subText3(
            label,
            color: AppColors.textColor,
            align: TextAlign.start,
          ),
        ),
        Expanded(
          child: subText2(
            value,
            color: AppColors.valueTextColor,
            align: TextAlign.end,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for triangular warning icon
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.redColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
