import 'package:event_application1/Firebase/Upi_Payment.dart';
import 'package:event_application1/Firebase/event_data.dart';
import 'package:event_application1/Firebase/services.dart';
import 'package:event_application1/screens/checkoutPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controllers/selectedeventController.dart';
import '../widget/customized_button.dart';

class EventDetailsPage extends StatefulWidget {
  final EventData event;

  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final SelectedEventController selectedEventController =
      Get.put(SelectedEventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              color: Colors.grey[100],
              child: Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[100],
                              image: widget.event.imagepath.isNotEmpty
                                  ? DecorationImage(
                                      image:
                                          NetworkImage(widget.event.imagepath),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                              top: 20,
                              left: 20,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors
                                      .white, // You can use any color you prefer
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // This will pop the current page and go back

                                  // Save the updated favorite status to persistent storage (e.g., database)
                                  // You can use a database or SharedPreferences to save this data
                                  // Example using SharedPreferences:
                                  // saveFavoriteStatus(widget.event);
                                },
                              )),
                          Positioned(
                              top: 20,
                              right: 20,
                              child: IconButton(
                                icon: Icon(
                                  widget.event.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors
                                      .red, // You can use any color you prefer
                                ),
                                onPressed: () {
                                  setState(() {
                                    // Toggle the isFavorite status
                                    widget.event.isFavorite =
                                        !widget.event.isFavorite;
                                  });

                                  // Save the updated favorite status to persistent storage (e.g., database)
                                  // You can use a database or SharedPreferences to save this data
                                  // Example using SharedPreferences:
                                  // saveFavoriteStatus(widget.event);
                                },
                              )),
                          // Favorite Button
                          Positioned(
                            bottom: -4,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.event.eventName,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_city,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            widget.event.location,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            widget.event.date,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xF3F5EDF8),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Ticket price",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                widget.event.price,
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(widget.event.profileimg),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.event
                                              .username, // Display organizer's name
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text('Organizer'),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Comming soon..."),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff02cad0),
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xff02cad0)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Follow",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.event
                                  .eventdescription, // Access the event description
                              style: TextStyle(fontSize: 16),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20,),
                                  Text(
                                    "Venue Address:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4), // Optional spacing
                                  Text(
                                    widget.event.eventAddress,
                                    maxLines: 3, // Adjust the number of lines based on your layout
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10,),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Start Time:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget.event.starttime),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "End Time:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget.event.endtime),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            customizedbtn(
                              buttonText: "Buy Ticket",
                              textColor: Colors.white,
                              onPressed: () {
                                selectedEventController.selectEvent(widget.event); // Set the selected event
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckOutView(),
                                  ),
                                );
                              },

                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
