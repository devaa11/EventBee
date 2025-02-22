import 'package:event_application1/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import '../Controllers/landing_page_controller.dart';
import '../widget/customized_button.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  final LandingController controller = Get.put(LandingController()); // GetX controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background.png"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset("assets/eventbee.png",height: 150,),
            const SizedBox(height: 10),
            customizedbtn(
              buttonText: "Login",
              textColor: Colors.black,
              onPressed: () {
                controller.goToLoginPage(); // Navigate using GetX
              },
            ),
            const SizedBox(height: 10),
            customizedbtn(
              buttonText: "Register",
              textColor: Colors.black,
              onPressed: () {
                controller.goToSignupPage(); // Navigate using GetX
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
