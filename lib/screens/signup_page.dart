import 'package:event_application1/Firebase/services.dart';
import 'package:event_application1/screens/create_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widget/customized_button.dart';
import '../widget/customized_textfield.dart';
import 'home_page.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _fullNameController.dispose();
  }
  void signUp() async {
    try {
      _isLoading.value = true;

      // Get the user's credentials from the controllers
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Call the signup method from your FirebaseAuthService
      await _auth.signUpWithEmailAndPassword(email, password);

      // If the signup is successful, navigate to the CreateProfilePage
      Get.to(() => CreateProfilePage());
    } catch (error) {
      // Handle signup errors and update the error message
      _errorMessage.value = 'Error signing up: $error';
    } finally {
      // Set loading to false after signup attempt
      _isLoading.value = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          'assets/eventbee.png',
          height: 50,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey2,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: const Text(
                  "Use your credentials to create a new  \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t account!!",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                  color: Colors.white70,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Full Name",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      mytextfield(
                        mycontroller: _fullNameController,
                        hinttext: "Enter full name",
                        ispassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      mytextfield(
                        mycontroller: _emailController,
                        hinttext: "Enter email",
                        ispassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }

                          final emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      mytextfield(
                        mycontroller: _passwordController,
                        hinttext: "Enter password",
                        ispassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            customizedbtn(
                              buttonText: "Sign Up",
                              onPressed: () {
                                if (_formKey2.currentState!.validate()) {
                                  signUp();
                                }
                              },
                            ),
                            if (_isLoading.value)
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                          ],
                        );
                      }),
                      Obx(() {
                        return Text(
                          _errorMessage.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        );
                      }),


                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? / ",
                            style: TextStyle(fontSize: 15),
                          ),
                          InkWell(
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            onTap: () {
                              Get.to(LoginPage());
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
