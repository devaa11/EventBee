import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:event_application1/screens/Splash_Screen.dart';
import 'package:event_application1/screens/home_page.dart';
import 'package:event_application1/screens/landing_page.dart';
import 'package:event_application1/Firebase/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Controllers/createEventController.dart';
import 'Controllers/userController.dart';
import 'Controllers/userdataController.dart';
import 'firebase_options.dart'; // Import GetX

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserController()); // Initialize your UserController
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Replace MaterialApp with GetMaterialApp
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        duration: 3000, // Adjust the duration as needed
        splash: Image.asset(
          "assets/eventbee.png",
        ),
        nextScreen: LandingPage(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
