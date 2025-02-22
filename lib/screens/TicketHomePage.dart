
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controllers/selectedeventController.dart';
import '../Firebase/event_data.dart';

class TicketHomePage extends StatefulWidget {
  final int selectedSeats;
  final String totalAmount;
  const TicketHomePage({Key? key, required this.selectedSeats, required this.totalAmount,}) : super(key: key);

  @override
  State<TicketHomePage> createState() => _TicketHomePageState();
}
class _TicketHomePageState extends State<TicketHomePage> {
  final SelectedEventController selectedEventController =
  Get.put(SelectedEventController()); // Find the SelectedEventController

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> _saveParticipantInformation() async {
    try {
      // Ensure the user is authenticated
      User? user = _auth.currentUser;
      if (user == null) {
        // Handle the case where the user is not authenticated
        // You might want to show an error message or redirect to the login page
        return;
      }

      // Retrieve the current event
      EventData? selectedEvent = selectedEventController.selectedEvent.value;
      if (selectedEvent == null) {
        // Handle the case where there is no selected event
        return;
      }

      // Get the current user's UID
      String userId = user.uid;

      // Fetch additional user details from the "users" collection
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _firestore.collection('users').doc(userId).get();
      Map<String, dynamic>? userData = userSnapshot.data();

      // Ensure that eventId and userId are non-empty before creating the document reference
      if (selectedEvent.eventId.isNotEmpty && userId.isNotEmpty && userData != null) {
        // Save user information in the event subcollection
        await _firestore
            .collection('events')
            .doc(selectedEvent.eventId) // Use the event ID to identify the event
            .collection('participants')
            .doc(userId)
            .set({
          'userId': userId,
          'seatsBooked': widget.selectedSeats,
          'username': userData['UserName'] ?? 'N/A',
          'phoneNumber': userData['phone'] ?? 'N/A',
          'Address':userData['location'] ?? 'N/A'
          // Add more user information as needed
        });
      } else {
        print('Error: Empty eventId or userId');
      }

      // Provide feedback to the user (you can show a snackbar or navigate to a confirmation page)
      // ...

    } catch (e) {
      // Handle errors (show an error message, log the error, etc.)
      print('Error saving participant information: $e');
      // You might want to show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    EventData? selectedEvent = selectedEventController.selectedEvent.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "YOUR TICKET".toUpperCase(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "Thank you for Booking!\n Save your ticket below "
                    .toUpperCase(),
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              TicketWidget(
                color: Color(0xff02cad0),
                width: 280,
                height: 420,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.pink,
                              radius: 60,
                              child: CircleAvatar(
                                backgroundColor: Colors.pink,
                                radius: 60,
                                backgroundImage: NetworkImage(selectedEvent?.imagepath ?? ""),
                              )

                            ),
                            Text(
                              selectedEvent?.eventName ?? "", // Event Name
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                Text(
                                  selectedEvent?.location ?? "", // Location
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.pink,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ticketDetails("Start Time",
                                        selectedEvent?.starttime ?? ""),
                                    ticketDetails("End Time",
                                        selectedEvent?.endtime ?? ""),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ticketDetails("Price",
                                        "${widget.totalAmount ?? "" }"), // Price
                                    ticketDetails("No. of seats\n\t\t\t Booked",
                                        "${widget.selectedSeats ?? ""}  "),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 40,
                              width: 200,
                              child: Image.asset("assets/9185570.png",fit: BoxFit.cover,),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff02cad0), // Background color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  _saveParticipantInformation();


                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    'Save Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget ticketDetails(String title, String details) => Column(
    children: [
      Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.center,
        height: 20,
        width: 55,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          details,
          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
        ),
      )
    ],
  );
}
