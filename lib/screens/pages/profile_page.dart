import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_application1/Controllers/profilepageController.dart';
import 'package:event_application1/Firebase/services.dart';
import 'package:event_application1/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../yourPublishedEvents.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isNotEditable = true;
  ProfilePageController? profilePageController;
  FirebaseAuthService _authService = FirebaseAuthService();
  String image = '';

  @override
  @override
  void initState() {
    super.initState();
    profilePageController = Get.put(ProfilePageController());

    // Use FutureBuilder to load profile data asynchronously
    Future<DocumentSnapshot<Object?>?>? profileData = profilePageController?.fetchUserProfile();

    // Update the UI when the data is available
    profileData?.then((data) {
      if (data != null && data.exists) {
        setState(() {
          userNameController.text = data['UserName'] ?? '';
          phoneController.text = data['phone'] ?? '';
          descriptionController.text = data['Bio'] ?? '';
          locationController.text = data['location'] ?? '';
          image = data['image'] ?? '';
        });
      } else {
        // Handle the case where the document doesn't exist
        print('Profile document does not exist');
      }
    }).catchError((error) {
      // Handle errors
      print('Error getting profile document: $error');
    });
  }

  void _toggleEdit() {
    if (isNotEditable == false) {
      // Check if the user has entered valid data
      if (userNameController.text.isEmpty || locationController.text.isEmpty || phoneController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Incomplete Profile'),
              content: Text('Please fill in all required fields (Name, Location, Phone Number).'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Exit the function without updating the profile
      }
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        FirebaseFirestore.instance.collection('users').doc(userId).set({
          'UserName': userNameController.text,
          'location': locationController.text,
          'Bio': descriptionController.text,
          'phone': phoneController.text,
        }, SetOptions(merge: true)).then((value) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Profile Updated'),
                content: Text('Your profile has been updated successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      }
    }

    setState(() {
      isNotEditable = !isNotEditable;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(("Profile Page")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Container(
              //     width: 100,
              //     margin: EdgeInsets.only(left: Get.width * 0.75, top: 20, right: 20),
              //     alignment: Alignment.topRight,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         InkWell(
              //           onTap: () {},
              //           child: Image(
              //             image: AssetImage('assets/sms.png'),
              //             width: 28,
              //             height: 25,
              //           ),
              //         ),
              //         Image(
              //           image: AssetImage('assets/menu.png'),
              //           width: 23.33,
              //           height: 19,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Align(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 90, horizontal: 20),
                      width: Get.width,
                      height: isNotEditable ? 200 : 310,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      elevation: 2,
                      child: ListTile(
                        title: Text('Your Events'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: (){
                          Get.to(YourPublishedEvents());
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      elevation: 2,
                      child: ListTile(
                        title: Text('Notification'),
                        trailing: Icon(Icons.notification_add),
                        onTap: (){
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      elevation: 2,
                      child: ListTile(
                        title: Text('Privacy'),
                        trailing: Icon(Icons.privacy_tip_outlined),
                        onTap: (){
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      elevation: 2,
                      child: ListTile(
                        title: Text('Help'),
                        trailing: Icon(Icons.help),
                        onTap: (){
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      elevation: 2,
                      child: ListTile(
                        title: Text('LogOut'),
                        trailing: Icon(Icons.login_outlined),
                        onTap: () async {
                          bool confirmSignOut = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sign Out'),
                                content: Text('Are you sure you want to sign out?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false); // Return false when canceled
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true); // Return true when confirmed
                                    },
                                    child: Text('Sign Out'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmSignOut == true) {
                            try {
                              await _authService.signOut();
                              Get.off(LoginPage());
                            } catch (e) {
                              // Handle sign out error
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.only(top: 35),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(70),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff7DDCFB),
                            Color(0xffBC67F2),
                            Color(0xffACF6AF),
                            Color(0xffF95549),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(70),
                            ),
                            child: image.isEmpty
                                ? CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/profile.jpg'),
                            )
                                : CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(image),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    isNotEditable
                        ? Text(
                      "${userNameController.text}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                        : Container(
                      width: Get.width * 0.6,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: userNameController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'First Name',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    isNotEditable
                        ? Text(
                      "${locationController.text}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff918F8F),
                      ),
                    )
                        : Container(
                      width: Get.width * 0.6,
                      child: TextField(
                        controller: locationController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Location',
                        ),
                      ),
                    ),
                    isNotEditable
                        ? Text(
                      "${phoneController.text}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff918F8F),
                      ),
                    )
                        : Container(
                      width: Get.width * 0.6,
                      child: TextField(
                        controller: phoneController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                        ),
                      ),
                    ),
                    isNotEditable
                        ? Text(
                      "${descriptionController.text}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff918F8F),
                      ),
                    )
                        : Container(
                      width: Get.width * 0.6,
                      child: TextField(
                        controller: descriptionController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Bio',
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 105, right: 35),
                  child: InkWell(
                    onTap: _toggleEdit,
                    child: isNotEditable
                        ? Image(
                      image: AssetImage('assets/edit.png'),
                      width: Get.width * 0.04,
                    )
                        : Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
