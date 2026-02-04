import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/text.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import 'controller/care-giver-controller.dart';

class SelectPatientView extends StatelessWidget {
  static const String routeName = '/select-patient';
  const SelectPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController_caregiver>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              isOndashboard: false,
              title: 'Select Patient',
              onIconTap: () => Get.back(),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: controller.patients.length,
                    itemBuilder: (context, index) {
                      final patient = controller.patients[index];
                      final isActive =
                          controller.activePatient.value?.id == patient.id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.dividerGray,
                            width: isActive ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            controller.selectPatient(patient);
                            Get.back();
                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              patient.patient.name[0].toUpperCase(),
                              style: const TextStyle(color: AppColors.white),
                            ),
                          ),
                          title: subText4(
                            patient.patient.name,
                            color: AppColors.headingTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              subText5(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                patient.patient.email,
                                color: AppColors.textColor,
                              ),
                              const SizedBox(height: 2),
                              subText5(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                'Relationship: ${patient.relationship}',
                                color: AppColors.textColor.withOpacity(0.7),
                              ),
                            ],
                          ),
                          trailing: isActive
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.primary)
                              : null,
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
