

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataController extends GetxController {
  RxString username = ''.obs;
  RxString userId = ''.obs;
  RxString profileimg= ''.obs;

  String currentUserId=FirebaseAuth.instance.currentUser!.uid;

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        username.value = userData['UserName'] ?? '';
        profileimg.value = userData['image'] ?? '';

        userId.value = currentUserId;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
