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

class EditVisitsView extends StatefulWidget {
  final bool? isOndashboard;
  final int? visitId;
  EditVisitsView({super.key, this.isOndashboard, this.visitId});

  static const String routeName = '/edit-visits';

  @override
  State<EditVisitsView> createState() => _EditVisitsViewState();
}

class _EditVisitsViewState extends State<EditVisitsView> {
  final VisitsController controller = Get.put(VisitsController());
  int? visitId;

  @override
  void initState() {
    super.initState();
    visitId = widget.visitId;
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['visit'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadVisitData(arguments['visit']);
        final visit = arguments['visit'];
        visitId = visit.id is int ? visit.id : int.tryParse(visit.id.toString());
        print('Visit ID type: ${visitId.runtimeType}, value: $visitId');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => OverlayLoader(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  isOndashboard: false,
                  title: 'Edit visit',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildHeading(),
                        const SizedBox(height: 10),
                        // Provider name
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
                        // Specialty dropdown
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
                        // Date picker
                        Obx(() => CustomDatePicker(
                              label: Lang.date,
                              hintText: Lang.selectDate,
                              selectedDate: controller.selectedDate.value,
                              onChanged: controller.setDate,
                            )),
                        const SizedBox(height: 20),
                        // Notes
                        CustomTxtField(
                          title: Lang.notes,
                          textEditingController: controller.notesController,
                          hintTxt: Lang.writeDescription,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 24),
                        // Upload Section
                        UploadSectionWidget(
                          headerIcon: Icons.upload,
                          title: Lang.photoDocumentUpload,
                          subtitle: Lang.selectAndUploadPhoto,
                          onTap: controller.showImagePickerDialog,
                          selectedImage: controller.selectedImage,
                        ),
                        const SizedBox(height: 24),
                        // Save Button
                        AppElevatedButton(
                          onPressed: () {
                            if (visitId != null) {
                              controller.updateVisit(visitId!);
                            } else {
                              //  controller.saveVisit();
                            }
                          },
                          title: 'Update Visit',
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
        )));
  }

  Widget _buildHeading() {
    return subText5(
      Lang.prepareForNewVisit,
      fontSize: 15,
      color: AppColors.headingTextColor,
      fontWeight: FontWeight.w500,
    );
  }
}
