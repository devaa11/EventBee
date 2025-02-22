import 'dart:io';
import 'dart:typed_data';
import 'package:event_application1/Controllers/featuredEventController.dart';
import 'package:event_application1/Controllers/popularEvetController.dart';
import 'package:event_application1/Controllers/trendingeventController.dart';
import 'package:event_application1/Controllers/userdataController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;

class CreateEventController extends GetxController {

  Rx<TimeOfDay> minEndTime = TimeOfDay.now().obs;
  Rx<TimeOfDay> endTime = TimeOfDay.now().obs;

  // Other properties and methods...

  // Example method to update endTime based on selected startTime
  void updateEndTime(TimeOfDay selectedStartTime) {
    // Add logic here to set minEndTime based on selectedStartTime
    // For example, set minEndTime to selectedStartTime + 1 hour
    minEndTime.value = TimeOfDay(
      hour: selectedStartTime.hour + 1,
      minute: selectedStartTime.minute,
    );

    // Set endTime to minEndTime initially
    endTime.value = minEndTime.value;
  }

  // Example method to check if endTime is after minEndTime
  bool isEndTimeAfterMin() {
    return endTime.value.hour > minEndTime.value.hour ||
        (endTime.value.hour == minEndTime.value.hour &&
            endTime.value.minute > minEndTime.value.minute);
  }
  RxList<File?> mediaFiles = <File?>[].obs;
  Rx<File?> coverImage = Rx<File?>(null);
  final TextEditingController eventname = TextEditingController();
  final TextEditingController eventaddress = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController starttime = TextEditingController();
  final TextEditingController endtime = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController UpiIdController = TextEditingController();
  List<String> categories = ["Sports", "Music", "Food", "Party"];
  String selectedCategory = "Party";
  bool isSubmitting = false; // Added to track form submission progress

  List<String> selectedMediaPaths = [];
  String publishErrorMessage = ''; // Error message for the publish button


  final UserDataController userDataController=Get.put(UserDataController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
      mediaFiles = RxList<File?>.generate(4, (_) => null); // Change XFile? to File?
    userDataController.fetchUserData();

    }

  void pickCoverImage() async {
    final XFile? pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      coverImage.value = File(pickedImage.path);
    }
  }

  void discardCoverImage() {
    coverImage.value = null;
  }

  void pickMediaImage(int index) async {
    final XFile? pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      mediaFiles[index] = File(pickedImage.path);
    }
  }

  void discardMediaImage(int index) {
    mediaFiles[index] = null;
  }

  void SubmitForm() async {
    try {
      isSubmitting = true;

      // Validate that all fields are filled
      if (
      coverImage.value != null &&
          eventname.text.isNotEmpty &&
          eventaddress.text.isNotEmpty &&
          datecontroller.text.isNotEmpty &&
          pricecontroller.text.isNotEmpty &&
          starttime.text.isNotEmpty &&
          endtime.text.isNotEmpty &&
          eventDescriptionController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          UpiIdController.text.isNotEmpty
      ) {
        String username = userDataController.username.value;
        String userId = userDataController.userId.value;
        String profileimg = userDataController.profileimg.value;

        // Upload cover image to Firebase Storage
        String coverImageUrl = await uploadImageToStorage(coverImage.value!);

        // Upload media images to Firebase Storage
        List<String> mediaImageUrls = [];
        for (File? mediaFile in mediaFiles) {
          if (mediaFile != null) {
            String mediaImageUrl = await uploadImageToStorage(mediaFile);
            mediaImageUrls.add(mediaImageUrl);
          }
        }

        // Add event data to Firestore and get the event ID
        DocumentReference eventRef = await FirebaseFirestore.instance.collection('events').add({
          'eventName': eventname.text,
          'category': selectedCategory,
          'eventAddress': eventaddress.text,
          'location': locationController.text,
          'price': pricecontroller.text,
          'date': datecontroller.text,
          'startTime': starttime.text,
          'endTime': endtime.text,
          'UpiId': UpiIdController.text,
          'eventDescription': eventDescriptionController.text,
          'coverImageUrl': coverImageUrl,
          'mediaImageUrls': mediaImageUrls,
          'username': username,
          'userId': userId,
          'profileimg': profileimg,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Get the event ID
        String eventId = eventRef.id;

        // Update the event with the ID
        await eventRef.update({'eventId': eventId});

        final trendingEventController = Get.find<TrendingEventController>();
        final featuredEventController = Get.find<FeaturedEventsController>();
        final popularEventsController = Get.find<PopularEventsController>();
        await trendingEventController.fetchEvents();
        await featuredEventController.fetchEvents();
        await popularEventsController.fetchEvents();

        // Reset form and show success message
        _resetForm();
        _showSuccessMessage('Event published successfully');
      } else {
        _showErrorMessage('All fields, including the cover image, are required.');
      }
    } catch (error) {
      // Handle errors, e.g., show an error message
      print('Error submitting form: $error');
      _showErrorMessage('Error creating event. Please try again.');
    } finally {
      isSubmitting = false;
    }
  }

  Future<String> uploadImageToStorage(File? imageFile) async {
    String username = userDataController.username.value;

    try {
      if (imageFile == null) {
        // Handle the case when the file is null
        throw Exception('Image file is null');
      }

      // Read the image file
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;

      // Compress the image (adjust the quality as needed)
      List<int> compressedBytes = img.encodeJpg(image, quality: 85);

      // Generate a unique filename
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload compressed image to Firebase Storage
      Reference storageReference =
      FirebaseStorage.instance.ref().child('events/$username/$fileName.jpg');
      UploadTask uploadTask = storageReference.putData(Uint8List.fromList(compressedBytes));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      // Handle image upload errors
      print('Error uploading image: $error');
      throw error;
    }
  }  void _resetForm() {
    // Clear text fields
    eventname.clear();
    eventaddress.clear();
    datecontroller.clear();
    pricecontroller.clear();
    starttime.clear();
    endtime.clear();
    eventDescriptionController.clear();
    locationController.clear();
    UpiIdController.clear();

    // Reset selected category
    selectedCategory = "Party";

    // Clear media files
    mediaFiles.forEach((file) {
      if (file != null) {
        // You may want to delete the file from storage if needed
        // FirebaseStorage.instance.ref().child('events//$fileName').delete();
      }
    });
    mediaFiles.assignAll(List.generate(4, (_) => null));

    // Clear cover image
    if (coverImage.value != null) {
      // You may want to delete the file from storage if needed
      // FirebaseStorage.instance.ref().child('events//$fileName').delete();
    }
    coverImage.value = null;
  }

  Future<void> _showSuccessMessage(String message) async {
    return showDialog(
      context: Get.context!, // Assuming you are using the GetX library to manage state
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorMessage(String errorMessage) async {
    return showDialog(
      context: Get.context!, // Assuming you are using the GetX library to manage state
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'), // Corrected title to 'Error'
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
// Add other methods related to form submission, validation, etc.
}
