import 'package:Azunii_Health/utils/ApiExceptions.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/custom_snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  Future<T?> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      setLoading(true);
      return await apiCall();
    } on ApiException catch (e) {
      CustomSnackbar.show(e.message, isSuccess: false);
      return null;
    } catch (e) {
      CustomSnackbar.show('Unexpected error occurred', isSuccess: false);
      return null;
    } finally {
      setLoading(false);
    }
  }
}
