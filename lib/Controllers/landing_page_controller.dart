import 'package:event_application1/screens/login_page.dart';
import 'package:event_application1/screens/signup_page.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  void goToLoginPage() {
    Get.to(() => LoginPage());
  }

  void goToSignupPage() {
    Get.to(() => SignupPage());
  }
}
