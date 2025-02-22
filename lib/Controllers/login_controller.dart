import 'package:event_application1/Firebase/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/home_page.dart';

class LoginController extends GetxController {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool loginSuccess = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Define a property to toggle password visibility
  final RxBool passwordVisible = false.obs; // Initially visible

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    passwordVisible(!passwordVisible.value);
  }

  Future<void> login() async {
    isLoading(true);
    errorMessage('');
    loginSuccess(false);

    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        print("User logged in successfully");
        loginSuccess(true);
        Get.offAll(Homepage());
      } else {
        errorMessage('Incorrect email or password');
      }
    } catch (e) {
      print("Error during login: $e");
      errorMessage('An error occurred while logging in');
    } finally {
      isLoading(false);
    }
  }
}
