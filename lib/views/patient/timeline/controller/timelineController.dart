import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/timeline_model.dart';
import '../../../../core/repositories/timeline_Repo.dart';

class TimelineController extends BaseController {
  final TimelineRepository _timelineRepository = TimelineRepository();

  // Raw data from API
  final RxList<MedicineSchedule> _allSchedules = <MedicineSchedule>[].obs;
  final RxList<TimelineEvent> _allEvents = <TimelineEvent>[].obs;

  // Separated & reversed lists for display
  final RxList<MedicineSchedule> scheduleList = <MedicineSchedule>[].obs;
  final RxList<TimelineEvent> visitsList = <TimelineEvent>[].obs;
  final RxList<TimelineEvent> medicineUpdatesList = <TimelineEvent>[].obs;

  final Rxn<DateTime> selectedDate = Rxn<DateTime>(null);
  final RxInt currentPage = RxInt(1);
  final RxInt totalPages = RxInt(1);
  final RxInt totalItems = RxInt(0);
  final RxBool showAllDates = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    fetchTimeline(1);
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> fetchTimeline(int page) async {
    final dateParam = selectedDate.value != null && !showAllDates.value
        ? _formatDateForApi(selectedDate.value!)
        : null;

    final result = await safeApiCall(
      () => _timelineRepository.getTimeline(page: page, date: dateParam),
    );

    if (result != null) {
      _allSchedules.value = result.data.schedule;
      _allEvents.value = result.data.events;
      currentPage.value = result.data.meta.page;
      totalItems.value = result.data.meta.total;
      totalPages.value =
          (result.data.meta.total / result.data.meta.perPage).ceil();
      _separateAndReverse();
    }
  }

  void filterByDate(DateTime? date) {
    selectedDate.value = date;
    showAllDates.value = date == null;
    fetchTimeline(1);
  }

  void resetFilter() {
    selectedDate.value = null;
    showAllDates.value = true;
    fetchTimeline(1);
  }

  void _separateAndReverse() {
    // Reverse schedules for latest-first
    scheduleList.value = _allSchedules.reversed.toList();

    // Separate events into visits and medicine updates, reverse both
    final visits = <TimelineEvent>[];
    final medUpdates = <TimelineEvent>[];

    for (final event in _allEvents) {
      if (event.type == 'visit') {
        visits.add(event);
      } else {
        medUpdates.add(event);
      }
    }

    visitsList.value = visits.reversed.toList();
    medicineUpdatesList.value = medUpdates.reversed.toList();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      fetchTimeline(page);
    }
  }

  bool get shouldShowPagination => totalItems.value >= 10;

  bool get isFilterChanged {
    return selectedDate.value != null;
  }
}
