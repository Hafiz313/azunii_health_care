import 'package:get/get.dart';
import '../../networking/api_client.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void handleError(Exception e) {
    setLoading(false);
    ApiClient.handleException(e);
  }

  Future<T?> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      setLoading(true);
      final result = await apiCall();
      setLoading(false);
      return result;
    } catch (e) {
      handleError(e as Exception);
      return null;
    } finally {
      setLoading(false);
    }
  }
}
