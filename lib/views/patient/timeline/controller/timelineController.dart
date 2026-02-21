import 'package:get/get.dart';
import '../../../../core/controllers/base_controller.dart';
import '../../../../core/models/timeline_model.dart';
import '../../../../core/repositories/timeline_Repo.dart';

class TimelineController extends BaseController {
  final TimelineRepository _timelineRepository = TimelineRepository();

  // Raw data from API
  final RxList<MedicineSchedule> _allSchedules = <MedicineSchedule>[].obs;
  final RxList<TimelineEvent> _allEvents = <TimelineEvent>[].obs;

  // Filtered data for display
  final RxList<MedicineSchedule> scheduleList = <MedicineSchedule>[].obs;
  final RxList<TimelineEvent> eventsList = <TimelineEvent>[].obs;
  final RxList<dynamic> filteredList = <dynamic>[].obs;

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());
  final RxInt currentPage = RxInt(1);
  final RxInt totalPages = RxInt(1);
  final RxBool showAllDates = RxBool(false);

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
      totalPages.value =
          (result.data.meta.total / result.data.meta.perPage).ceil();
      _applyFilter();
    }
  }

  void filterByDate(DateTime? date) {
    selectedDate.value = date;
    showAllDates.value = date == null;
    fetchTimeline(1);
  }

  void resetFilter() {
    selectedDate.value = DateTime.now();
    showAllDates.value = false;
    fetchTimeline(1);
  }

  void _applyFilter() {
    if (showAllDates.value || selectedDate.value == null) {
      // Show all data
      scheduleList.value = _allSchedules.toList();
      eventsList.value = _allEvents.toList();
    } else {
      // Filter by selected date
      final filterDate = selectedDate.value!;
      //final filterDateStr = _formatDateForComparison(filterDate);

      // Filter schedules (they don't have date, so show all on any filter for now)
      // If schedules have a date field in the API response, filter them here
      scheduleList.value = _allSchedules.toList();

      // Filter events by timestamp
      eventsList.value = _allEvents.where((event) {
        try {
          final eventDate = DateTime.parse(event.timestamp);
          return eventDate.year == filterDate.year &&
              eventDate.month == filterDate.month &&
              eventDate.day == filterDate.day;
        } catch (e) {
          // If timestamp parsing fails, include the event
          return true;
        }
      }).toList();
    }
    _updateFilteredList();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      fetchTimeline(page);
    }
  }

  void _updateFilteredList() {
    final combined = <dynamic>[
      ...scheduleList,
      ...eventsList,
    ];
    filteredList.value = combined.reversed.toList();
  }
}
