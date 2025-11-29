import 'package:Azunii_Health/core/controllers/base_controller.dart';
import 'package:Azunii_Health/core/repositories/auth_repository.dart';
import 'package:Azunii_Health/core/services/local_storage_service.dart';
import 'package:Azunii_Health/utils/snackbar_helper.dart';
import 'package:Azunii_Health/views/auth/login/login_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SettingsController extends BaseController {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> logout() async {
    final result = await safeApiCall(() => _authRepository.logout());

    if (result != null) {
      await LocalStorageService.logout();
      Get.offAllNamed(LoginView.routeName);
      SnackbarHelper.showSuccess('Logged out successfully');
    } else {}
  }

  Future<void> deleteAccount() async {
    final result = await safeApiCall(() => _authRepository.deleteAccount());

    if (result != null) {
      await LocalStorageService.logout();
      Get.offAllNamed(LoginView.routeName);
      SnackbarHelper.showSuccess('Account deleted successfully');
    } else {}
  }
}
