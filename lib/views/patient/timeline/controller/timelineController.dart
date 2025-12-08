import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/timeline_model.dart';
import '../../../../core/repositories/timeline_Repo.dart';

class TimelineController extends BaseController {
  final TimelineRepository _timelineRepository = TimelineRepository();

  final RxList<MedicineSchedule> scheduleList = <MedicineSchedule>[].obs;
  final RxList<TimelineEvent> eventsList = <TimelineEvent>[].obs;
  final RxList<dynamic> filteredList = <dynamic>[].obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxInt currentPage = RxInt(1);
  final RxInt totalPages = RxInt(1);
  final RxBool showAllDates = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    fetchTimeline(1);
  }

  Future<void> fetchTimeline(int page) async {
    final dateStr = selectedDate.value != null && !showAllDates.value
        ? _formatDateForApi(selectedDate.value!)
        : null;

    final result = await safeApiCall(
      () => _timelineRepository.getTimeline(date: dateStr, page: page),
    );

    if (result != null) {
      scheduleList.value = result.data.schedule;
      eventsList.value = result.data.events;
      currentPage.value = result.data.meta.page;
      totalPages.value = (result.data.meta.total / result.data.meta.perPage).ceil();
      _updateFilteredList();
    }
  }

  void filterByDate(DateTime? date) {
    selectedDate.value = date;
    showAllDates.value = date == null;
    currentPage.value = 1;
    fetchTimeline(1);
  }

  void resetFilter() {
    selectedDate.value = null;
    showAllDates.value = true;
    currentPage.value = 1;
    fetchTimeline(1);
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      fetchTimeline(page);
    }
  }

  void _updateFilteredList() {
    final combined = <dynamic>[
      ...scheduleList,
      ...eventsList.where((e) => e.type == 'visit'),
    ];
    filteredList.value = combined;
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
