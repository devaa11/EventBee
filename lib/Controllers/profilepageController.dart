import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getMyDocument();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  DocumentSnapshot? myDocument;
  String? documentId; // Store the documentId separately

  getMyDocument() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .listen((event) {
      myDocument = event;
      documentId = event.id; // Store the documentId
    });
  }

  // Add this method to fetch the user profile data
  Future<DocumentSnapshot?> fetchUserProfile() async {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }
}
