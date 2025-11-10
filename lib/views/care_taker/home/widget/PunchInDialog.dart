import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../core/models/response/GetJobEmpModels.dart';
import '../controller/home_controller.dart';

class PunchInDialog extends StatefulWidget {
  final List<GetJobResult> jobs;
  final DateTime date;
  const PunchInDialog({
    super.key,
    required this.jobs,
    required this.date,
  });

  @override
  State<PunchInDialog> createState() => _PunchInDialogState();
}

class _PunchInDialogState extends State<PunchInDialog> {
  var controller = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    // Find the currently selected job from the controller
    var controller = Get.find<HomeController>();
    final currentSelectedJob = controller.selectedJob.value;

    if (widget.jobs.isNotEmpty) {
      if (currentSelectedJob.id != null) {
        // Mark the currently selected job as selected
        for (final job in widget.jobs) {
          job.selected = (job.id == currentSelectedJob.id);
        }
      } else {
        // If no job is selected, select the first one
        widget.jobs.first.selected = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            // Title
            const Text(
              'Select Job',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.borderColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Job List
            ...widget.jobs.map((job) => _customRadioTile(job)).toList(),
            const SizedBox(height: 32),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // padding: const EdgeInsets.symmetric(
                      //     vertical: 3, horizontal: 2),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: context.percentWidth * 2,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 2),
                    ),
                    onPressed: () {
                      final selectedJob =
                          widget.jobs.firstWhereOrNull((job) => job.selected);
                      if (selectedJob != null) {
                        // Close the dialog and return the selected job
                        // The controller will handle the punch action
                        Navigator.pop(context, selectedJob);
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
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

  Widget _customRadioTile(GetJobResult job) {
    final isSelected = job.selected;
    return InkWell(
      onTap: () async {
        if (!job.selected) {
          if (!controller.isPunchIn.value) {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => _SwitchJobConfirmDialog(job: job),
            );
            if (confirmed == true) {
              setState(() {
                for (final j in widget.jobs) {
                  j.selected = false;
                }
                job.selected = true;
              });
            }
          } else {
            setState(() {
              for (final j in widget.jobs) {
                j.selected = false;
              }
              job.selected = true;
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                job.jobDescription ?? 'Unknown Job',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.black,
                  width: 3,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchJobConfirmDialog extends StatelessWidget {
  final GetJobResult job;

  const _SwitchJobConfirmDialog({required this.job});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to\n switch the job?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C63FF), // purple
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                        await controller.punchInOrOut(context,
                            jobId: '${job.id}');
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white),
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
}
