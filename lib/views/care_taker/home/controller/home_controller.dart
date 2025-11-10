import 'dart:async';
import 'dart:convert';

import 'package:azunii_health_care/consts/lang.dart';
import 'package:azunii_health_care/core/models/response/DashBoardModel.dart';
import 'package:azunii_health_care/views/care_taker/home/controller/switch_company_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import '../../../../core/models/response/GetJobEmpModels.dart';
import '../../../../networking/api_provider.dart';
import '../../../../networking/api_ref.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/customer_Loader.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/localStorage/storage_consts.dart';
import '../../../../utils/localStorage/storage_service.dart';
import '../widget/PunchInDialog.dart';
import '../widget/punchInWidget.dart';
import '../widget/punchInWidget.dart' show SwitchJobConfirmDialog;

class HomeController extends GetxController {
  Timer? timer;
  RxInt hours = 0.obs;
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;

  // RxBool loadingPunchIn = false.obs;
  Rx<DashBoardModel> dashboardModel = DashBoardModel(
      result: DashBoardResult(
    name: '',
    workHoursDetails: WorkHoursDetails(),
    announcements: [],
    todayActivities: [],
    leaves: Leaves(),
  )).obs;
  Rx<GetJobEmpModels> getJobEmpModels = GetJobEmpModels().obs;
  RxBool isPunchIn = true.obs;
  RxBool isMultiJob = true.obs;

  // Add variable to store job list
  RxList<GetJobResult> jobEmpList = <GetJobResult>[].obs;
  Rx<GetJobResult> selectedJob = GetJobResult().obs;

  @override
  void onInit() {
    super.onInit();
    delayFunction();
  }

