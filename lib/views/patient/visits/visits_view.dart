import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_dropdown.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:Azunii_Health/views/widget/text_fields.dart';
import 'package:Azunii_Health/views/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import '../../widget/Common_widgets/custom_date_picker.dart';
import '../../widget/Common_widgets/upload_section_widget.dart';
import 'controller/visits_controller.dart';

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
                size: context.percentWidth * 20,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              headingText1(
                'Visits',
                color: AppColors.headingTextColor,
                context: context,
              ),
              const SizedBox(height: 10),
              subText3(
                'Manage your doctor visits',
                color: AppColors.textColor,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddVisitView extends StatefulWidget {
  final bool? isOndashboard;
  AddVisitView({super.key, this.isOndashboard});

  static const String routeName = '/add-visit';

  @override
  State<AddVisitView> createState() => _AddVisitViewState();
}

class _AddVisitViewState extends State<AddVisitView> {
  final VisitsController controller = Get.put(VisitsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    // Defer clearing to after the build phase — PageView deactivates widgets
    // during build, and modifying Rx values synchronously causes
    // "setState() called during build" exceptions
    if (Get.isRegistered<VisitsController>()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<VisitsController>()) {
          controller.clearAllFields();
        }
      });
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            // Only clear fields when user manually navigates back
            Future.delayed(const Duration(milliseconds: 100), () {
              if (Get.isRegistered<VisitsController>()) {
                controller.clearAllFields();
              }
            });
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Obx(() => OverlayLoader(
              isLoading: controller.isLoading.value,
              child: Scaffold(
                backgroundColor: AppColors.white,
                body: SafeArea(
                  child: Column(
                    children: [
                      CustomAppBar(
                        isOndashboard: widget.isOndashboard ?? true,
                        title: Lang.addVisit,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildHeading(context),
                              const SizedBox(height: 10),
                              CustomTxtField(
                                title: Lang.ProviderName,
                                textEditingController:
                                    controller.providerNameController,
                                hintTxt: Lang.enterProviderName,
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.textColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Obx(() => CustomDropdown(
                                    label: Lang.specialty,
                                    hintText: Lang.selectSpecialty,
                                    items: const [
                                      'Cardiologist',
                                      'Neurologist',
                                      'Dermatologist',
                                      'Pediatrician',
                                      'Orthopedic',
                                    ],
                                    selectedValue:
                                        controller.selectedSpecialty.value.isEmpty
                                            ? null
                                            : controller.selectedSpecialty.value,
                                    onChanged: controller.setSpecialty,
                                    prefixIcon: const Icon(
                                      Icons.settings_outlined,
                                      size: 18,
                                      color: AppColors.textColor,
                                    ),
                                  )),
                              const SizedBox(height: 20),
                              Obx(() => CustomDatePicker(
                                    label: Lang.date,
                                    hintText: Lang.selectDate,
                                    selectedDate: controller.selectedDate.value,
                                    onChanged: controller.setDate,
                                  )),
                              const SizedBox(height: 20),
                              CustomTxtField(
                                title: Lang.notes,
                                textEditingController: controller.notesController,
                                hintTxt: Lang.writeDescription,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 24),
                              UploadSectionWidget(
                                headerIcon: Icons.upload,
                                title: Lang.photoDocumentUpload,
                                subtitle: Lang.selectAndUploadPhoto,
                                onTap: controller.showImagePickerDialog,
                                selectedImage: controller.selectedImage,
                              ),
                              const SizedBox(height: 24),
                              AppElevatedButton(
                                onPressed: controller.saveVisit,
                                title: Lang.save,
                                backgroundColor: AppColors.primary,
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 12,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
        ));
  }

  Widget _buildHeading(BuildContext context) {
    return subText5(
      Lang.prepareForNewVisit,
      color: AppColors.headingTextColor,
      fontWeight: FontWeight.w500,
      context: context,
    );
  }
}
