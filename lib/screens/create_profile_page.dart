import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../Controllers/userController.dart';
import '../widget/customized_button.dart';
import '../widget/customized_textfield.dart';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  String selectedGender = '';
  File? selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }
  UserController?userController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController=Get.find<UserController>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          toolbarHeight: 80,
          title: Text("Create Profile"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Image Selection
                  GestureDetector(
                    onTap: getImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : null,
                      child: selectedImage == null
                          ? Icon(
                        Icons.camera_alt,
                        color: Colors.grey[600],
                        size: 40,
                      )
                          : null,
                    ),
                  ),

                  SizedBox(height: 20),
                  Align(
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
                    mycontroller: _usernameController,
                    hinttext: "Enter full name",
                    ispassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Bio",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  mytextfield(
                    mycontroller: _bioController,
                    hinttext: "Enter the Bio",
                    ispassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bio is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  phonetextfield(
                    mycontroller: _phoneNumberController,
                    hinttext: "Phone Number",
                  ),

                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Date of Birth",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: AbsorbPointer(
                      child: mytextfield(
                        mycontroller: _dobController,
                        hinttext: "Date of Birth (YYYY-MM-DD)",
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Date of Birth is required';
                          }
                          DateTime dobDate = DateTime.parse(value);
                          DateTime currentDate = DateTime.now();
                          DateTime adultDate = currentDate.subtract(Duration(
                            days: 365 * 18,
                          ));

                          if (dobDate.isAfter(adultDate)) {
                            return 'Must be 18 years or older';
                          }
                          return null;
                        },
                        ispassword: false,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Male',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      Text('Male'),
                      Radio(
                        value: 'Female',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      Text('Female'),
                      Radio(
                        value: 'Other',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      Text('Other'),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Save Button
                  Obx(() {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        customizedbtn(
                          buttonText: "Create Profile",
                          onPressed: () async {
                            if (_isLoading.value) {
                              return; // Prevent multiple clicks while loading
                            }

                            if (_formKey.currentState!.validate()) {
                              // Show the loading indicator here
                              userController!.isProfileInformationLoading(true);

                              // Upload image and user data
                              String imageUrl = await userController!.uploadImageToFirebaseStorage(selectedImage!);
                              userController!.uploadProfileData(imageUrl,
                                  _usernameController.text.trim(),
                                  _bioController.text.trim(),
                                  _phoneNumberController.text.trim(),
                                  _dobController.text.trim(),
                                  selectedGender == 'Male' ? 'Male' : (selectedGender == 'Female' ? 'Female' : 'Other'));

                              // After uploading, you can reset the loading state
                              userController!.isProfileInformationLoading(false);
                            }
                          },
                        ),
                        if (userController!.isProfileInformationLoading.value)
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                      ],
                    );
                  }),


                  Obx(() {
                    if (_errorMessage.value.isNotEmpty) {
                      return Text(
                        _errorMessage.value,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
