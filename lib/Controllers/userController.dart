import 'package:event_application1/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class UserController extends GetxController {

  var isProfileInformationLoading = false.obs;

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference =
    FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print("Error happen $e");
    });

    return imageUrl;
  }
  uploadProfileData(String imageUrl, String firstName,String bio, String Phone, String dob, String gender) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': imageUrl,
      'UserName': firstName,
      'Bio':bio,
      'phone': Phone,
      'dob': dob,
      'gender': gender
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(()=> Homepage());
    });

  }
}
