import 'package:event_application1/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/login_controller.dart';
import '../widget/customized_button.dart';
import '../widget/customized_textfield.dart';
import 'forget_pass.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Image.asset(
            'assets/eventbee.png',
            height: 80,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey, // Use the formKey from LoginController
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Center(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Use your credentials and log in to \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t your account",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.67,
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
                              "Email",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          mytextfield(
                            mycontroller: controller.emailController,
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
                            mycontroller: controller.passwordController,
                            hinttext: "Enter Password",
                            ispassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                            // Add an icon button to toggle the password visibility
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Use the passwordVisible variable to toggle the icon
                                controller.passwordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Toggle the password visibility when the button is pressed
                                controller.togglePasswordVisibility();
                              },
                            ),
                          ),

                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              onTap: () {
                                Get.to(const forgotpass());
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              customizedbtn(
                                buttonText: "Log In",
                                onPressed: () {
                                  if (controller.formKey.currentState!.validate()) {
                                    controller.login();
                                  }
                                },
                                textColor: Colors.white,
                              ),
                              if (controller.isLoading.value)
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          Obx(() {
                            if (controller.errorMessage.isNotEmpty) {
                              return Text(
                                controller.errorMessage.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("If you are new / ",
                                  style: TextStyle(fontSize: 15)),
                              InkWell(
                                child: const Text(
                                  "Create New Account",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                onTap: () {
                                  Get.to(SignupPage());
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
