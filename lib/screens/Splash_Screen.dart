import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:event_application1/screens/landing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000, // Adjust the duration as needed
      splash: Image.asset(
        "assets/eventbee.png",
      ),
      nextScreen: LandingPage(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.white,
    );
  }
}
