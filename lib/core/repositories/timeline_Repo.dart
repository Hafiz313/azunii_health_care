import '../../networking/api_client.dart';
import '../../networking/api_ref.dart';
import '../models/timeline_model.dart';

class TimelineRepository {
  // Get Timeline
  Future<TimelineResponse> getTimeline({String? date, int? page}) async {
    try {
      print('\n📅 GET TIMELINE Request 📅');
      if (date != null) print('📆 Date: $date');
      if (page != null) print('📄 Page: $page');

      String endpoint = Apis.getTimeline;
      // if (date != null || page != null) {
      //   endpoint += '?';
      //   if (date != null) endpoint += 'date=$date';
      //   if (date != null && page != null) endpoint += '&';
      //   if (page != null) endpoint += 'page=$page';
      // }

      final response = await ApiClient.getWithAuth(endpoint);

      print('✅ Timeline fetched successfully\n');
      return TimelineResponse.fromJson(response);
    } catch (e) {
      print('❌ Get Timeline Error: $e');
      rethrow;
    }
  }
}