  Future<void> delayFunction() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final switchController = Get.put(SwitchCompanyController());
      switchController.getCompanyList(Get.context!, isShowDialog: false);
    } catch (e) {
      debugPrint('Error checking company count: $e');
    }
    getJobEmp(Get.context!);
  }

  /// Save selected job to storage
  void saveSelectedJob(GetJobResult job) {
    if (job.id != null) {
      StorageService()
          .saveData(StorageConsts.kSelectedJobId, job.id.toString());
      selectedJob.value = job;
      debugPrint("Saved selected job: ${job.jobTitle} (ID: ${job.id})");
    }
  }

  /// Load selected job from storage
  void loadSelectedJobFromStorage() {
    try {
      final savedJobId = StorageService().getData(StorageConsts.kSelectedJobId);
      if (savedJobId != null && savedJobId.toString().isNotEmpty) {
        final jobId = int.tryParse(savedJobId.toString());
        if (jobId != null) {
          final savedJob =
              jobEmpList.firstWhereOrNull((job) => job.id == jobId);
          if (savedJob != null) {
            selectedJob.value = savedJob;
            // Mark the job as selected in the list
            for (final job in jobEmpList) {
              job.selected = (job.id == jobId);
            }
            debugPrint(
                "Loaded saved job: ${savedJob.jobTitle} (ID: ${savedJob.id})");
            return;
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading saved job: $e");
    }

    // If no saved job found, select the first available job
    if (jobEmpList.isNotEmpty) {
      selectFirstJob();
    }
  }

  /// Select the first available job
  void selectFirstJob() {
    if (jobEmpList.isNotEmpty) {
      final firstJob = jobEmpList.first;
      selectedJob.value = firstJob;
      firstJob.selected = true;
      saveSelectedJob(firstJob);
      debugPrint(
          "Selected first job: ${firstJob.jobTitle} (ID: ${firstJob.id})");
    }
  }

  /// Handle punch in/out with automatic job selection
  Future<void> handlePunchInOut(BuildContext context) async {
    if (isMultiJob.value) {
      // Always show job selection dialog for both Punch In and Punch Out

      if (isPunchIn.value) {
        await getJobDialog(context);
      } else {
        punchInOrOut(context, jobId: '0');
      }
    } else {
      // Single job: always punch in/out with jobId '0'
      punchInOrOut(context, jobId: '0');
    }
  }

  Future<void> getDashboard(BuildContext context,
      {required String jobId}) async {
    dashboardModel.value = DashBoardModel(
        result: DashBoardResult(
      workHoursDetails: WorkHoursDetails(),
      announcements: [],
      todayActivities: [],
      leaves: Leaves(),
    ));

    debugPrint("===jobId:${jobId}=====");
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String tenId = StorageService().getData(StorageConsts.kTenantId).toString();
    var url = "";

    if (jobId.toString() == "null") {
      url =
          "${Apis.getDashboardApi}?empId=$empId&compId=${compId}&jobId=0&tenantId=${tenId}";
    } else {
      url =
          "${Apis.getDashboardApi}?empId=$empId&compId=${compId}&jobId=${jobId}&tenantId=${tenId}";
    }

    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: true,
    )
        .then(
      (res) async {
        if (!isNullString(res)) {
          final Map<String, dynamic> jsonData = jsonDecode(res);
          final dashboardModelData = DashBoardModel.fromJson(jsonData);
          dashboardModel.value = dashboardModelData;

          try {
            debugPrint(
                "======getDashboard  dashboardModel.value:${dashboardModel.value.result!.todayActivities!.length}=========");
            if (dashboardModel
                    .value
                    .result!
                    .todayActivities![
                        dashboardModel.value.result!.todayActivities!.length -
                            1]
                    .empAttendencePunchType ==
                "PunchIn") {
              isPunchIn.value = false;

              String punchInTime = dashboardModel
                      .value
                      .result!
                      .todayActivities![
                          dashboardModel.value.result!.todayActivities!.length -
                              1]
                      .date ??
                  '';

              debugPrint("======time:${punchInTime}=========");

              // Start timer from punch-in time
              startTimerFromPunchIn(punchInTime);
            }
          } catch (e) {}
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
        }
      },
    );
  }

  Future<void> getJobDialog(BuildContext context) async {
    // Fetch job data if not already loaded
    if (jobEmpList.isEmpty) {
      await getJobEmp(context);
    }

    // Show the dialog and wait for result
    final result = await showDialog<GetJobResult?>(
      context: context,
      builder: (context) => PunchInDialog(
        jobs: jobEmpList,
        date: DateTime.now(),
      ),
    );

    // If a job was selected, handle it
    if (result != null) {
      // Save the selected job to storage
      saveSelectedJob(result);

      // Update UI
      selectedJob.value = result;

      // Refresh dashboard with new job
      if (result.id != null) {
        getDashboard(context, jobId: '${result.id}');
      }

      debugPrint('Selected Job: ${result.jobTitle}');

      // Perform punch in/out for the selected job
      await punchInOrOut(context, jobId: '${result.id}');
    }
  }

  Future<void> getJobEmp(BuildContext context) async {
    // debugPrint("=====getJobEmp====");
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url = "${Apis.getJobEmp}?empId=$empId";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: true,
    )
        .then(
      (res) async {
        if (!isNullString(res)) {
          debugPrint("======getJobEmp res:${res}=========");
          // Parse the JSON string to Map<String, dynamic>
          final Map<String, dynamic> jsonData = jsonDecode(res);
          final jobEmpModel = GetJobEmpModels.fromJson(jsonData);

          // Store the job list in a variable (you can add this to your controller)
          jobEmpList.value = jobEmpModel.result ?? [];
          // debugPrint("======getJobEmp  jobEmpList.value:${jobEmpList.value}=========");

          if (jobEmpList.value.isEmpty) {
            isMultiJob.value = false;
            getDashboard(context, jobId: '0');
          } else {
            isMultiJob.value = true;

            // Load previously selected job from storage
            loadSelectedJobFromStorage();

            // If no job was loaded from storage, select the first one
            if (selectedJob.value.id == null) {
              selectFirstJob();
            }

            // Load dashboard with selected job
            if (selectedJob.value.id != null) {
              getDashboard(context, jobId: "${selectedJob.value.id}");
            }
          }

          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
        }
      },
    );
  }

  void startTimerFromPunchIn(String punchInTimeString) {
    try {
      DateTime punchInTime = DateTime.parse(punchInTimeString);
      DateTime now = DateTime.now();
      Duration elapsed = now.difference(punchInTime);

      hours.value = elapsed.inHours;
      minutes.value = elapsed.inMinutes % 60;
      seconds.value = elapsed.inSeconds % 60;

      startTimer();
    } catch (e) {
      debugPrint('Error parsing punch-in time: $e');
      startTimer();
    }
  }

  Future<void> punchInOrOut(BuildContext context,
      {required String jobId}) async {
    // loadingPunchIn.value = true;
    var url = Apis.insertOrUpdateAttendenceApi;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    String punchIn = isPunchIn.value ? "PunchIn" : "PunchOut";
    var helper = ApiProvider(context, url, {
      "employeeId": empId,
      "companyId": compId,
      "tenantId": tenantId,
      "date": "${DateTime.now()}",
      "empAttendencePunchType": punchIn,
      "isCheckIn": true,
      "isCheckOut": true,
      "break": 0,
      "duration": 0,
    });

    await helper.postApiData(showSuccess: false, showLoader: true).then(
      (res) async {
        // loadingPunchIn.value = false;
        EasyLoading.dismiss();
        if (!isNullString(res)) {
          getDashboard(context, jobId: '${selectedJob.value.id}');
          isPunchIn.value = !isPunchIn.value;
          if (isPunchIn.value) {
            timer?.cancel();
          } else {
            startTimer();
            // getDashboard(context, jobId: '${selectedJob.value.id}');
          }
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
      },
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value++;
      if (seconds.value == 60) {
        seconds.value = 0;
        minutes.value++;
      }
      if (minutes.value == 60) {
        minutes.value = 0;
        hours.value++;
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void stopWatch() {
    double totalHours =
        dashboardModel.value.result!.workHoursDetails!.workedHours!;
    int totalSeconds = (totalHours * 3600).round();

    // Extract hours, minutes, and seconds
    hours.value = totalSeconds ~/ 3600; // Divide by 3600 to get hours
    int remainingSeconds =
        totalSeconds % 3600; // Remainder after extracting hours
    minutes.value =
        remainingSeconds ~/ 60; // Divide remaining seconds by 60 to get minutes
    seconds.value = remainingSeconds % 60; // Remainder after extracting minutes

    // Display the time
    print('$hours hours $minutes minutes $seconds seconds');
  }
}
