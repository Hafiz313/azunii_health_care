import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';

class MedicinesView extends StatelessWidget {
  const MedicinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildAddMedicationButton(context),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Center(
              child: headline3(
                'Medication',
                color: AppColors.headingTextColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
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

  Widget _buildAddMedicationButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicineView()),
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
              'Add Medication',
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

/// Add Medicine View - Separate widget for adding new medicines
class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});
  
  static const String routeName = '/add-medicine';

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  String? _selectedStatus;

  @override
  void dispose() {
    _medNameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildMedNameField(),
                    const SizedBox(height: 20),
                    _buildDosageField(),
                    const SizedBox(height: 20),
                    _buildFrequencyField(),
                    const SizedBox(height: 20),
                    _buildStatusDropdown(),
                    const SizedBox(height: 24),
                    _buildFileUploadSection(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
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
                Lang.addMedicine,
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

  /// Med Name Input Field
  Widget _buildMedNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.medName,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _medNameController,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Satoshi',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: Lang.enterMedName,
            hintStyle: const TextStyle(
              color: AppColors.textColor,
              fontFamily: 'Satoshi',
              fontSize: 16,
            ),
            prefixIcon: const Icon(
              Icons.medication_outlined,
              color: AppColors.textColor,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.cardGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Dosage Input Field
  Widget _buildDosageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.dosage,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showDosagePicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.science_outlined,
                  color: AppColors.textColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _dosageController.text.isEmpty
                        ? Lang.enterDosage
                        : _dosageController.text,
                    style: TextStyle(
                      color: _dosageController.text.isEmpty
                          ? AppColors.textColor
                          : AppColors.blackColor,
                      fontFamily: 'Satoshi',
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Frequency Input Field
  Widget _buildFrequencyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.frequency,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showFrequencyPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.calander,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _frequencyController.text.isEmpty
                        ? Lang.enterMedFrequency
                        : _frequencyController.text,
                    style: TextStyle(
                      color: _frequencyController.text.isEmpty
                          ? AppColors.textColor
                          : AppColors.blackColor,
                      fontFamily: 'Satoshi',
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Status Dropdown
  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.status,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showStatusPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.textColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedStatus ?? Lang.selectStatus,
                    style: TextStyle(
                      color: _selectedStatus != null
                          ? AppColors.blackColor
                          : AppColors.textColor,
                      fontFamily: 'Satoshi',
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// File Upload Section
  Widget _buildFileUploadSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.upload,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText2(
                      Lang.uploadFiles,
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    subText3(
                      Lang.selectAndUploadFiles,
                      color: AppColors.textColor,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Upload Area
          InkWell(
            onTap: () {
              // Handle file picker
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 16),
                      subText2(
                        Lang.chooseFileOrDrag,
                        color: AppColors.headingTextColor,
                      ),
                      const SizedBox(height: 8),
                      subText3(
                        Lang.fileFormats,
                        color: AppColors.textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Save Button
          AppElevatedButton(
            onPressed: () {
              Get.back();
            },
            title: Lang.save,
            backgroundColor: AppColors.primary,
            width: double.infinity,
            height: 50,
          ),
        ],
      ),
    );
  }

  /// Show Safety Alert Dialog
  void _showSafetyAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MedicationSafetyAlertDialog(),
    );
  }

  /// Helper Methods
  void _showDosagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final dosages = ['10mg', '20mg', '40mg', '50mg', '100mg'];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: dosages.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(dosages[index]),
              onTap: () {
                setState(() {
                  _dosageController.text = dosages[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showFrequencyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final frequencies = [
          'Once daily',
          'Twice daily',
          'Three times daily',
          'Four times daily',
          'As needed',
        ];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: frequencies.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(frequencies[index]),
              onTap: () {
                setState(() {
                  _frequencyController.text = frequencies[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final statuses = ['Active', 'Inactive', 'Paused', 'Completed'];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: statuses.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(statuses[index]),
              onTap: () {
                setState(() {
                  _selectedStatus = statuses[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

/// Custom painter for dashed border
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.dividerGray
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;
    double startY = 0;

    // Top border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + dashWidth, startY),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right border
    startX = size.width;
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    startX = size.width;
    startY = size.height;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX - dashWidth, startY),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    // Left border
    startX = 0;
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Medication Safety Alert Dialog Widget
class MedicationSafetyAlertDialog extends StatelessWidget {
  const MedicationSafetyAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.alertRed,
                shape: BoxShape.circle,
              ),
              child: CustomPaint(
                painter: TrianglePainter(),
                child: const Center(
                  child: Icon(
                    Icons.warning,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            headline3(
              Lang.medicationSafetyAlert,
              color: AppColors.headingTextColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Message
            subText2(
              Lang.possibleInteractionDetected,
              color: AppColors.headingTextColor,
              align: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Important Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  subText2(
                    Lang.important,
                    color: AppColors.headingTextColor,
                    align: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  subText3(
                    Lang.potentialInteractionMessage,
                    color: AppColors.textColor,
                    align: TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: AppColors.dividerGray),
                    ),
                    child: subText2(
                      Lang.ok,
                      color: AppColors.headingTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showMedicationAlertDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: subText2(
                        Lang.reviewMedications,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicationAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MedicationAlertDialog(),
    );
  }
}

/// Medication Alert Dialog Widget with Medication List
class MedicationAlertDialog extends StatelessWidget {
  const MedicationAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: headline3(
                    Lang.medicationAlert,
                    color: AppColors.headingTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.textColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Alert Box
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subText2(
                          Lang.medContraindication,
                          color: AppColors.headingTextColor,
                          align: TextAlign.start,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            // Handle speak with prescribers
                          },
                          child: subText2(
                            Lang.speakWithPrescribers,
                            color: AppColors.primary,
                            align: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Medication List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headline3(
                  Lang.medicationList,
                  color: AppColors.headingTextColor,
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: () {
                    // Handle view all
                  },
                  child: subText2(
                    Lang.viewAll,
                    color: AppColors.primary,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Medication Cards
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMedicationCard(
                      time: '10:00 am',
                      medication: 'Simvastatin 20mg',
                      dose: '${Lang.dose} 1',
                    ),
                    const SizedBox(height: 12),
                    _buildMedicationCard(
                      time: '10:00 am',
                      medication: 'Nexium',
                      dose: '20mg',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Confirm & Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Handle save
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: subText2(
                  Lang.confirmAndSave,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard({
    required String time,
    required String medication,
    required String dose,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: AppColors.textColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subText2(
                  time,
                  color: AppColors.headingTextColor,
                  align: TextAlign.start,
                ),
                const SizedBox(height: 4),
                subText3(
                  medication,
                  color: AppColors.textColor,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          subText2(
            dose,
            color: AppColors.headingTextColor,
            align: TextAlign.end,
          ),
        ],
      ),
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
