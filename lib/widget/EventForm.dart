// import 'dart:io';
//
// import 'package:event_application1/Controllers/userdataController.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'MediaSelector.dart';
// import 'customized_button.dart';
// import 'customized_textfield.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EventForm extends StatefulWidget {
//   final void Function() onPublish;
//   final List<File?> selectedMediaFiles;
//
//   const EventForm({
//     Key? key,
//     required this.onPublish,
//     required this.selectedMediaFiles,
//   }) : super(key: key);
//
//   @override
//   State<EventForm> createState() => _EventFormState();
// }
//
// class _EventFormState extends State<EventForm> {
//   bool _isSubmitting = false; // Added to track form submission progress
//   File? _selectedImage;
//
//   final TextEditingController _eventname = TextEditingController();
//   final TextEditingController _eventaddress = TextEditingController();
//   final TextEditingController _datecontroller = TextEditingController();
//   final TextEditingController _pricecontroller = TextEditingController();
//   late final TextEditingController _starttime = TextEditingController();
//   final TextEditingController _endtime = TextEditingController();
//   late final TextEditingController _eventDescriptionController =
//   TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   List<String> categories = ["Sports", "Music", "Food", "Party"];
//   String selectedCategory = "Party";
//   String _publishErrorMessage = ''; // Error message for the publish button
//
//   bool _areAllFieldsFilled() {
//     return _eventname.text.isNotEmpty &&
//         _eventaddress.text.isNotEmpty &&
//         _locationController.text.isNotEmpty &&
//         _pricecontroller.text.isNotEmpty &&
//         _datecontroller.text.isNotEmpty &&
//         _starttime.text.isNotEmpty &&
//         _endtime.text.isNotEmpty &&
//         _eventDescriptionController.text.isNotEmpty;
//   }
//
//   final UserDataController userDataController=Get.put(UserDataController());
//   Future<void> _fetchUserDataAndSubmitForm() async {
//     try {
//       await userDataController.fetchUserData();
//       _submitForm();
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }
//
//   Future<void> _submitForm() async {
//     // Clear any previous error messages
//     setState(() {
//       _publishErrorMessage = '';
//     });
//
//     if (widget.selectedMediaFiles.isNotEmpty && _areAllFieldsFilled()) {
//       setState(() {
//         _isSubmitting = true; // Show loading indicator
//       });
//
//       try {
//         // Get username, userId, and profile image from UserDataController
//         String username = userDataController.username.value;
//         String userId = userDataController.userId.value;
//         String profileimg = userDataController.profileimg.value;
//
//
//
//         List<String> mediaUrls = [];
//
//         // Upload only selected images to Firebase Storage
//         for (File? selectedImage in widget.selectedMediaFiles) {
//           if (selectedImage != null) {
//             final uploadTask = storageRef.putFile(selectedImage);
//
//             // Wait for the upload to complete
//             final snapshot = await uploadTask.whenComplete(() {});
//
//             final imageUrl = await snapshot.ref.getDownloadURL();
//             mediaUrls.add(imageUrl); // Add the media URL to the list
//           }
//         }
//
//         // Add the form data, username, and userId to Firestore
//         await FirebaseFirestore.instance.collection('events').add({
//           'eventName': _eventname.text,
//           'category': selectedCategory,
//           'eventAddress': _eventaddress.text,
//           'location': _locationController.text,
//           'price': _pricecontroller.text,
//           'date': _datecontroller.text,
//           'startTime': _starttime.text,
//           'endTime': _endtime.text,
//           'eventDescription': _eventDescriptionController.text,
//           'mediaURLs': mediaUrls,
//           'username': username,
//           'userId': userId,
//           'profileimg': profileimg,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//
//         // Clear the form fields and selected images
//         _eventname.clear();
//         _eventaddress.clear();
//         _locationController.clear();
//         _pricecontroller.clear();
//         _datecontroller.clear();
//         _starttime.clear();
//         _endtime.clear();
//         _eventDescriptionController.clear();
//         widget.selectedMediaFiles.clear(); // Clear the selected images
//         mediaUrls.clear();
//
//         widget.onPublish(); // Notify the parent widget
//
//         // Show success dialog
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Success'),
//               content: Text('Event published successfully'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } catch (error) {
//         // Handle any errors that occur during submission
//         setState(() {
//           _publishErrorMessage = 'An error occurred during submission';
//         });
//       } finally {
//         setState(() {
//           _isSubmitting = false; // Hide loading indicator
//         });
//       }
//     } else {
//       setState(() {
//         _publishErrorMessage = 'Please select at least one image';
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text("Full Name", style: TextStyle(fontSize: 15,
//                 fontWeight: FontWeight.w900),
//             ),
//           ),
//           mytextfield(mycontroller: _eventname,
//             hinttext: "Enter Event name",
//             ispassword: false,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Event name is required';
//               }
//               return null; // Return null if the input is valid
//             },),
//           const SizedBox(height: 20,),
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text("Category", style: TextStyle(fontSize: 15,
//                 fontWeight: FontWeight.w900),
//             ),
//           ),
// // Inside the EventForm widget...
//       EventCategorySelector(
//       categories: categories,
//       selectedCategory: selectedCategory,
//       onCategoryChanged: (value) {
//         setState(() {
//           selectedCategory = value;
//         });
//       },
//     ),
//
//           const SizedBox(height: 20,),
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text("Venue Address", style: TextStyle(
//                 fontSize: 15, fontWeight: FontWeight.w900),
//             ),
//           ),
//           mytextfield(mycontroller: _eventaddress,
//             hinttext: "Enter Address",
//             ispassword: false,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Address should not be empty';
//               }
//               return null; // Return null if the input is valid
//             },),
//
//           const SizedBox(height: 20,),
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               "Location",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//           ),
//           mytextfield(
//             mycontroller: _locationController,
//             hinttext: "Enter Location of city",
//             ispassword: false,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Location is required';
//               }
//               return null; // Return null if the input is valid
//             },
//           ),
//           const SizedBox(height: 20,),
//
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text("Price", style: TextStyle(fontSize: 15,
//                 fontWeight: FontWeight.w900),
//             ),
//           ),
//           TextField(
//             controller: _pricecontroller,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             decoration: InputDecoration(
//               prefixText: '₹ ',
//               contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
//               hintText: "Enter price",
//               enabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.black, width: 1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),
//
//
//           const SizedBox(height: 20,),
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text("Date ", style: TextStyle(fontSize: 15,
//                 fontWeight: FontWeight.w900),
//             ),
//           ),
//
//
//           TextFormField(
//             readOnly: true,
//             controller: _datecontroller,
//             decoration: InputDecoration(
//               suffixIcon: const Icon(Icons.calendar_today),
//
//               contentPadding: const EdgeInsets.symmetric(vertical: 13,
//                   horizontal: 13),
//               enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                       color: Colors.grey, width: 1),
//                   borderRadius: BorderRadius.circular(20)),
//               focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                       color: Color(0xff02cad0), width: 1),
//                   borderRadius: BorderRadius.circular(20)),
//               hintText: "Select date",
//             ),
//
//             onTap: () async {
//               DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1950),
//                   //DateTime.now() - not to allow to choose before today.
//                   lastDate: DateTime(2100));
//
//               if (pickedDate != null) {
//                 //pickedDate output format => 2021-03-10 00:00:00.000
//                 String formattedDate =
//                 DateFormat('yyyy-MM-dd').format(pickedDate);
//                 //formatted date output using intl package =>  2021-03-16
//                 setState(() {
//                   _datecontroller.text =
//                       formattedDate; //set output date to TextField value.
//                 });
//               } else {}
//             },
//
//           ),
//           const SizedBox(height: 20,),
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text("Time ", style: TextStyle(fontSize: 15,
//                 fontWeight: FontWeight.w900),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Flexible(
//                 child: TextField(
//                     readOnly: true,
//                     controller: _starttime,
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 13, horizontal: 13),
//                       hintText: "Start Time",
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Colors.black, width: 1),
//                           borderRadius: BorderRadius.circular(20)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Color(0xff02cad0), width: 1),
//                           borderRadius: BorderRadius.circular(20)),
//                     ),
//                     onTap: () async {
//                       TimeOfDay? pickedtime=await showTimePicker(
//                           context: context,
//                           initialTime: TimeOfDay.now());
//                       if(pickedtime!=null){
//                         setState(() {
//                           _starttime.text = pickedtime.format(context);
//                         });
//                       }
//                     }
//                 ),
//               ),
//               const SizedBox(width: 20.0,),
//               Flexible(
//                 child: TextField(
//                   controller: _endtime,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 13, horizontal: 13),
//                     hintText: "End time",
//                     enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(
//                             color: Colors.black, width: 1),
//                         borderRadius: BorderRadius.circular(20)),
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(
//                             color: Color(0xff02cad0), width: 1),
//                         borderRadius: BorderRadius.circular(20)),
//                   ),
//                   onTap: () async {
//                     TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//
//                     if (pickedTime != null) {
//                       setState(() {
//                         _endtime.text = pickedTime.format(context);
//                       });
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(width: 20.0,),
//
//             ],
//           ),
//           const SizedBox(height: 20,),
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text("Event Decription", style: TextStyle(
//                 fontSize: 15, fontWeight: FontWeight.w900),
//             ),
//           ),
//
//           TextFormField(
//             controller: _eventDescriptionController,
//             maxLines: 5, // Allow multiple lines for description
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
//               hintText: "Enter event description",
//               enabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.black, width: 1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20,),
//           if (_isSubmitting) CircularProgressIndicator(),
//
//           Text(
//             // Conditionally display error message
//             _isSubmitting ? '' : _publishErrorMessage,
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: 16,
//             ),
//           ),
//
//           customizedbtn(
//             buttonText: "Publish",
//             onPressed: () {
//               if (_areAllFieldsFilled()) {
//                 _fetchUserDataAndSubmitForm(); // Fetch user data and submit form
//               } else {
//                 setState(() {
//                   _publishErrorMessage = 'Please fill up all fields';
//                 });
//               }
//             },
//             textColor: Colors.white,
//           ),
//
//           const SizedBox(height: 30,),
//         ],
//       ),
//     );
//   }
// }