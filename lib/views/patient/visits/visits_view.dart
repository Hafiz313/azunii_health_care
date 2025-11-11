import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';

class VisitsView extends StatelessWidget {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.userDoctor,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              headingText1(
                'Visits',
                color: AppColors.headingTextColor,
              ),
              const SizedBox(height: 10),
              subText3(
                'Manage your doctor visits',
                color: AppColors.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Add Visit View - Separate widget for adding new visits
class AddVisitView extends StatefulWidget {
  const AddVisitView({super.key});
  
  static const String routeName = '/add-visit';

  @override
  State<AddVisitView> createState() => _AddVisitViewState();
}

class _AddVisitViewState extends State<AddVisitView> {
  final TextEditingController _providerNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedSpecialty;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _providerNameController.dispose();
    _notesController.dispose();
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
                    _buildHeading(),
                    const SizedBox(height: 24),
                    _buildProviderNameField(),
                    const SizedBox(height: 20),
                    _buildSpecialtyDropdown(),
                    const SizedBox(height: 20),
                    _buildDateDropdown(),
                    const SizedBox(height: 20),
                    _buildNotesField(),
                    const SizedBox(height: 24),
                    _buildPhotoUploadSection(),
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
                Lang.addVisit,
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

  /// Heading
  Widget _buildHeading() {
    return headline3(
      Lang.prepareForNewVisit,
      color: AppColors.headingTextColor,
      textAlign: TextAlign.start,
    );
  }

  /// Provider Name Input Field
  Widget _buildProviderNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.providerName,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _providerNameController,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Satoshi',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: Lang.enterProviderName,
            hintStyle: const TextStyle(
              color: AppColors.textColor,
              fontFamily: 'Satoshi',
              fontSize: 16,
            ),
            prefixIcon: const Icon(
              Icons.person_outline,
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

  /// Specialty Dropdown
  Widget _buildSpecialtyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.specialty,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showSpecialtyPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.settings_outlined,
                  color: AppColors.textColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedSpecialty ?? Lang.selectSpecialty,
                    style: TextStyle(
                      color: _selectedSpecialty != null
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

  /// Date Dropdown
  Widget _buildDateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.date,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
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
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : Lang.selectDate,
                    style: TextStyle(
                      color: _selectedDate != null
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

  /// Notes Text Area
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          Lang.notes,
          color: AppColors.headingTextColor,
          align: TextAlign.start,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Satoshi',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: Lang.writeDescription,
            hintStyle: const TextStyle(
              color: AppColors.textColor,
              fontFamily: 'Satoshi',
              fontSize: 16,
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
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  /// Photo/Document Upload Section
  Widget _buildPhotoUploadSection() {
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
                      Lang.photoDocumentUpload,
                      color: AppColors.headingTextColor,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    subText3(
                      Lang.selectAndUploadPhoto,
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
              // Handle save
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

  /// Helper Methods
  void _showSpecialtyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final specialties = [
          'Cardiologist',
          'Neurologist',
          'Dermatologist',
          'Pediatrician',
          'Orthopedic',
        ];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: specialties.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(specialties[index]),
              onTap: () {
                setState(() {
                  _selectedSpecialty = specialties[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
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
